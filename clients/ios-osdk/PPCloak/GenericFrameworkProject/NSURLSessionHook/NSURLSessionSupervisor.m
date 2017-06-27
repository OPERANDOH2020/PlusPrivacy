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
        SAFECALL(nextHandlerIfAny)
        return;
        
        if (event.eventIdentifier.eventSubtype == EventURLSessionStartDataTaskForRequest) {
            [weakSelf processRequestEvent:event];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}


-(void)processRequestEvent:(PPEvent*)requestEvent {
    NSURLRequest *request = requestEvent.eventData[kPPURLSessionDataTaskRequest];
    PPAccessUnlistedHostReport *report;
    if ((report = [self accessesUnspecifiedLink:request])) {
        [self.model.delegate newURLHostViolationReported:report];
        
        NSString *message = [NSString stringWithFormat:@"Accessed unspecified host. The developer must specifiy in the self compliance document the list of hosts that the app accesses. Host: %@", request.URL.host];
        NSError *error = [[NSError alloc] initWithDomain:@"com.plusPrivacy" code:-1 userInfo:@{NSLocalizedDescriptionKey: message}];
        
        requestEvent.eventData[kPPURLSessionDataTaskError] = error;
    }
}


-(PPAccessUnlistedHostReport*)accessesUnspecifiedLink:(NSURLRequest*)request {
    NSString *host = request.URL.host;
    
    for (NSString *listedHost in self.model.scdDocument.accessedHosts) {
        if ([listedHost isEqualToString:host]) {
            return nil;
        }
    }
    
    return [[PPAccessUnlistedHostReport alloc] initWithURLHost:host reportedDate:[NSDate date]];
}

@end
