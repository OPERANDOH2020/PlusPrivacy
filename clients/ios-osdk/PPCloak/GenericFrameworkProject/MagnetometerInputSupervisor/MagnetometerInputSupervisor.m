//
//  MagnetometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MagnetometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import "JRSwizzle.h"

#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface MagnetometerInputSupervisor()
@end

static bool isMagnetometerSubtype(NSInteger eventSubtype){
    
    static int magnetometerEvents[] = {EventMotionManagerIsMagnetometerActive,
                                       EventMotionManagerStartMagnetometerUpdates,
                                       EventMotionManagerSetMagnetometerUpdateInterval,
                                       EventMotionManagerIsMagnetometerAvailable,
                                       EventMotionManagerGetCurrentMagnetometerData,
                                       EventMotionManagerStartMagnetometerUpdatesToQueueUsingHandler
    };
    
    for (int i = 0; i< sizeof(magnetometerEvents)/ sizeof(int); i++) {
        if (eventSubtype == magnetometerEvents[i]) {
            return true;
        }
    }
    
    return false;
}

@implementation MagnetometerInputSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isMagnetometerSubtype(event.eventIdentifier.eventSubtype));
}

-(InputType *)monitoringInputType {
    return InputType.Magnetometer;
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPMotionManagerIsMagnetometerAvailableValue] = @(NO);
    event.eventData[kPPMotionManagerIsMagnetometerActiveValue] = @(NO);
    event.eventData[kPPMotionManagerGetCurrentMagnetometerDataValue] = nil;
}

@end
