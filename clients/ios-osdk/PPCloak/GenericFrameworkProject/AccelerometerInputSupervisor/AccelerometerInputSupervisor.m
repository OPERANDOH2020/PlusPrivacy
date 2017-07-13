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

@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *accSensor;

@end

static bool isAccelerometerSubtype(int eventSubtype){
    
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

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.accSensor = [CommonUtils extractInputOfType: InputType.Accelerometer from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isAccelerometerSubtype(event.eventIdentifier.eventSubtype)) {
            [weakSelf processAccelerometerStatus];
        }
        
        SAFECALL(nextHandlerIfAny)
    }];
}


-(void)processAccelerometerStatusEvent:(PPEvent*)event {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.accSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.accSensor.inputType]];
}


-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess{
    if (self.accSensor) {
        return nil;
    }
    
    return  [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Accelerometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
