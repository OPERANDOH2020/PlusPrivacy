//
//  UIDevice+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "UIDevice+PPHOOK.h"
#import "NSObject+AutoSwizzle.h"
#import "PPApiHooksStart.h"

PPEventDispatcher *_devDispatcher;

@implementation UIDevice(PPHOOK)




+(void)load{
    [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
    PPApiHooks_registerHookedClass(self);
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher){
    _devDispatcher = dispatcher;
}

HOOKPrefixInstance(void, setProximityMonitoringEnabled:(BOOL)enabled) {
    
    
    __weak typeof(self) weakSelf = self;
    
    PPEventIdentifier eventType = PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceSetProximityMonitoringEnabled);
    
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximityMonitoringEnabledValue: @(enabled)
                                     } mutableCopy];
    
    __Weak(evData);
    
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setProximityMonitoringEnabled:[weakevData[kPPDeviceProximityMonitoringEnabledValue] boolValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:eventType moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    
      
    [_devDispatcher fireEvent:event  ];
       
}

HOOKPrefixInstance(void, setProximitySensingEnabled:(BOOL)enabled) {
    
    __weak typeof(self) weakSelf = self;
    PPEventIdentifier eventType = PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceSetProximitySensingEnabled);
    
    NSMutableDictionary *evData = [@{
                                     kPPDeviceProximitySensingEnabledValue: @(enabled)
                                     } mutableCopy];
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, setProximitySensingEnabled:[weakevData[kPPDeviceProximitySensingEnabledValue] boolValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:eventType moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
      
        [_devDispatcher fireEvent:event  ];
       
    
}

HOOKPrefixInstance(BOOL, proximityState) {
    
    
    BOOL actualProximityState = CALL_PREFIXED(self, proximityState);
    NSMutableDictionary *dict = [@{kPPDeviceProxmityStateValue: @(actualProximityState)                                 } mutableCopy];
    

    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetProximityState) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:dict whenNoHandlerAvailable:nil];
    
      
        [_devDispatcher fireEvent:event  ];
       
    
    NSNumber *possiblyModifiedValue = dict[kPPDeviceProxmityStateValue];
    if (!(possiblyModifiedValue && [possiblyModifiedValue isKindOfClass:[NSNumber class]])){
        return actualProximityState;
    }
    
    return [possiblyModifiedValue boolValue];
}

HOOKPrefixInstance(NSString*, name){
    
    NSString *actualName = CALL_PREFIXED(self, name);
    
    __block NSString *result = nil;
    
    result =  [_devDispatcher resultForEventValue:actualName ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetName) atKey:kPPDeviceNameValue  ];

    return  result;
}

HOOKPrefixInstance(NSString*, model){
    NSString *actualModel = CALL_PREFIXED(self, model);

    __block NSString *result;
      
        result =  [_devDispatcher resultForEventValue:actualModel ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetModel) atKey:kPPDeviceModelValue  ];
       
    
    return result;
}

HOOKPrefixInstance(NSString*, localizedModel){
    
    NSString *actualLocalizedModel = CALL_PREFIXED(self, localizedModel);
    
    __block NSString *value = nil;
    
      
        value = [_devDispatcher resultForEventValue:actualLocalizedModel ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetLocalizedModel) atKey:kPPDeviceLocalizedModelValue  ];
       
    
    return value;
}

HOOKPrefixInstance(NSString*, systemName){
    NSString *actualSystemName = CALL_PREFIXED(self, systemName);
    __block NSString *value = nil;
    
      
        value =  [_devDispatcher resultForEventValue:actualSystemName ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetSystemName) atKey:kPPDeviceSystemNameValue  ];
       
    return value;
}

HOOKPrefixInstance(NSString*, systemVersion){
    NSString *actualSystemVersion = CALL_PREFIXED(self, systemVersion);
    
    __block NSString *result = nil;
      
        result = [_devDispatcher resultForEventValue:actualSystemVersion ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetSystemVersion) atKey:kPPDeviceSystemVersionValue  ];
       
    return result;
}

HOOKPrefixInstance(NSString*, identifierForVendor) {
    NSString *actualUUID = CALL_PREFIXED(self, identifierForVendor);
    
    __block NSString *result = nil;
    
      
            result =  [_devDispatcher resultForEventValue:actualUUID ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetIdentifierForVendor) atKey:kPPDeviceUUIDValue  ];
       
    
    return result;
}

HOOKPrefixInstance(BOOL, isBatteryMonitoringEnabled){
    BOOL value = CALL_PREFIXED(self, isBatteryMonitoringEnabled);
    return [_devDispatcher resultForBoolEventValue:value ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceIsBatteryMonitoringEnabled) atKey:kPPDeviceIsBatteryMonitoringEnabledValue];
}


HOOKPrefixInstance(UIDeviceBatteryState, batteryState){
    UIDeviceBatteryState realState = CALL_PREFIXED(self, batteryState);
    return [[_devDispatcher resultForEventValue:@(realState) ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetBatteryState) atKey:kPPDeviceBatteryStateValue] integerValue];
}


HOOKPrefixInstance(float, batteryLevel){
    float realLevel = CALL_PREFIXED(self, batteryLevel);
    return [[_devDispatcher resultForEventValue:@(realLevel) ofIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceGetBatteryLevel) atKey:kPPDeviceBatteryLevelValue] floatValue];
}

HOOKPrefixInstance(void, setBatteryMonitoringEnabled:(BOOL)batteryMonitoringEnabled){
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPDeviceIsBatteryMonitoringEnabledValue] = @(batteryMonitoringEnabled);
    
    
    __Weak(evData);
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(self, setBatteryMonitoringEnabled:[weakevData[kPPDeviceIsBatteryMonitoringEnabledValue] boolValue]);
    };
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIDeviceEvent, EventDeviceSetBatteryMonitoringEnabled) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:confirmationOrDefault];
    
    [_devDispatcher fireEvent:event];
}

@end
