//
//  LocationInputSwizzler.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSwizzler.h"
#import <CoreLocation/CoreLocation.h>
#import "JRSwizzle.h"
#import "Common.h"
#import <PPApiHooksCore/PPApiHooksCore.h>

#pragma mark - Helper class

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

#pragma mark -

@interface LocationInputSwizzler() <CLLocationManagerDelegate>
@property (strong, nonatomic) RandomWalkSwizzlerSettings *currentSettings;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, WeakLocationManagerWrapper*> *wrappersPerManagerHash;
@property (strong, nonatomic) NSMutableArray<CurrentActiveLocationIndexChangedCallback> *callbacksToNotifyChange;
@property (strong, nonatomic) LocationsCallback whenLocationsAreRequested;
@property (strong, nonatomic) NSTimer *timer;
@property (readwrite, assign, nonatomic) NSInteger indexOfCurrentSentLocation;
@end


@implementation LocationInputSwizzler

-(void)setupWithSettings:(RandomWalkSwizzlerSettings *)settings eventsDispatcher:(PPEventDispatcher *)eventsDispatcher whenLocationsAreRequested:(LocationsCallback)whenLocationsAreRequested {
    
    self.callbacksToNotifyChange = [[NSMutableArray alloc] init];
    
    [self applyNewRandomWalkSettings:settings];
    
    self.whenLocationsAreRequested = whenLocationsAreRequested;
    __weak typeof(self) weakSelf = self;
    
    [eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        if (event.eventIdentifier.eventType != PPLocationManagerEvent) {
            SAFECALL(nextHandlerIfAny)
            return;
        }
        
        if (event.eventIdentifier.eventSubtype == EventLocationManagerGetCurrentLocation) {
            [weakSelf processAskForLocationEvent:event];
        }
        
        if (event.eventIdentifier.eventSubtype == EventLocationManagerSetDelegate) {
            [weakSelf processSetDelegateEvent:event];
        }
        
        SAFECALL(nextHandlerIfAny)
        
    }];
}

-(void)registerNewChangeCallback:(CurrentActiveLocationIndexChangedCallback)callback {
    if (![self.callbacksToNotifyChange containsObject:callback]) {
        [self.callbacksToNotifyChange addObject:callback];
    }
}

-(void)removeChangeCallback:(CurrentActiveLocationIndexChangedCallback)callback {
    [self.callbacksToNotifyChange removeObject:callback];
}

+(LocationInputSwizzler *)sharedInstance {
    static LocationInputSwizzler* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocationInputSwizzler alloc] init];
    });
    
    return  _sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.wrappersPerManagerHash = [[NSMutableDictionary alloc] init];
    }

    return self;
}


-(void)applyNewRandomWalkSettings:(RandomWalkSwizzlerSettings *)settings{
    
    self.currentSettings = settings;
    [self.timer invalidate];
    self.indexOfCurrentSentLocation = 0;
    
    if (!settings.enabled) {
        return;
    }
    
    __block NSInteger direction = 1;
    WEAKSELF
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        weakSelf.indexOfCurrentSentLocation += direction;
        if (weakSelf.indexOfCurrentSentLocation < 0) {
            weakSelf.indexOfCurrentSentLocation = 0;
            direction = 1;
            
        } else {
            if (weakSelf.indexOfCurrentSentLocation >= settings.walkPath.count) {
                weakSelf.indexOfCurrentSentLocation = settings.walkPath.count - 1;
                direction = -1;
            }
        }
        for (CurrentActiveLocationIndexChangedCallback callback in weakSelf.callbacksToNotifyChange) {
            callback(weakSelf.indexOfCurrentSentLocation);
        }
        
        for (WeakLocationManagerWrapper *wrapper in self.wrappersPerManagerHash.allValues) {
            [wrapper.delegate locationManager:wrapper.manager didUpdateLocations:@[weakSelf.currentSettings.walkPath[weakSelf.indexOfCurrentSentLocation]]];
        }
        
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:operation selector:@selector(main) userInfo:nil repeats:YES];
    
}

-(CLLocation*)locationSubstituteIfAny {
    if (!(self.currentSettings && self.currentSettings.enabled)) {
        return nil;
    }
    
    if (self.indexOfCurrentSentLocation < 0 || self.indexOfCurrentSentLocation >= self.currentSettings.walkPath.count) {
        return nil;
    }
    
    return self.currentSettings.walkPath[self.indexOfCurrentSentLocation];
}



-(void)processAskForLocationEvent:(PPEvent*)event {
    CLLocation *location = event.eventData[kPPLocationManagerGetCurrentLocationValue];
    CLLocation *modifiedLocation = [self locationSubstituteIfAny];
    
    if (!modifiedLocation) {
        if (location) {
            SAFECALL(self.whenLocationsAreRequested, @[location])
        }
        return;
    }
    
    [event.eventData setObject:modifiedLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    
    SAFECALL(self.whenLocationsAreRequested, @[modifiedLocation])
}

-(void)processSetDelegateEvent:(PPEvent*)event {
    id<CLLocationManagerDelegate> delegate = event.eventData[kPPLocationManagerDelegate];
    CLLocationManager *instance = event.eventData[kPPLocationManagerInstance];
    PPVoidBlock setDelegateConfirmation = event.eventData[kPPLocationManagerSetDelegateConfirmation];
    
    if (delegate == nil) {
        [self.wrappersPerManagerHash removeObjectForKey:@(instance.hash)];
        SAFECALL(setDelegateConfirmation)
        return;
    }
    
    [self saveDelegate:delegate forManager:instance];
    
    [event.eventData setObject:self forKey:kPPLocationManagerDelegate];
    SAFECALL(setDelegateConfirmation)
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSArray *locationsForDelegates = nil;
    CLLocation *replacedLocation = [self locationSubstituteIfAny];
    if (replacedLocation) {
        locationsForDelegates = @[replacedLocation];
    } else {
        locationsForDelegates = locations;
    }
    
    [[self delegateForManager:manager] locationManager:manager didUpdateLocations:locationsForDelegates];
    SAFECALL(self.whenLocationsAreRequested, locationsForDelegates)
}

-(void)saveDelegate:(id<CLLocationManagerDelegate>)delegate forManager:(CLLocationManager*)manager {
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
    
    NSLog(@"did save delegate: %@, for location manager: %@", delegate, manager);
}

-(id<CLLocationManagerDelegate>)delegateForManager:(CLLocationManager*)manager {
    return self.wrappersPerManagerHash[@(manager.hash)].delegate;
}

@end

