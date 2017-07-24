//
//  LocationManagerSubstituteDelegate.m
//  PPCloak
//
//  Created by Costin Andronache on 7/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationManagerSubstituteDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Common.h"

@interface WeakLocationManagerWrapper : NSObject
@property (weak, nonatomic) CLLocationManager *manager;
@property (weak, nonatomic) id<CLLocationManagerDelegate> delegate;

@property (strong, nonatomic) void(^onLocationManagerDestruction)();
@end

@implementation WeakLocationManagerWrapper

-(void)setManager:(CLLocationManager *)manager {
    _manager = manager;
    if (manager == nil) {
        SAFECALL(self.onLocationManagerDestruction)
    }
}

@end

@interface LocationManagerSubstituteDelegate() <CLLocationManagerDelegate>
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, WeakLocationManagerWrapper*> *wrappersPerManagerHash;
@property (strong, nonatomic) SubstituteLocationCallback locationSubstituteRetrieve;
@end

@implementation LocationManagerSubstituteDelegate

-(instancetype)initWithLocationSubstituteCallback:(SubstituteLocationCallback)callback {
    if (self = [super init]) {
        self.wrappersPerManagerHash = [[NSMutableDictionary alloc] init];
        self.locationSubstituteRetrieve = callback;
    }
    return self;
}

-(void)substituteDelegate:(id<CLLocationManagerDelegate>)delegate forManager:(CLLocationManager *)manager {
    NSInteger hash = manager.hash;
    WeakLocationManagerWrapper *existentWrapper = self.wrappersPerManagerHash[@(hash)];
    
    if (!existentWrapper) {
        WEAKSELF
        existentWrapper = [[WeakLocationManagerWrapper alloc] init];
        existentWrapper.manager = manager;
        existentWrapper.onLocationManagerDestruction = ^{
            [weakSelf.wrappersPerManagerHash removeObjectForKey:@(hash)];
        };
        [self.wrappersPerManagerHash setObject:existentWrapper forKey:@(hash)];
    }
    
    existentWrapper.delegate = delegate;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *replacedLocation = self.locationSubstituteRetrieve(locations.firstObject);
    if (replacedLocation) {
        [[self delegateForManager:manager] locationManager:manager didUpdateLocations:@[replacedLocation]];
    }
}



-(id<CLLocationManagerDelegate>)delegateForManager:(CLLocationManager*)manager {
    return self.wrappersPerManagerHash[@(manager.hash)].delegate;
}

-(void)removeDelegateAndManager:(CLLocationManager *)locationManager {
    [self.wrappersPerManagerHash removeObjectForKey:@(locationManager.hash)];
}

-(void)broadcastToDelegatesLocation:(CLLocation *)location {
    for (WeakLocationManagerWrapper *wrapper in self.wrappersPerManagerHash.allValues) {
        [wrapper.delegate locationManager:wrapper.manager didUpdateLocations:@[location]];
    }
}



-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    [[self delegateForManager:manager] locationManager:manager didVisit:visit];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [[self delegateForManager:manager] locationManager:manager didExitRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [[self delegateForManager:manager] locationManager:manager didEnterRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [[self delegateForManager:manager] locationManager:manager didFailWithError:error];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    [[self delegateForManager:manager] locationManager:manager didUpdateHeading:newHeading];
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [[self delegateForManager:manager] locationManagerDidPauseLocationUpdates:manager];
}

-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [[self delegateForManager:manager] locationManagerDidResumeLocationUpdates:manager];
}

@end
