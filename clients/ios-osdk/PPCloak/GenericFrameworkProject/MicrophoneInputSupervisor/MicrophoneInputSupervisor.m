//
//  MicrophoneInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MicrophoneInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"


BOOL isMicrophoneEvent(int subType, NSDictionary *evData){
    NSString *mediaTypeValue = evData[kPPCaptureDeviceMediaTypeValue];
    if (subType == EventCaptureDeviceGetDefaultDeviceWithMediaType &&
        [mediaTypeValue isEqualToString:AVMediaTypeAudio]) {
        return YES;
    }
    
    if (subType == EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition &&
        ([mediaTypeValue isEqualToString:AVMediaTypeAudio] ||
         [mediaTypeValue isEqualToString:AVMediaTypeMuxed])) {
            return YES;
        }
    
    return NO;
}

@interface MicrophoneInputSupervisor()
@property (strong, nonatomic) AccessedInput *micSensor;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation MicrophoneInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.micSensor = [CommonUtils extractInputOfType:InputType.Microphone from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPAVCaptureDeviceEvent) {
            if (isMicrophoneEvent(event.eventIdentifier.eventSubtype, event.eventData)) {
                [weakSelf processMicrophoneUsageEvent:event nextHandler:nextHandlerIfAny];
            } else {
                SAFECALL(nextHandlerIfAny)
            }
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processMicrophoneUsageEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.micSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
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

-(void)processEventNormally:(PPEvent*)event{
    
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.micSensor.inputType]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.micSensor) {
        return nil;
    }
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Microphone dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
