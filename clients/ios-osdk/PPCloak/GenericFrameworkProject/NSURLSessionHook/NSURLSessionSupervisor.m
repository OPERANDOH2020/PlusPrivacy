//
//  NSURLSessionHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 11/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

#import "NSURLSessionSupervisor.h"
#import "JRSwizzle.h"
#import "PPAccessUnlistedHostReport.h"
#import <PPApiHooksCore/PPApiHooksCore.h>

@interface NSError(NSURLSessionSupervisor)
+(NSError*)errorRequestBlocked:(NSURLRequest*)request;
@end


@implementation NSError(NSURLSessionSupervisor)

+(NSError *)errorRequestBlocked:(NSURLRequest*)request {
    NSString *message = [NSString stringWithFormat:@"Accessed unspecified host. The developer must specifiy in the self compliance document the list of hosts that the app accesses. Host: %@", request.URL.host];
    NSError *error = [[NSError alloc] initWithDomain:@"com.plusPrivacy" code:-1 userInfo:@{NSLocalizedDescriptionKey: message}];
    
    return error;
}

@end

@interface NSURLSessionSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) NSString *myHandlerIdentifier;
@end

@implementation NSURLSessionSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    PPEventDispatcher *dispatcher = [PPEventDispatcher sharedInstance];
    if (self.myHandlerIdentifier) {
        [dispatcher removeHandlerWithIdentifier:self.myHandlerIdentifier];
    }
    
    __weak typeof(self) weakSelf = self;
    [dispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {

        if (event.eventIdentifier.eventSubtype == EventURLSessionStartDataTaskForRequest) {
            [weakSelf processRequestEvent:event];
        }
        SAFECALL(nextHandlerIfAny)
    }];
}


-(void)processRequestEvent:(PPEvent*)requestEvent {
    NSURLRequest *request = requestEvent.eventData[kPPURLSessionDataTaskRequest];
    PPAccessUnlistedHostReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [self.model.delegate newURLHostViolationReported:report];
        NSError *error = [NSError errorRequestBlocked:request];
        requestEvent.eventData[kPPURLSessionDataTaskError] = error;
    }
}


-(PPAccessUnlistedHostReport*)accessesUnspecifiedLink:(NSURLRequest*)request {
    if (self.model.scdDocument.accessedHosts.reasonNonDisclosure) {
        return nil;
    }
    
    NSString *host = request.URL.host;
    
    for (NSString *listedHost in self.model.scdDocument.accessedHosts.hostList) {
        if ([listedHost isEqualToString:host]) {
            return nil;
        }
    }
    
    return [[PPAccessUnlistedHostReport alloc] initWithURLHost:host reportedDate:[NSDate date]];
}

@end
