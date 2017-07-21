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
@end

@implementation TouchIdSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    if (event.eventIdentifier.eventType == PPLAContextEvent) {
        NSNumber *policyValue = event.eventData[kPPContextPolicyValue];
        if (policyValue.integerValue == LAPolicyDeviceOwnerAuthenticationWithBiometrics) {
            return YES;
        }
    }
    
    return NO;
}

-(InputType *)monitoringInputType {
    return InputType.TouchID;
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPContextErrorValue] = [NSError errorTouchIdAccessDenied];
    event.eventData[kPPContextCanEvaluateContextPolicyValue] = @(NO);
}


@end
