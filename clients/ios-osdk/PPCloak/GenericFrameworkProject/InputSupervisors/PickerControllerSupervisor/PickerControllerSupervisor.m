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
@property (strong, nonatomic) AccessedInput *camSensor;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation PickerControllerSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model{
    self.model = model;
    self.camSensor = [CommonUtils extractInputOfType:InputType.Camera from:model.scdDocument.accessedInputs];
    
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPUIImagePickerControllerEvent) {
            [self processUIPickerControllerEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processUIPickerControllerEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.camSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.camSensor.inputType date:[NSDate date]]];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = [self detectUnregisteredAccess];
    if (report) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    [self processEventNormally:event];
    SAFECALL(nextHandler)
}


-(void)processEventNormally:(PPEvent*)event {
    
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.camSensor) {
        return nil;
        
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:self.camSensor.inputType dateReported:[NSDate date]];
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

-(NSDictionary*)deniedValuesPerEventSubtype {
    static NSMutableDictionary *values = nil;
    if (values) {
        return values;
    }
    
    values = [[NSMutableDictionary alloc] init];

    return values;
}

@end
