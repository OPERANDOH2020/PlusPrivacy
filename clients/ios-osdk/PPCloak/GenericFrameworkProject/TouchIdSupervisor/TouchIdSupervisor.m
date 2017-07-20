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

@interface NSError(TouchIdSupervisor)
+(NSError*)errorTouchIdAccessDenied;
@end

@implementation NSError(TouchIdSupervisor)

+(NSError *)errorTouchIdAccessDenied{
    return [NSError errorWithDomain:@"com.plusPrivacy.TouchIdSupervisor" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Access to touch ID has been blocked by the OSDK"}];
}

@end

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
                [weakSelf processTouchIDUsageEvent:event nextHandler:nextHandlerIfAny];
            }
        }
    }];
}



-(void)processTouchIDUsageEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler{
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.accessedSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
            [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.accessedSensor.inputType date:[NSDate date]]];
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
    // apply SDKC code here
    event.eventData[kPPContextErrorValue] = [NSError errorTouchIdAccessDenied];
    event.eventData[kPPContextCanEvaluateContextPolicyValue] = @(NO);
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
