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
            [weakSelf processAltimeterStatusEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processAltimeterStatusEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler{
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.sensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.sensor.inputType date:[NSDate date]] ];
        return;
    }
    
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    SAFECALL(nextHandler)
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPAltimeterIsRelativeAltitudeVailableValue] = @(NO);
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
