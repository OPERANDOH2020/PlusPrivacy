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

#import "LocationManagerSubstituteDelegate.h"

typedef void (^LocationCallbackWithInfo)(NSDictionary*);
LocationCallbackWithInfo _rsHookGlobalLocationCallback;


@interface LocationInputSupervisor()
@property (strong, nonatomic) PPCircularArray *locationsArray;
@property (strong, nonatomic) LocationManagerSubstituteDelegate *substituteDelegate;
@end


@implementation LocationInputSupervisor


-(instancetype)init {
    if (self = [super init]) {
        self.locationsArray = [[PPCircularArray alloc] initWithCapacity:100];
        WEAKSELF
        self.substituteDelegate = [[LocationManagerSubstituteDelegate alloc] initWithLocationSubstituteCallback:^CLLocation * _Nullable(CLLocation * _Nonnull location) {
            [weakSelf.locationsArray addObject:location];
            return location;
        }];
    }
    
    return self;
}

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
    
    if (event.eventIdentifier.eventSubtype == EventLocationManagerSetDelegate) {
        CLLocationManager *instance = event.eventData[kPPLocationManagerInstance];
        id<CLLocationManagerDelegate> delegate = event.eventData[kPPLocationManagerDelegate];
        [self.substituteDelegate substituteDelegate:delegate forManager:instance];
        event.eventData[kPPLocationManagerDelegate] = self.substituteDelegate;
    }
    
    if (event.eventIdentifier.eventSubtype == EventLocationManagerGetCurrentLocation) {
        CLLocation *location = event.eventData[kPPLocationManagerGetCurrentLocationValue];
        [self processNewlyRequestedLocations:@[location]];
    }
    
    SAFECALL(nextHandler)
}

-(void)processNewlyRequestedLocations:(NSArray<CLLocation *> *)locations {
    [self.locationsArray addObjects:locations];
}



-(void)analyzeNetworkRequestForPossibleLeakedData:(NSURLRequest *)request ifOkContinueToHandler:(NextHandlerConfirmation)nextHandler {
    
    if (!request.URL) {
        SAFECALL(nextHandler)
        return;
    }
    
    WEAKSELF
    [self.model.httpAnalyzers.locationHTTPAnalyzer checkIfAnyLocationFrom:[self.locationsArray allObjects] isSentInRequest:request withCompletion:^(BOOL yesTheyAreSent) {
        if (yesTheyAreSent) {
            
            PPUsageLevelViolationReport *report = [[PPUsageLevelViolationReport alloc] initWithInputType:InputType.Location violatedUsageLevel:self.accessedInput.privacyDescription.usageLevel destinationURL:request.URL.absoluteString];
            
            [weakSelf.model.delegate newPrivacyLevelViolationReported:report];
        } else {
            SAFECALL(nextHandler)
        }
    }];
    
}


@end
