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
@property (strong, nonatomic) PPCircularArray *locationsArray;
@end


@implementation LocationInputSupervisor

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return event.eventIdentifier.eventType == PPLocationManagerEvent;
}

-(InputType *)monitoringInputType{
    return InputType.Location;
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


-(void)specificProcessOfEvent:(PPEvent *)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
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
