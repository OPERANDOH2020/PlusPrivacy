//
//  UIImagePickerController+PPHOOK.m
//  PPUIPickerControllerHooks
//
//  Created by Costin Andronache on 7/12/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#import "UIImagePickerController+PPHOOK.h"
#import <PPApiHooksCore/PPApiHooksCore.h>

@interface UIImagePickerController(PPHOOK)

@end

@implementation UIImagePickerController (PPHOOK)


+(void)load{
    [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
}

HOOKPrefixClass(BOOL, isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType){
    
    BOOL value = CALL_PREFIXED(self, isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType);
    
    NSMutableDictionary *evData = [@{kPPPickerControllerSourceTypeValue: @(sourceType),
                                     kPPPickerControllerIsSourceTypeAvailableValue: @(value)} mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerIsSourceTypeAvailable) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:nil];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    
    return [evData[kPPPickerControllerIsSourceTypeAvailableValue] boolValue];
    
}
HOOKPrefixClass(NSArray<NSString*>*, availableMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType){
    
    NSArray *mediaTypes = CALL_PREFIXED(self, availableMediaTypesForSourceType: sourceType);
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPickerControllerMediaTypesValue, mediaTypes)
    evData[kPPPickerControllerSourceTypeValue] = @(sourceType);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerAvailableMediaTypesForSourceType) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:nil];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    return evData[kPPPickerControllerMediaTypesValue];
}

HOOKPrefixClass(BOOL, isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice){
    
    BOOL value = CALL_PREFIXED(self, isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice);
    
    NSMutableDictionary *evData = [@{kPPPickerControllerCameraDeviceValue: @(cameraDevice), kPPPickerControllerIsCameraDeviceAvailableValue: @(value)} mutableCopy];
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerIsCameraDeviceAvailable) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:nil];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    
    return [evData[kPPPickerControllerIsCameraDeviceAvailableValue] boolValue];
}

HOOKPrefixClass(NSArray<NSNumber*>*, availableCaptureModesForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice){
    
    NSArray *modes = CALL_PREFIXED(self, availableCaptureModesForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice);
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPPickerControllerAvailableCaptureModesValue, modes)
    evData[kPPPickerControllerCameraDeviceValue] = @(cameraDevice);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerAvailableCaptureModesForCameraDevice) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:nil];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    return evData[kPPPickerControllerAvailableCaptureModesValue];
}


HOOKPrefixInstance(void, setDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate){
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    
    __Weak(evData);
    PPVoidBlock confirmation = ^{
        CALL_PREFIXED(self, setDelegate:weakevData[kPPPickerControllerDelegateValue]);
  
    };
    SAFEADD(evData, kPPPickerControllerDelegateValue, delegate)
    evData[kPPPickerControllerInstanceValue] = self;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerSetDelegate) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:confirmation];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    
}


HOOKPrefixInstance(void, setSourceType:(UIImagePickerControllerSourceType)sourceType){
    
    NSMutableDictionary *evData = [@{kPPPickerControllerSourceTypeValue: @(sourceType)} mutableCopy];
    
    __Weak(evData);
    PPVoidBlock confirmation = ^{
        CALL_PREFIXED(self, setSourceType:[weakevData[kPPPickerControllerSourceTypeValue] integerValue]);
    };
    evData[kPPConfirmationCallbackBlock] = confirmation;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerSetSourceType) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:evData whenNoHandlerAvailable:confirmation];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
    
}


HOOKPrefixInstance(void, takePicture){
    
    PPVoidBlock confirmation = ^{
        CALL_PREFIXED(self, takePicture);
    };
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerTakePicture) moduleNamesInCallStack:kPPCurrentCallStackModuleNames eventData:nil whenNoHandlerAvailable:confirmation];
    
    [PPEventDispatcher.sharedInstance fireEvent:event];
}


HOOKPrefixInstance(BOOL, startVideoCapture){
    
    BOOL shouldStart = [PPEventDispatcher.sharedInstance resultForBoolEventValue:NO ofIdentifier:PPEventIdentifierMake(PPUIImagePickerControllerEvent, EventPickerControllerStartVideoCapture) atKey:kPPPickerControllerShouldStartVideoCaptureValue];
    
    if (shouldStart) {
        return CALL_PREFIXED(self, startVideoCapture);
    }
    
    return NO;
}

@end
