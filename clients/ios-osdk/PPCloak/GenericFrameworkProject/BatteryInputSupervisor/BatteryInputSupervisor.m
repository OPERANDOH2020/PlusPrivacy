//
//  BatteryInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/21/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BatteryInputSupervisor.h"

@implementation BatteryInputSupervisor



-(InputType *)monitoringInputType {
    return InputType.Battery;
}

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return event.eventIdentifier.eventType == PPUIDeviceEvent && (
    event.eventIdentifier.eventSubtype == EventDeviceGetBatteryLevel ||
    event.eventIdentifier.eventType == EventDeviceSetBatteryMonitoringEnabled ||
    event.eventIdentifier.eventType == EventDeviceIsBatteryMonitoringEnabled ||
                                                                  event.eventIdentifier.eventType == EventDeviceGetBatteryState);
}

-(void)denyValuesOrActionsForModuleName:(NSString *)moduleName inEvent:(PPEvent *)event{
    event.eventData[kPPDeviceIsBatteryMonitoringEnabledValue] = @(NO);
    event.eventData[kPPDeviceBatteryLevelValue] = @(-1.0);
    event.eventData[kPPDeviceBatteryStateValue] = @(UIDeviceBatteryStateUnknown);
}

@end
