//
//  RandomWalkSwizzlerSettings.m
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//  

#import "RandomWalkSwizzlerSettings.h"


@interface RandomWalkSwizzlerSettings()
@property (readwrite, strong, nonatomic) RandomWalkBoundCircle *boundCircle;
@property (readwrite, strong, nonatomic) NSArray<CLLocation*> *walkPath;
@property (readwrite, assign, nonatomic) BOOL enabled;
@end


@implementation RandomWalkSwizzlerSettings

+(RandomWalkSwizzlerSettings *)createFromDefaults:(NSUserDefaults *)defaults error:(NSError *__autoreleasing *)error {
    RandomWalkSwizzlerSettings *settings = [[RandomWalkSwizzlerSettings alloc] init];
    
    
    NSArray *latitudesArray = [defaults arrayForKey:kRandomWalkPathLatitudes];
    NSArray *longitudesArray = [defaults arrayForKey:kRandomWalkPathLongitudes];
    
    Class numberClass = [NSNumber class];
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
    if (latitudesArray.count == longitudesArray.count) {
        for (int i = 0; i<latitudesArray.count; i++) {
            NSNumber *lat = latitudesArray[i];
            NSNumber *lon = longitudesArray[i];
            if ([lat isKindOfClass:numberClass] && [lon isKindOfClass:numberClass]) {
                [locationsArray addObject:[[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue]];
            }
        }
    }
    
    NSNumber *circleCenterLat = [defaults objectForKey:kCircleCenterLatitude];
    NSNumber *circleCenterLon = [defaults objectForKey:kCircleCenterLongitude];
    NSNumber *radiusKM = [defaults objectForKey:kCircleRadiusKM];
    
    if (([circleCenterLat isKindOfClass:numberClass] && [circleCenterLon isKindOfClass:numberClass] &&
         [radiusKM isKindOfClass:numberClass])) {
        RandomWalkBoundCircle *circle = [[RandomWalkBoundCircle alloc] initWithCenter:CLLocationCoordinate2DMake(circleCenterLat.doubleValue, circleCenterLon.doubleValue) radiusInKm:radiusKM.doubleValue];
        settings.boundCircle = circle;
    }
    
    settings.enabled = [defaults boolForKey:kRandomWalkEnabled];
    settings.walkPath = locationsArray;
    
    
    return settings;
}

-(void)synchronizeToDefaults:(NSUserDefaults *)defaults {
    NSMutableArray *latArray = [[NSMutableArray alloc] init];
    NSMutableArray *lonArray = [[NSMutableArray alloc] init];
    for (CLLocation *loc in self.walkPath) {
        [latArray addObject:@(loc.coordinate.latitude)];
        [lonArray addObject:@(loc.coordinate.longitude)];
    }
    
    [defaults setObject:latArray forKey:kRandomWalkPathLatitudes];
    [defaults setObject:lonArray forKey:kRandomWalkPathLongitudes];
    [defaults setBool:self.enabled forKey:kRandomWalkEnabled];
    [defaults setObject:@(self.boundCircle.center.latitude) forKey:kCircleCenterLatitude];
    [defaults setObject:@(self.boundCircle.center.longitude) forKey:kCircleCenterLongitude];
    [defaults setObject:@(self.boundCircle.radiusInKm) forKey:kCircleRadiusKM];
}


+(RandomWalkSwizzlerSettings *)createWithCircle:(RandomWalkBoundCircle *)circle walkPath:(NSArray<CLLocation *> *)walkPath enabled:(BOOL)enabled error:(NSError *__autoreleasing *)error {
    
    RandomWalkSwizzlerSettings *settings = [[RandomWalkSwizzlerSettings alloc] init];
    settings.enabled = enabled;
    settings.walkPath = walkPath;
    settings.boundCircle = circle;
    
    return settings;
}

@end
