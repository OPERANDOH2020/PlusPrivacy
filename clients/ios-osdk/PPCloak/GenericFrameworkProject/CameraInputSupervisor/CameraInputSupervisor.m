//
//  CameraInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CameraInputSupervisor.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "CommonUtils.h"
#import "JRSwizzle.h"

BOOL isCameraEvent(int subType, NSDictionary *evData){
    
    NSString *mediaTypeValue = evData[kPPCaptureDeviceMediaTypeValue];
    if (subType == EventCaptureDeviceGetDefaultDeviceWithMediaType &&
        [mediaTypeValue isEqualToString:AVMediaTypeVideo]) {
        return YES;
    }
    
    if (subType == EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition &&
        ([mediaTypeValue isEqualToString:AVMediaTypeVideo] ||
         [mediaTypeValue isEqualToString:AVMediaTypeMuxed])) {
            return YES;
    }
    
    return NO;
}


@interface AVCameraInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *cameraSensor;

@end

@implementation AVCameraInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.cameraSensor = [CommonUtils extractInputOfType: InputType.Camera from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPAVCaptureDeviceEvent) {
            if (isCameraEvent(event.eventIdentifier.eventSubtype, event.eventData)) {
                [weakSelf processCameraAccessEvent:event nextHandler:nextHandlerIfAny];
            } else {
                SAFECALL(nextHandlerIfAny)
            }
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processCameraAccessEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.cameraSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    [self processEventNormally:event];
    SAFECALL(nextHandler)
}

-(void)processEventNormally:(PPEvent*)event {
    
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.cameraSensor.inputType date:[NSDate date]]];
}

-(void)processPhotoLibraryAccess {
    [self processCameraAccess];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.cameraSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Camera dateReported:[NSDate date]];
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
