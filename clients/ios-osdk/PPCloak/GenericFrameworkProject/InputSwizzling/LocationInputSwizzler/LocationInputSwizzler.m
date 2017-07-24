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
#import "LocationManagerSubstituteDelegate.h"

#pragma mark - Helper class



#pragma mark -

@interface LocationInputSwizzler() <CLLocationManagerDelegate>
@property (strong, nonatomic) RandomWalkSwizzlerSettings *currentSettings;
@property (strong, nonatomic) LocationManagerSubstituteDelegate *substituteDelegate;

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
    
    
    self.substituteDelegate = [[LocationManagerSubstituteDelegate alloc] initWithLocationSubstituteCallback:^CLLocation * _Nullable(CLLocation * _Nonnull location) {
        CLLocation *sentLocation = [weakSelf locationSubstituteIfAny];
        if (!sentLocation) {
            sentLocation = location;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SAFECALL(weakSelf.whenLocationsAreRequested, @[sentLocation]);
        });
        
        return sentLocation;
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
        
        CLLocation *location = weakSelf.currentSettings.walkPath[weakSelf.indexOfCurrentSentLocation];
        [weakSelf.substituteDelegate broadcastToDelegatesLocation:location];
        
    }];
    
    [self.timer invalidate];
    
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
        [self.substituteDelegate removeDelegateAndManager:instance];
        SAFECALL(setDelegateConfirmation)
        return;
    }
    
    [self.substituteDelegate substituteDelegate:delegate forManager:instance];
    
    [event.eventData setObject:self forKey:kPPLocationManagerDelegate];
    SAFECALL(setDelegateConfirmation)
}


@end

