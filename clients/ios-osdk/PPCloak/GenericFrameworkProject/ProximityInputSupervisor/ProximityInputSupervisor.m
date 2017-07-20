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
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *proximitySensor;

@end

@implementation ProximityInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.proximitySensor = [CommonUtils extractInputOfType: InputType.Proximity from:model.scdDocument.accessedInputs];
    
    __weak typeof(self) weakSelf = self;    
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPUIDeviceEvent) {
            [weakSelf processProximityEvent:event];
            return;
        }
        SAFECALL(nextHandlerIfAny)
    }];
}

-(void)processProximityEvent:(PPEvent*)event {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.proximitySensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *violationReport = nil;
    if ((violationReport = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:violationReport];
        return;
    }
    
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPDeviceProxmityStateValue] = @(NO);
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.proximitySensor.inputType date:[NSDate date]]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.proximitySensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Proximity dateReported:[NSDate date]];
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}

@end
