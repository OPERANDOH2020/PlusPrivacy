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
    
    __weak typeof(self) weakSelf = self;
    
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {

        PPEventType type = event.eventIdentifier.eventType;
        PPUnlistedInputAccessViolation *violationReport = nil;
        if ((type == PPLocationManagerEvent) &&
            (violationReport = [weakSelf detectUnregisteredAccess])) {
            
            [weakSelf.model.delegate newUnlistedInputAccessViolationReported:violationReport];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
    }];
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
