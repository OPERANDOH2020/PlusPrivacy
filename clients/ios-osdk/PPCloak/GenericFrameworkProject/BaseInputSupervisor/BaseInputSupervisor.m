//
//  BaseInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BaseInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"

@implementation BaseInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.accessedInput = [CommonUtils extractInputOfType:self.monitoringInputType from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        if ([weakSelf isEventOfInterest:event]) {
            [weakSelf processEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
    }];
}

-(void)processEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.accessedInput.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.accessedInput.inputType date:[NSDate date]]];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = [self detectUnregisteredAccess];
    if (report) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    [self specificProcessOfEvent:event nextHandler:nextHandler];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess{
    if (self.accessedInput) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:self.monitoringInputType dateReported:[NSDate date]];
}




//-protected methods, must be overriden by subclasses

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return NO;
}
-(InputType *)monitoringInputType {
    //let's default to the first one
    return InputType.Accelerometer;
}

-(void)specificProcessOfEvent:(PPEvent *)event nextHandler:(NextHandlerConfirmation)nextHandler {
    SAFECALL(nextHandler);
}

-(void)denyValuesOrActionsForModuleName:(NSString *)moduleName inEvent:(PPEvent *)event {
    
}

@end
