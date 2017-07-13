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
            PPUnlistedInputAccessViolation *violationReport = nil;
            if ((violationReport = [weakSelf detectUnregisteredAccess])) {
                [weakSelf.model.delegate newUnlistedInputAccessViolationReported:violationReport];
                return;
            }
        }
        
        SAFECALL(nextHandlerIfAny)
    }];
    
}



-(void)processPedometerAccessEvent:(PPEvent*)event {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.pedoSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
    
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.pedoSensor.inputType]];
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
