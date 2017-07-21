//
//  BarometerInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BarometerInputSupervisor.h"
#import "CommonUtils.h"
#import "Common.h"
#import <CoreMotion/CoreMotion.h>


@interface BarometerInputSupervisor()
@end

@implementation BarometerInputSupervisor


-(InputType *)monitoringInputType{
    return InputType.Barometer;
}


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPCMAltimeterEvent);
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPAltimeterIsRelativeAltitudeVailableValue] = @(NO);
}

@end
