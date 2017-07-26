//
//  BatteryInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/21/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BatteryInputSupervisor.h"
#import "PPCircularArray.h"

@interface BatteryInputSupervisor()
@property (strong, nonatomic) PPCircularArray *batteryValues;
@property (strong, nonatomic) NSMutableArray  *valuesSuspectedToBeSent;
@end

@implementation BatteryInputSupervisor


-(instancetype)init{
    if (self = [super init]) {
        self.batteryValues = [[PPCircularArray alloc] init];
        self.valuesSuspectedToBeSent = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(InputType *)monitoringInputType {
    return InputType.Battery;
}

-(void)specificProcessOfEvent:(PPEvent *)event nextHandler:(NextHandlerConfirmation)nextHandler {
    if (event.eventData[kPPDeviceBatteryLevelValue]) {
        
    }
}


-(void)analyzeNetworkRequestForPossibleLeakedData:(NSURLRequest *)request ifOkContinueToHandler:(NextHandlerConfirmation)nextHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(nextHandler)
    });
    
    if (self.batteryValues.allObjects.count == 0) {
        return;
    }
    
    self.model.httpAnalyzers

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
