//
//  AccelerometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "AccelerometerInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"
#import "PPUnlistedInputAccessViolation.h"


@interface AccelerometerInputSupervisor()
@end

static bool isAccelerometerSubtype(NSInteger eventSubtype){
    
    static int accelerometerEvents[] = {EventMotionManagerIsAccelerometerActive,
        EventMotionManagerStartAccelerometerUpdates,
        EventMotionManagerSetAccelerometerUpdateInterval,
        EventMotionManagerIsAccelerometerAvailable,
        EventMotionManagerGetCurrentAccelerometerData,
        EventMotionManagerStartAccelerometerUpdatesToQueueUsingHandler
    };
    
    for (int i = 0; i< sizeof(accelerometerEvents) / sizeof(int); i++) {
        if (eventSubtype == accelerometerEvents[i]) {
            return true;
        }
    }
    
    return false;
}

@implementation AccelerometerInputSupervisor

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isAccelerometerSubtype(event.eventIdentifier.eventSubtype));
}

-(InputType *)monitoringInputType {
    return InputType.Accelerometer;
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerIsAccelerometerAvailableValue] = @(NO);
    event.eventData[kPPMotionManagerIsAccelerometerActiveValue] = @(NO);
    event.eventData[kPPMotionManagerGetCurrentAccelerometerDataValue] = nil;
}

@end
