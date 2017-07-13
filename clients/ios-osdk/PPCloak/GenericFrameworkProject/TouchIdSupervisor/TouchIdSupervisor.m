//
//  TouchIdSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "TouchIdSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "JRSwizzle.h"



@interface TouchIdSupervisor()

@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accessedSensor;

@end

@implementation TouchIdSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    
    self.model = model;
    self.accessedSensor = [CommonUtils extractInputOfType: InputType.TouchID from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
       
        if (event.eventIdentifier.eventType == PPLAContextEvent) {
            NSNumber *policyValue = event.eventData[kPPContextPolicyValue];
            if (policyValue.integerValue == LAPolicyDeviceOwnerAuthenticationWithBiometrics) {
                [weakSelf processTouchIDUsage];
            }
        }
        SAFECALL(nextHandlerIfAny)
    }];
}



-(void)processTouchIDUsageEvent:(PPEvent*)event {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.accessedSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
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
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.accessedSensor.inputType]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.accessedSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.TouchID dateReported:[NSDate date]];
    
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
