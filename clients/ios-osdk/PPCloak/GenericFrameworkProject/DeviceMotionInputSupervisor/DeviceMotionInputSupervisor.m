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
@end

@implementation DeviceMotionInputSupervisor


-(InputType *)monitoringInputType{
    return InputType.Motion;
}

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPMotionManagerEvent && isDeviceMotionEvent(event.eventIdentifier.eventSubtype));
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerIsDeviceMotionActiveValue] = @(NO);
    event.eventData[kPPMotionManagerIsDeviceMotionAvailableValue] = @(NO);
    event.eventData[kPPMotionManagerGetCurrentDeviceMotionValue] = nil;
    
}

@end
