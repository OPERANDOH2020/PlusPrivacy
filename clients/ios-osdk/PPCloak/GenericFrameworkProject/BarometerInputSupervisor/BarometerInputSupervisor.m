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

@property (strong, nonatomic) AccessedInput *sensor;
@property (strong, nonatomic) InputSupervisorModel *model;

@end

@implementation BarometerInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.sensor = [CommonUtils extractInputOfType:InputType.Barometer from:model.scdDocument.accessedInputs];
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPCMAltimeterEvent) {
            [self processAltimeterStatusEvent:event];
        }
        
        SAFECALL(nextHandlerIfAny)
    }];
}


-(void)processAltimeterStatusEvent:(PPEvent*)event {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.sensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
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
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.sensor.inputType]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.sensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Barometer dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
