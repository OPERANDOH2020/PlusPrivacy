//
//  PedometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PedometerInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreMotion/CoreMotion.h>
#import "JRSwizzle.h"



@interface PedometerInputSupervisor()
@end

@implementation PedometerInputSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return event.eventIdentifier.eventType == PPPedometerEvent;
}

-(InputType *)monitoringInputType {
    
    CMPedometerData
    
    return InputType.Pedometer;
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPPedometerIsStepCountingAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsPaceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsCadenceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsFloorCountingAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsDistanceAvailableValue] = @(NO);
    event.eventData[kPPPedometerIsEventTrackingAvailableValue] = @(NO);
}


@end
