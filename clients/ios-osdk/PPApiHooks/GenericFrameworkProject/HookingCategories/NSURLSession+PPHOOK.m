//
//  NSURLSession+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "JRSwizzle.h"
#import "PPEvent.h"
#import "NSObject+AutoSwizzle.h"
#import "NSURLSession+PPHOOK.h"

PPEventDispatcher *_urlSessionDispatcher;

@interface NullUrlSessionDataTask : NSURLSessionDataTask
@property (weak, nonatomic) NSURLSession *weakSession;
@end

@implementation NullUrlSessionDataTask

-(instancetype)initWithSession:(NSURLSession*)session {
    if (self = [super init]) {
        self.weakSession = session;
    }
    return self;
}

-(void)resume {
}

-(void)cancel {
}

-(void)suspend {
}

-(NSURLSessionTaskState)state {
    
    return NSURLSessionTaskStateSuspended;
}

@end




@implementation NSURLSession(PPHOOK)

+(void)load {
    [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
}


/*
 Convention:
  - The parameters sent are:
    --1. The NSURLRequest
 
  - Upon returning, the code checks for the existence of a NSURLResponse or a NSError and optionally a NSData object. If these are present, then an empty dataTask is returned followed by calling the completion handler (in an async block) with the provided objects. Else, the default behaviour is invoked.
 */

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _urlSessionDispatcher = dispatcher;
}

HOOKPrefixInstance(NSURLSessionDataTask*, dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler) {
    
    NSMutableDictionary *eventData = [@{} mutableCopy];
    SAFEADD(eventData, kPPURLSessionDataTaskRequest, request)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPURLSessionEvent, EventURLSessionStartDataTaskForRequest) eventData:eventData whenNoHandlerAvailable:nil];
    
    [_urlSessionDispatcher fireEvent:event];
    
    NSURLResponse *response = eventData[kPPURLSessionDataTaskResponse];
    NSData *data = eventData[kPPURLSessionDatTaskResponseData];
    NSError *error = eventData[kPPURLSessionDataTaskError];
    
    if (response || error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SAFECALL(completionHandler, data, response, error)
        });
        return [[NullUrlSessionDataTask alloc] init];
    }
    
    return CALL_PREFIXED(self, dataTaskWithRequest:request completionHandler:completionHandler);
}

@end




