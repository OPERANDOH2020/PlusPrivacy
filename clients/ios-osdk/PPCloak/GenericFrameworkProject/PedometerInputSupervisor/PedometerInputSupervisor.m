//
//  PedometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PedometerInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"



@interface PedometerInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (weak, nonatomic) AccessedInput *pedoSensor;

@end

@implementation PedometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.pedoSensor = [CommonUtils extractInputOfType: InputType.Pedometer from:model.scdDocument.accessedInputs];
    
    __weak typeof(self) weakSelf = self;
    
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
                
        if (event.eventIdentifier.eventType == PPPedometerEvent) {
            [self processPedometerAccessEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
    
}



-(void)processPedometerAccessEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler{
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.pedoSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.pedoSensor.inputType]];

        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    
    SAFECALL(nextHandler)
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPPedometerIsStepCountingAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsPaceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsCadenceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsFloorCountingAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsDistanceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsEventTrackingAvailableValue] = @(NO);
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.pedoSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Pedometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
