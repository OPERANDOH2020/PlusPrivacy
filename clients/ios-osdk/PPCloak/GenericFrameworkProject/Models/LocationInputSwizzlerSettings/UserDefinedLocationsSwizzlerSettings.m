//
//  UserDefinedLocationsSwizzlerSettings.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UserDefinedLocationsSwizzlerSettings.h"

#pragma mark -

static NSString *kOverrideLocationEnabledKey = @"kOverrideLocationEnabledKey";
static NSString *kOverrideLocationLatitudesKey = @"kOverrideLocationLatitudesKey";
static NSString *kOverrideLocationLongitudesKey = @"kOverrideLocationLongitudesKey";
static NSString *kOverrideLocationCycleKey = @"kOverrideLocationCycleKey";
static NSString *kOverrideLocationChangeInterval = @"kOverrideLocationChangeInterval";

@interface UserDefinedLocationsSwizzlerSettings()

@property (readwrite, nonatomic, strong) NSArray<CLLocation*> *locations;
@property (readwrite, assign, nonatomic) BOOL enabled;
@property (readwrite, assign, nonatomic) BOOL cycle;
@property (readwrite, assign, nonatomic) NSTimeInterval changeInterval;
@end

static NSString *kErrorDomain = @"com.plusPrivacy.LocationSettings";

@implementation UserDefinedLocationsSwizzlerSettings

+(UserDefinedLocationsSwizzlerSettings *)createWithLocations:(NSArray<CLLocation *> *)locations enabled:(BOOL)enabled cycle:(BOOL)cycle changeInterval:(NSTimeInterval)changeInterval error:(NSError *__autoreleasing  _Nullable * _Nullable)error{
    
    if (enabled && locations.count == 0) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:kErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Cannot enable location override with no locations"}];
        }
        return nil;
    }
    
    if (enabled && changeInterval < 1) {
        if (error) {
            *error = [NSError errorWithDomain:kErrorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Cannot set change interval to less than 1 second"}];
        }
        return nil;
    }
    
    UserDefinedLocationsSwizzlerSettings *settings = [[UserDefinedLocationsSwizzlerSettings alloc] init];
    settings.enabled = enabled;
    settings.cycle = cycle;
    settings.locations = locations;
    settings.changeInterval = changeInterval;
    return settings;
    
}

+(UserDefinedLocationsSwizzlerSettings *)createFromUserDefaults:(NSUserDefaults*)defaults error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    
    UserDefinedLocationsSwizzlerSettings *settings = [[UserDefinedLocationsSwizzlerSettings alloc] init];
    
    NSArray<NSNumber*> *latitudes = [defaults valueForKey:kOverrideLocationLatitudesKey];
    NSArray<NSNumber*> *longitudes = [defaults valueForKey:kOverrideLocationLongitudesKey];
    NSMutableArray<CLLocation*> *locations = [[NSMutableArray alloc] init];
    
    
    if (latitudes.count == longitudes.count) {
        for (int i=0; i<latitudes.count; i++) {
            NSNumber *latitude = latitudes[i];
            NSNumber *longitude = longitudes[i];
            if ([latitude isKindOfClass:[NSNumber class]] && [longitude isKindOfClass:[NSNumber class]]) {
                CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
                [locations addObject:location];
            }
        }
    }
    
    settings.enabled = [[defaults valueForKey:kOverrideLocationEnabledKey] boolValue];
    settings.changeInterval = [[defaults valueForKey:kOverrideLocationChangeInterval] doubleValue];
    settings.cycle = [[defaults valueForKey:kOverrideLocationCycleKey] boolValue];
    settings.locations = locations;
    
    if (settings.enabled && settings.locations.count == 0) {
        if (error) {
            *error = [NSError errorWithDomain:kErrorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Data corrupted. Cannot enable location override with no locations"}];
        }
        
        return nil;
    }
    
    if (settings.enabled && settings.changeInterval < 1) {
        if (error) {
            *error = [NSError errorWithDomain:kErrorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Data corrupted. Cannot set change interval to less than 1 second"}];
        }
        return nil;
    }
    
    return settings;
}

-(void)synchronizeToUserDefaults:(NSUserDefaults*)defaults {
    
    NSMutableArray<NSNumber*> *latArray = [[NSMutableArray alloc] init],
                              *longArray = [[NSMutableArray alloc] init];
    
    
    for (CLLocation *location in self.locations) {
        [latArray addObject:@(location.coordinate.latitude)];
        [longArray addObject:@(location.coordinate.longitude)];
    }
    
    [defaults setValue:latArray forKey:kOverrideLocationLatitudesKey];
    [defaults setValue:longArray forKey:kOverrideLocationLongitudesKey];
    
    [defaults setValue:@(self.cycle) forKey:kOverrideLocationCycleKey];
    [defaults setValue:@(self.changeInterval) forKey:kOverrideLocationChangeInterval];
    [defaults setValue:@(self.enabled) forKey:kOverrideLocationEnabledKey];
}

@end
