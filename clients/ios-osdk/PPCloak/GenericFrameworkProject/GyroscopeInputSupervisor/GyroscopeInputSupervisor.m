//
//  GyroscopeInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "GyroscopeInputSupervisor.h"
#import "CommonUtils.h"
#import <PPApiHooksCore/PPApiHooksCore.h>
#import "NSArray+ContainsAnyFromArray.h"
#import "Common.h"


BOOL isGyroEvent(int eventSubtype){
    return eventSubtype == EventMotionManagerIsGyroActive ||
           eventSubtype == EventMotionManagerIsGyroAvailable ||
           eventSubtype == EventMotionManagerStartGyroUpdates ||
           eventSubtype == EventMotionManagerSetGyroUpdateInterval ||
           eventSubtype == EventMotionManagerStartGyroUpdatesToQueueUsingHandler ||
    eventSubtype == EventMotionManagerGetCurrentGyroData;
}

@interface GyroscopeInputSupervisor()
@end

@implementation GyroscopeInputSupervisor



-(InputType *)monitoringInputType {
    return InputType.Gyroscope;
}

-(BOOL)isEventOfInterest:(PPEvent *)event{
    return (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isGyroEvent(event.eventIdentifier.eventSubtype));
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerGetCurrentGyroDataValue] = nil;
    event.eventData[kPPMotionManagerIsGyroActiveValue] = @(NO);
    event.eventData[kPPMotionManagerIsGyroAvailableValue] = @(NO);
    
}


@end
