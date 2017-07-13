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
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *magnetoSensor;
@end

static bool isMagnetometerSubtype(int eventSubtype){
    
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

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.magnetoSensor = [CommonUtils extractInputOfType: InputType.Magnetometer from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
       
        if (event.eventIdentifier.eventType == PPMotionManagerEvent &&
            isMagnetometerSubtype(event.eventIdentifier.eventSubtype)) {
            [weakSelf processMagnetometerStatus];
        }
        SAFECALL(nextHandlerIfAny)
    }];
}

-(void)processMagnetometerStatusEvent:(PPEvent*)event {
    
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.magnetoSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
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
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.magnetoSensor.inputType]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.magnetoSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Magnetometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
