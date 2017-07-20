//
//  LocationInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationInputSupervisor.h"
#import "CommonUtils.h"
#import <CoreLocation/CoreLocation.h>
#import <JRSwizzle.h>
#import "PPCircularArray.h"
#import "LocationHTTPAnalyzer.h"
#import <objc/runtime.h>

typedef void (^LocationCallbackWithInfo)(NSDictionary*);
LocationCallbackWithInfo _rsHookGlobalLocationCallback;


@interface LocationInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *locationSensor;
@property (strong, nonatomic) PPCircularArray *locationsArray;
@end


@implementation LocationInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.locationSensor = [CommonUtils extractInputOfType: InputType.Location from:model.scdDocument.accessedInputs];
    
    self.locationsArray = [[PPCircularArray alloc] initWithCapacity:100];
    
    WEAKSELF
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPLocationManagerEvent) {
            [weakSelf processLocationEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}

-(void)processLocationEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.locationSensor.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        [self.model.delegate newModuleDeniedAccessReport:[[PPModuleDeniedAccessReport alloc] initWithModuleName:aPossibleModule inputType:self.locationSensor.inputType date:[NSDate date]]];
        
        NSLog(@"would deny for: %@", aPossibleModule);
        return;
    }
    
    NSLog(@"No denying, the array is: %@", self.model.scdDocument.sdkChecks);
    
    PPUnlistedInputAccessViolation *violationReport = nil;
    if ((violationReport = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:violationReport];
        return;
    }
    
    SAFECALL(nextHandler)
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPLocationManagerGetCurrentLocationValue] = nil;
    event.eventData[kPPLocationManagerAuthorizationStatusValue] = @(kCLAuthorizationStatusDenied);
    event.eventData[kPPLocationManagerLocationServicesEnabledValue] = @(NO);
    event.eventData[kPPLocationManagerIsMonitoringAvailableForClassValue] = @(NO);
    event.eventData[kPPLocationManagerSignificantLocationChangeMonitoringAvailableValue] = @(NO);
    event.eventData[kPPLocationManagerHeadingAvailableValue] = @(NO);
    event.eventData[kPPLocationManagerIsRangingAvailableValue] = @(NO);
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.locationSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Location dateReported:[NSDate date]];
}

-(void)processNewlyRequestedLocations:(NSArray<CLLocation *> *)locations {
    [self.locationsArray addObjects:locations];
}


-(void)newURLRequestMade:(NSURLRequest *)request {
    
    [self.model.httpAnalyzers.locationHTTPAnalyzer checkIfAnyLocationFrom:[self.locationsArray allObjects] isSentInRequest:request withCompletion:^(BOOL yesTheyAreSent) {

        if (yesTheyAreSent) {
            
            
        }
    }];
    
}

@end
