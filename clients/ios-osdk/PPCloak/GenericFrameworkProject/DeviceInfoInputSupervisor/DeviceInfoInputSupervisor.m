//
//  DeviceInfoInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "DeviceInfoInputSupervisor.h"

@interface DeviceInfoInputSupervisor()

@end

@implementation DeviceInfoInputSupervisor


-(InputType *)monitoringInputType {
    return InputType.Info;
}

-(BOOL)isEventOfInterest:(PPEvent *)event{
    if (!(event.eventIdentifier.eventType == PPUIDeviceEvent)) {
        return NO;
    }
    
    NSInteger subtype = event.eventIdentifier.eventSubtype;
    return subtype == EventDeviceGetName ||
           subtype == EventDeviceGetModel ||
           subtype == EventDeviceGetSystemName ||
           subtype == EventDeviceGetSystemVersion ||
    subtype == EventDeviceGetIdentifierForVendor;
    
}

-(void)denyValuesOrActionsForModuleName:(NSString *)moduleName inEvent:(PPEvent *)event {
    event.eventData[kPPDeviceNameValue] = @"";
    event.eventData[kPPDeviceUUIDValue] = [[NSUUID alloc] initWithUUIDString:@""];
    event.eventData[kPPDeviceSystemNameValue] = @"";
    event.eventData[kPPDeviceModelValue] = @"";
}



@end
