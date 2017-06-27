//
//  CMPedometer+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"
#import "NSObject+AutoSwizzle.h"
#import "CMPedometer+PPHOOK.h"
#import "PPApiHooksStart.h"

PPEventDispatcher *_pedDispatcher;

@implementation CMPedometer(PPHOOK)

+(void)load {
    
    if (NSClassFromString(@"CMPedometer")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
        PPApiHooks_registerHookedClass(self);
    }
    
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _pedDispatcher = dispatcher;
}

HOOKPrefixClass(BOOL, isStepCountingAvailable){
    BOOL result = CALL_PREFIXED(self, isStepCountingAvailable);
    
    
    BOOL value = NO;
    
    value =  [_pedDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetStepCountingAvailable) atKey:kPPPedometerIsStepCountingAvailableValue];
    
    return value;
}

HOOKPrefixClass(BOOL, isDistanceAvailable){
    BOOL result = CALL_PREFIXED(self, isDistanceAvailable);
    __block BOOL value = NO;
    
    value =  [_pedDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetDistanceAvailable) atKey:kPPPedometerIsDistanceAvailableValue ];
    
    return value;
}

HOOKPrefixClass(BOOL, isFloorCountingAvailable) {
    BOOL result = CALL_PREFIXED(self, isFloorCountingAvailable);
    
    __block BOOL value = NO;
    
        value =  [_pedDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetFloorCountingAvailable) atKey:kPPPedometerIsFloorCountingAvailableValue  ];
    
    return value;
}

HOOKPrefixClass(BOOL, isPaceAvailable){
    BOOL paceAv = CALL_PREFIXED(self, isPaceAvailable);
    
    __block BOOL value = NO;
    
      
                value =  [_pedDispatcher resultForBoolEventValue:paceAv ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetPaceAvailable) atKey:kPPPedometerIsPaceAvailableValue  ];
       
    
    return value;
}


HOOKPrefixClass(BOOL, isCadenceAvailable){
    BOOL result = CALL_PREFIXED(self, isCadenceAvailable);
    
    __block BOOL value = NO;
      
        value =  [_pedDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetCadenceAvailable) atKey:kPPPedometerIsCadenceAvailableValue  ];
       
    
    return value;
}

HOOKPrefixClass(BOOL, isPedometerEventTrackingAvailable){
    BOOL result = CALL_PREFIXED(self, isPedometerEventTrackingAvailable);
    
    __block BOOL value = NO;
    
      
        value =  [_pedDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerGetEventTrackingAvailable) atKey:kPPPedometerIsEventTrackingAvailableValue  ];
       

    
    return value;
}

HOOKPrefixInstance(void, queryPedometerDataFromDate:(NSDate *)start toDate:(NSDate *)end withHandler:(CMPedometerHandler)handler){
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPedometerStartDateValue, start)
    SAFEADD(evData, kPPPedometerEndDateValue, end)
    SAFEADD(evData, kPPPedometerHandlerValue, handler)
    
    __Weak(evData);
    __Weak(self);
    PPVoidBlock confirmationOrDefault = ^{
        NSDate *evStartDate = weakevData[kPPPedometerStartDateValue];
        NSDate *evEndDate = weakevData[kPPPedometerEndDateValue];
        CMPedometerHandler evHandler = weakevData[kPPPedometerHandlerValue];
        CALL_PREFIXED(weakself, queryPedometerDataFromDate:evStartDate toDate:evEndDate withHandler:evHandler);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerQueryDataFromDate) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
      
        [_pedDispatcher fireEvent:event  ];
       
    
}

HOOKPrefixInstance(void, startPedometerUpdatesFromDate:(NSDate *)start withHandler:(CMPedometerHandler)handler) {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    __weak NSMutableDictionary *weakData = evData;
    
    SAFEADD(evData, kPPPedometerUpdatesDateValue, start)
    SAFEADD(evData, kPPPedometerHandlerValue, handler)
    PPVoidBlock confirmation = ^{
        NSDate *possiblyModifiedDate = weakData[kPPPedometerUpdatesDateValue];
        CMPedometerHandler possiblyModifiedHandler = weakData[kPPPedometerHandlerValue];
        if (!(possiblyModifiedDate && possiblyModifiedHandler)) {
            return;
        }
        
        CALL_PREFIXED(weakSelf, startPedometerUpdatesFromDate:possiblyModifiedDate withHandler:possiblyModifiedHandler);
        
    };
    [evData setObject:confirmation forKey:kPPConfirmationCallbackBlock];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerStartUpdatesFromDate) eventData:evData whenNoHandlerAvailable:confirmation];
    
      
        [_pedDispatcher fireEvent:event  ];
       
}

HOOKPrefixInstance(void, startPedometerEventUpdatesWithHandler:(CMPedometerEventHandler)handler){
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPedometerEventUpdatesHandler, handler)
    __Weak(evData);
    __Weak(self);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakself, startPedometerEventUpdatesWithHandler:weakevData[kPPPedometerEventUpdatesHandler]);
    };
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPPedometerEvent, EventPedometerStartEventUpdatesWithHandler) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
      
        [_pedDispatcher fireEvent:event  ];
       
    
}


@end
