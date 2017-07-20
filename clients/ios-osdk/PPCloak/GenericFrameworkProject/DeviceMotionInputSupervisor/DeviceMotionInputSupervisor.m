//
//  DeviceMotionInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "DeviceMotionInputSupervisor.h"
#import <PPApiHooksCore/PPApiHooksCore.h>
#import "Common.h"
#import "CommonUtils.h"
#import "NSArray+ContainsAnyFromArray.h"


BOOL isDeviceMotionEvent(int eventSubtype){
    return eventSubtype == EventMotionManagerIsDeviceMotionActive ||
           eventSubtype == EventMotionManagerIsDeviceMotionAvailable ||
           eventSubtype == EventMotionManagerStartDeviceMotionUpdates ||
           eventSubtype == EventMotionManagerGetCurrentDeviceMotionData ||
           eventSubtype == EventMotionManagerSetDeviceMotionUpdateInterval ||
           eventSubtype == EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrame ||
    eventSubtype == EventMotionManagerStartDeviceMotionUpdatesUsingReferenceFrameToQueueUsingHandler;
}

@interface DeviceMotionInputSupervisor()
@property (strong, nonatomic) AccessedInput *dmInput;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation DeviceMotionInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.dmInput = [CommonUtils extractInputOfType:InputType.Motion from:model.scdDocument.accessedInputs];
    
    
    WEAKSELF
    [self.model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPMotionManagerEvent && isDeviceMotionEvent(event.eventIdentifier.eventSubtype)) {
            [weakSelf processDeviceMotionEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}



-(void)processDeviceMotionEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.dmInput.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.dmInput.inputType date:[NSDate date]]];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    SAFECALL(nextHandler)
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.dmInput) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:self.dmInput.inputType dateReported:[NSDate date]];
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerIsDeviceMotionActiveValue] = @(NO);
    event.eventData[kPPMotionManagerIsDeviceMotionAvailableValue] = @(NO);
    event.eventData[kPPMotionManagerGetCurrentDeviceMotionValue] = nil;
    
}

@end
