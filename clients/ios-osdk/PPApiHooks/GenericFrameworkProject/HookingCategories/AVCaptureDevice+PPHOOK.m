//
//  AVCaptureDevice+rsHookCamera.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "NSObject+AutoSwizzle.h"
#import "AVCaptureDevice+PPHOOK.h"
#import "PPEventDispatcher.h"
#import "PPApiHooksStart.h"

PPEventDispatcher *_avDispatcher;

@implementation AVCaptureDevice(PPHOOK)


+(void)load {
    if (NSClassFromString(@"AVCaptureDevice")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
        PPApiHooks_registerHookedClass(self);
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _avDispatcher = dispatcher;
}


HOOKPrefixClass(AVCaptureDevice*, defaultDeviceWithMediaType:(NSString *)mediaType){
    AVCaptureDevice *defaultDevice = CALL_PREFIXED(self, defaultDeviceWithMediaType:mediaType);
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPCaptureDeviceMediaTypeValue, defaultDevice)
    SAFEADD(evData, kPPCaptureDeviceDefaultDeviceValue, mediaType)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetDefaultDeviceWithMediaType) eventData:evData whenNoHandlerAvailable:nil];
    
      
        [_avDispatcher fireEvent:event  ];
       
    
    return evData[kPPCaptureDeviceDefaultDeviceValue];
}

HOOKPrefixClass(AVCaptureDevice*, defaultDeviceWithDeviceType:(AVCaptureDeviceType)deviceType mediaType:(NSString *)mediaType position:(AVCaptureDevicePosition)position){
    AVCaptureDevice *def = CALL_PREFIXED(self, defaultDeviceWithDeviceType:deviceType mediaType:mediaType position:position);
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    SAFEADD(eventData, kPPCaptureDeviceDefaultDeviceValue, def)
    SAFEADD(eventData, kPPCaptureDeviceMediaTypeValue, mediaType)
    eventData[kPPCaptureDevicePositionValue] = @(position);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition) eventData:eventData whenNoHandlerAvailable:nil];
    
      
        [_avDispatcher fireEvent:event  ];
       
    
    return eventData[kPPCaptureDeviceDefaultDeviceValue];
    
}


HOOKPrefixInstance(NSString*, uniqueID){
    NSString *result = CALL_PREFIXED(self, uniqueID);
    
    __block NSString *value = nil;
      
        value = [_avDispatcher resultForEventValue:result ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetUniqueId) atKey:kPPCaptureDeviceUniqueIdValue  ];
       
    
    return value;
}


HOOKPrefixInstance(NSString*, modelID){
    NSString *result = CALL_PREFIXED(self, modelID);
    
    __block NSString *value = nil;
      
        value = [_avDispatcher resultForEventValue:result ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetModelId) atKey:kPPCaptureDeviceModelIdValue  ];
       
    
    return value;
}

HOOKPrefixInstance(BOOL, hasMediaType:(NSString *)mediaType){
    BOOL result = CALL_PREFIXED(self, hasMediaType: mediaType);
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPCaptureDeviceMediaTypeValue, mediaType)
    evData[kPPCaptureDeviceHasMediaTypeResult] = @(result);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceHasMediaType) eventData:evData whenNoHandlerAvailable:nil];
    
      
            [_avDispatcher fireEvent:event  ];
       
    
    return [evData[kPPCaptureDeviceHasMediaTypeResult] boolValue];
}


HOOKPrefixInstance(BOOL, lockForConfiguration:(NSError *__autoreleasing *)outError){
    
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceLockForConfiguration) eventData:eventData whenNoHandlerAvailable:nil];
    
      
        [_avDispatcher fireEvent:event  ];
       
    
    if ([eventData[kPPCaptureDeviceConfirmationBool] boolValue]) {
        return CALL_PREFIXED(self, lockForConfiguration: outError);
    }
    
    *outError = eventData[kPPCaptureDeviceErrorValue];
    return NO;
}

HOOKPrefixClass(BOOL, supportsAVCaptureSessionPreset:(NSString *)preset){
    NSMutableDictionary *eventData = [[NSMutableDictionary alloc] init];
    SAFEADD(eventData, kPPAVPresetValue, preset)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceSupportsSessionPreset) eventData:eventData whenNoHandlerAvailable:nil];
    
      
        [_avDispatcher fireEvent:event  ];
       
    
    if ([eventData[kPPCaptureDeviceConfirmationBool] boolValue]) {
        return CALL_PREFIXED(self, supportsAVCaptureSessionPreset: preset);
    }
    
    return NO;
}


HOOKPrefixInstance(BOOL, isConnected){
    BOOL connected = CALL_PREFIXED(self, isConnected);
    
    __block BOOL value = NO;
      
        value = [_avDispatcher resultForBoolEventValue:connected ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetIsConnected) atKey:kPPCaptureDeviceConfirmationBool  ];
       
    
    return value;
}

HOOKPrefixInstance(NSArray*, formats){
    NSArray *formats = CALL_PREFIXED(self, formats);
    
    __block NSArray *value = nil;
      
            value = [_avDispatcher resultForEventValue:formats ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetFormats) atKey:kPPCaptureDeviceFormatsArrayValue  ];
       
    return value;
}

HOOKPrefixInstance(AVCaptureDeviceFormat*, activeFormat){
    AVCaptureDeviceFormat *format = CALL_PREFIXED(self, activeFormat);
    __block AVCaptureDeviceFormat *value = nil;
    
      
        value = [_avDispatcher resultForEventValue:format ofIdentifier:PPEventIdentifierMake(PPAVCaptureDeviceEvent, EventCaptureDeviceGetActiveFormat) atKey:kPPCaptureDeviceActiveFormatValue  ];
       
    
    return value;
}

@end
