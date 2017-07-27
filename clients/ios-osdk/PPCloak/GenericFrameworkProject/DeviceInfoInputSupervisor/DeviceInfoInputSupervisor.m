//
//  DeviceInfoInputSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "DeviceInfoInputSupervisor.h"
#import "PPCircularArray.h"

@interface DeviceInfoInputSupervisor()
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *deviceUUID;
@property (strong, nonatomic) NSString *deviceSystemName;
@property (strong, nonatomic) NSString *deviceModel;

@end

@implementation DeviceInfoInputSupervisor



-(InputType *)monitoringInputType {
    return InputType.Info;
}

-(BOOL)isEventOfInterest:(PPEvent *)event{
    if (!(event.eventIdentifier.eventType == PPUIDeviceEvent)) {
        return NO;
    }
    
    NSInteger subtype = event.eventIdentifier.eventSubtype;
    return subtype == EventDeviceGetName ||
           subtype == EventDeviceGetModel ||
           subtype == EventDeviceGetSystemName ||
           subtype == EventDeviceGetSystemVersion ||
    subtype == EventDeviceGetIdentifierForVendor;
    
}

-(void)specificProcessOfEvent:(PPEvent *)event nextHandler:(NextHandlerConfirmation)nextHandler {
    
    if (event.eventData[kPPDeviceNameValue]) {
        self.deviceName = event.eventData[kPPDeviceNameValue];
    }
    
    if (event.eventData[kPPDeviceUUIDValue]) {
        self.deviceUUID = event.eventData[kPPDeviceUUIDValue];
    }
    
    if (event.eventData[kPPDeviceSystemNameValue]) {
        self.deviceSystemName = event.eventData[kPPDeviceSystemNameValue];
    }
    
    if (event.eventData[kPPDeviceModelValue]) {
        self.deviceModel = event.eventData[kPPDeviceModelValue];
    }
    
    SAFECALL(nextHandler)
}

-(void)analyzeNetworkRequestForPossibleLeakedData:(NSURLRequest *)request ifOkContinueToHandler:(NextHandlerConfirmation)nextHandler {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SAFECALL(nextHandler);
    });
    
    NSArray *strings = [self buildStringsArray];
    if (strings.count == 0) {
        return;
    }
    
    NSArray *foundInURL = [self.model.httpAnalyzers.basicAnalyzer naiveSearchTextValues:strings inRequestURL:request.URL];
    if (foundInURL.count) {
        [self.model.delegate newPrivacyLevelViolationReported:[[PPUsageLevelViolationReport alloc] initWithInputType:InputType.Info violatedUsageLevel:self.accessedInput.privacyDescription.usageLevel destinationURL:request.URL.absoluteString]];
        
        return;
    }
    
    [self.model.httpAnalyzers.basicAnalyzer naiveSearchTextValues:strings inRequestBody:request completion:^(NSArray<NSString *> * _Nullable foundValues) {
        if (foundValues.count) {
            [self.model.delegate newPrivacyLevelViolationReported:[[PPUsageLevelViolationReport alloc] initWithInputType:InputType.Info violatedUsageLevel:self.accessedInput.privacyDescription.usageLevel destinationURL:request.URL.absoluteString]];
            
        }
    }];
}


-(NSArray<NSString *> *)buildStringsArray {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    if (self.deviceModel) {
        [strings addObject:self.deviceModel];
    }
    
    if (self.deviceSystemName) {
        [strings addObject:self.deviceSystemName];
    }
    
    if (self.deviceUUID) {
        [strings addObject:self.deviceUUID];
    }
    
    if (self.deviceName) {
        [strings addObject:self.deviceName];
    }
    
    return strings;
}

-(void)denyValuesOrActionsForModuleName:(NSString *)moduleName inEvent:(PPEvent *)event {
    event.eventData[kPPDeviceNameValue] = @"";
    event.eventData[kPPDeviceUUIDValue] = [[NSUUID alloc] initWithUUIDString:@""];
    event.eventData[kPPDeviceSystemNameValue] = @"";
    event.eventData[kPPDeviceModelValue] = @"";
}



@end
