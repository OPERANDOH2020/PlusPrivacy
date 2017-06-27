//
//  CMAltimeter+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CMAltimeter+PPHOOK.h"
#import "PPApiHooksStart.h"

PPEventDispatcher *_altDispatcher;

@implementation CMAltimeter(PPHOOK)

+(void)load{
    if (NSClassFromString(@"CMAltimeter")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
        PPApiHooks_registerHookedClass(self);
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _altDispatcher = dispatcher;
}

HOOKPrefixClass(BOOL, isRelativeAltitudeAvailable){
    BOOL result = CALL_PREFIXED(self, isRelativeAltitudeAvailable);
    
    
    BOOL value =  [_altDispatcher resultForBoolEventValue:result ofIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterGetRelativeAltitudeAvailableValue) atKey:kPPAltimeterIsRelativeAltitudeVailableValue  ];
      
    
    
    return value;
}


HOOKPrefixInstance(void, startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)queue withHandler:(CMAltitudeHandler)handler) {
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPAltimeterUpdatesQueue, queue)
    SAFEADD(evData, kPPAltimeterUpdatesHandler, handler)
    
    __Weak(self);
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakself, startRelativeAltitudeUpdatesToQueue: weakevData[kPPAltimeterUpdatesQueue] withHandler: weakevData[kPPAltimeterUpdatesHandler]);
    };
    
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCMAltimeterEvent, EventAltimeterStartRelativeAltitudeUpdates) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
      
        [_altDispatcher fireEvent:event  ];
       
}

@end
