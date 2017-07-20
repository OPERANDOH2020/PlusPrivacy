//
//  GyroscopeInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "GyroscopeInputSupervisor.h"
#import "CommonUtils.h"
#import <PPApiHooksCore/PPApiHooksCore.h>
#import "NSArray+ContainsAnyFromArray.h"
#import "Common.h"


BOOL isGyroEvent(int eventSubtype){
    return eventSubtype == EventMotionManagerIsGyroActive ||
           eventSubtype == EventMotionManagerIsGyroAvailable ||
           eventSubtype == EventMotionManagerStartGyroUpdates ||
           eventSubtype == EventMotionManagerSetGyroUpdateInterval ||
           eventSubtype == EventMotionManagerStartGyroUpdatesToQueueUsingHandler ||
    eventSubtype == EventMotionManagerGetCurrentGyroData;
}

@interface GyroscopeInputSupervisor()
@property (strong, nonatomic) AccessedInput *gyroInput;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation GyroscopeInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.gyroInput = [CommonUtils extractInputOfType:InputType.Gyroscope from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [self.model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isGyroEvent(event.eventIdentifier.eventSubtype)) {
            [weakSelf processGyroEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
    
}



-(void)processGyroEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler{
    
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.gyroInput.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.gyroInput.inputType date:[NSDate date]]];
        return;
    }
    
    
    PPUnlistedInputAccessViolation *report;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    SAFECALL(nextHandler)
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerGetCurrentGyroDataValue] = nil;
    event.eventData[kPPMotionManagerIsGyroActiveValue] = @(NO);
    event.eventData[kPPMotionManagerIsGyroAvailableValue] = @(NO);
    
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.gyroInput) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:self.gyroInput.inputType dateReported:[NSDate date]];
}

@end
