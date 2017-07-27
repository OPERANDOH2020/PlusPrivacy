//
//  PPInputSwizzlingModule.m
//  PPCloak
//
//  Created by Costin Andronache on 7/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPInputSwizzlingModule.h"
#import "LocationInputSwizzler.h"

@interface PPInputSwizzlingModule()
@property (strong, nonatomic) LocationInputSwizzler *locationInputSwizzler;
@end

@implementation PPInputSwizzlingModule

-(void)installInputSwizzlerOnEventDispatcher:(PPEventDispatcher *)eventsDispatcher {
    
    [self setupLocationInputSwizzlerUsingDispatcher:eventsDispatcher];
}


-(void)setupLocationInputSwizzlerUsingDispatcher:(PPEventDispatcher*)eventsDispatcher {
    
    NSError *error = nil;
    RandomWalkSwizzlerSettings *defaultLocationSettings = [RandomWalkSwizzlerSettings createFromDefaults: [NSUserDefaults standardUserDefaults] error:&error];
    
    if (error) {
        RandomWalkBoundCircle *circle = [[RandomWalkBoundCircle alloc] initWithCenter:CLLocationCoordinate2DMake(64.754800,  -147.343051) radiusInKm:1];
        defaultLocationSettings = [RandomWalkSwizzlerSettings createWithCircle:circle walkPath:@[] enabled:NO error:nil];
    }
    
    self.locationInputSwizzler = [[LocationInputSwizzler alloc] init];
    [self.locationInputSwizzler applyNewRandomWalkSettings:defaultLocationSettings];
    
    
    [self.locationInputSwizzler setupWithSettings:defaultLocationSettings eventsDispatcher:eventsDispatcher whenLocationsAreRequested:^(NSArray<CLLocation *> * _Nonnull locations) {
        
    }];
}

@end
