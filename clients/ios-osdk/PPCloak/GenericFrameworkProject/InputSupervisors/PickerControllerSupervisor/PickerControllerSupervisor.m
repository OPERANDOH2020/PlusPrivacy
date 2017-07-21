//
//  PickerControllerSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PickerControllerSupervisor.h"
#import "InputSupervisorModel.h"
#import <PPApiHooksCore/PPApiHooksCore.h>
#import "CommonUtils.h"
#import "Common.h"

@interface PickerControllerSupervisor()
@end

@implementation PickerControllerSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return event.eventIdentifier.eventType == PPUIImagePickerControllerEvent;
}

-(InputType *)monitoringInputType {
    return InputType.Camera;
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    event.eventData[kPPPickerControllerIsSourceTypeAvailableValue] = @(NO);
    event.eventData[kPPPickerControllerIsCameraDeviceAvailableValue] = @[];
    event.eventData[kPPPickerControllerIsCameraDeviceAvailableValue] = @(NO);
    event.eventData[kPPPickerControllerAvailableCaptureModesValue] = @[];
    event.eventData[kPPPickerControllerDelegateValue] = nil;
    event.eventData[kPPPickerControllerMediaTypesValue] = @[];
}


@end
