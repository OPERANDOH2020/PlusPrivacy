//
//  CLLocationManager+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CLLocationManager+PPHOOK.h"

PPEventDispatcher *_locDispatcher;

@implementation CLLocationManager(PPHOOK)

+(void)load {
    if (NSClassFromString(@"CLLocationManager")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
        PPApiHooks_registerHookedClass(self);
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _locDispatcher = dispatcher;
}

HOOKPrefixInstance(void, startUpdatingLocation){
    __weak typeof(self) weakSelf = self;
    
    [_locDispatcher fireEventWithMaxOneTimeExecution:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerStartLocationUpdates) executionBlock:^{
        CALL_PREFIXED(weakSelf, startUpdatingLocation);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}

HOOKPrefixInstance(void, requestAlwaysAuthorization) {
    
    __weak typeof(self) weakSelf = self;
    PPEventIdentifier identifier = PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestAlwaysAuthorization);
    
    [_locDispatcher fireEventWithMaxOneTimeExecution:identifier executionBlock:^{
        CALL_PREFIXED(weakSelf, requestAlwaysAuthorization);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}


HOOKPrefixInstance(void, requestWhenInUseAuthorization) {
    
    __weak typeof(self) weakSelf = self;
    [_locDispatcher fireEventWithMaxOneTimeExecution: PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerRequestWhenInUseAuthorization) executionBlock:^{
        CALL_PREFIXED(weakSelf, requestWhenInUseAuthorization);
    } executionBlockKey:kPPConfirmationCallbackBlock];
}


HOOKPrefixInstance(void, setDelegate:(id<CLLocationManagerDelegate>)delegate) {
    if (!delegate) {
        CALL_PREFIXED(self, setDelegate:(id<CLLocationManagerDelegate>)delegate);
        return;
    }
    
    NSMutableDictionary *evData = [@{} mutableCopy];
    __weak NSMutableDictionary *weakEvData = evData;
    
    
    __weak typeof(self) weakSelf = self;
    PPVoidBlock setDelegateConfirmation = ^{
        id possiblyModifiedDelegate = weakEvData[kPPLocationManagerDelegate];
        if (![possiblyModifiedDelegate conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
            return;
        }
        CALL_PREFIXED(weakSelf, setDelegate:possiblyModifiedDelegate);
    };
    
    [evData addEntriesFromDictionary:@{ kPPLocationManagerDelegate: delegate,
                                        kPPLocationManagerInstance: self,
                                        kPPLocationManagerSetDelegateConfirmation: setDelegateConfirmation
                                       }];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerSetDelegate) eventData:evData whenNoHandlerAvailable:setDelegateConfirmation];
    
    [_locDispatcher fireEvent:event];
}

HOOKPrefixInstance(CLLocation*, location) {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    CLLocation *actualLocation = CALL_PREFIXED(self, location);
    if (actualLocation) {
        [evData setObject:actualLocation forKey:kPPLocationManagerGetCurrentLocationValue];
    }
    
    [evData setObject:self forKey:kPPLocationManagerInstance];
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPLocationManagerEvent, EventLocationManagerGetCurrentLocation) eventData:evData whenNoHandlerAvailable:nil];
    
    [_locDispatcher fireEvent:event];
    
    CLLocation *possiblyModifiedLocation = evData[kPPLocationManagerGetCurrentLocationValue];
    
    if (!(possiblyModifiedLocation && [possiblyModifiedLocation isKindOfClass:[CLLocation class]])) {
        return nil;
    }
    
    return possiblyModifiedLocation;
}



@end

