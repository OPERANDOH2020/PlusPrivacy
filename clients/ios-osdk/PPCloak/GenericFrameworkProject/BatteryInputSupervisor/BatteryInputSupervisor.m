//
//  BatteryInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/21/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BatteryInputSupervisor.h"
#import "PPCircularArray.h"

#define kThresholdNumberOfSuspectedValues 5

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
        [self.batteryValues addObject:event.eventData[kPPDeviceBatteryLevelValue]];
    }
    
    SAFECALL(nextHandler)
}


-(void)analyzeNetworkRequestForPossibleLeakedData:(NSURLRequest *)request ifOkContinueToHandler:(NextHandlerConfirmation)nextHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(nextHandler)
    });
    
    if (self.batteryValues.allObjects.count == 0) {
        return;
    }
    
    [self.model.httpAnalyzers.batteryHTTPAnalyzer findBatteryValues:self.batteryValues.allObjects sentInRequest:request completion:^(NSArray<NSNumber *> * _Nonnull batteryValues) {
        [self.valuesSuspectedToBeSent addObjectsFromArray:batteryValues];
        
        if (self.valuesSuspectedToBeSent.count >= kThresholdNumberOfSuspectedValues) {
            [self.valuesSuspectedToBeSent removeAllObjects];
            [self.model.delegate newPrivacyLevelViolationReported:[[PPUsageLevelViolationReport alloc] initWithInputType:InputType.Battery violatedUsageLevel:self.accessedInput.privacyDescription.usageLevel destinationURL:request.URL.absoluteString]];
        }
        
    }];

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
