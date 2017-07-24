//
//  BaseCaptureDeviceSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BaseCaptureDeviceSupervisor.h"


@implementation NSError(AVInputSupervisor)

+(NSError *)errorCaptureDeviceBlocked{
    return [NSError errorWithDomain:@"com.plusPrivacy.AVInputSupervisor" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"The capture device has been blocked by PlusPrivacy"}];
}

@end

@implementation BaseCaptureDeviceSupervisor



-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    event.eventData[kPPCaptureDeviceDefaultDeviceValue] = nil;
    event.eventData[kPPCaptureDeviceUniqueIdValue] = @"";
    event.eventData[kPPCaptureDeviceModelIdValue] = @"";
    event.eventData[kPPCaptureDeviceHasMediaTypeResult] = @(NO);
    event.eventData[kPPCaptureDeviceErrorValue] = [NSError errorCaptureDeviceBlocked];
    event.eventData[kPPCaptureDeviceConfirmationBool] = @(NO);
    event.eventData[kPPCaptureDeviceFormatsArrayValue] = @[];
    
}

@end
