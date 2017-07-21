//
//  ProximityInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ProximityInputSupervisor.h"
#import "CommonUtils.h"

#import <UIKit/UIKit.h>
#import "JRSwizzle.h"
#import "Common.h"


@interface ProximityInputSupervisor()
@end

@implementation ProximityInputSupervisor

-(BOOL)isEventOfInterest:(PPEvent *)event {
    if (!(event.eventIdentifier.eventType == PPUIDeviceEvent)){
        return NO;
    }
    
    NSInteger subtype = event.eventIdentifier.eventSubtype;
    return subtype == EventDeviceGetProximityState ||
           subtype == EventDeviceSetProximitySensingEnabled ||
    subtype == EventDeviceSetProximityMonitoringEnabled;
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPDeviceProxmityStateValue] = @(NO);
}

-(InputType *)monitoringInputType {
    return InputType.Proximity;
}

@end
