//
//  HookURLProtocol.m
//  PPApiHooks
//
//  Created by Costin Andronache on 3/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "NSURLProtocol+WKWebViewSupport.h"
#import "HookURLProtocol.h"
#import "PPApiHooksStart.h"

PPEventDispatcher *_urlDispatcher;

static BOOL _webKitMonitoringOn = NO;

void PPApiHooks_disableWebKitURLMonitoring(){
    if (!_webKitMonitoringOn) {
        return;
    }
    
    _webKitMonitoringOn = NO;
    
    [NSURLProtocol wk_unregisterScheme:@"http"];
    [NSURLProtocol wk_unregisterScheme:@"https"];
}
void PPApiHooks_enableWebKitURLMonitoring(){
    if (_webKitMonitoringOn) {
        return;
    }
    
    _webKitMonitoringOn = YES;
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
}



@interface HookURLProtocol()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *currentTask;
@end


@implementation HookURLProtocol

+(void)load {
    [NSURLProtocol registerClass:[HookURLProtocol class]];
    PPApiHooks_enableWebKitURLMonitoring();
    PPApiHooks_registerHookedClass(self);
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher){
    _urlDispatcher = dispatcher;
}

+(NSOperationQueue*)sharedQueue {
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
    });
    
    return queue;
}


+(NSURLSession*)sharedSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    
    return session;
}

-(void)createAndAssignSession {
    self.session = [[self class] sharedSession];
}

-(instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithRequest:request cachedResponse:cachedResponse client:client]) {
        [self createAndAssignSession];
    }
    
    return self;
}

-(instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    if (self = [super initWithTask:task cachedResponse:cachedResponse client:client]) {
        [self createAndAssignSession];
    }
    
    return self;
}

+(BOOL)shouldInterceptRequest:(NSURLRequest*)request{
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPWebViewRequest, request)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPWKWebViewEvent, EventShouldInterceptWebViewRequest) eventData:evData whenNoHandlerAvailable:nil];
    
    [_urlDispatcher fireEvent:event  ];
    return [evData[kPPShouldInterceptWebViewRequestValue] boolValue];
}

+(NSError*)errorForRequest:(NSURLRequest*)request {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPWebViewRequest, request)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPWKWebViewEvent, EventGetErrorForRequestIfAny) eventData:evData whenNoHandlerAvailable:nil];
    
    [_urlDispatcher fireEvent: event];
    
    return evData[kPPErrorForWebViewRequest];
}

+(NSURLRequest*)alternateRequestForRequest:(NSURLRequest*)request {
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPWebViewRequest, request)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPWKWebViewEvent, EventGetAlternateRequestForWebViewRequest) eventData:evData whenNoHandlerAvailable:nil];
    
    [_urlDispatcher fireEvent: event];
    
    if (!evData[kPPAlternateRequestForWebViewRequest]) {
        return request;
    }
    return evData[kPPAlternateRequestForWebViewRequest];
}

+(BOOL)canInitWithTask:(NSURLSessionTask *)task {
    return [self shouldInterceptRequest:task.originalRequest];
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [self shouldInterceptRequest:request];
}

-(void)startLoading {
    
    NSError *errorIfAny = [[self class] errorForRequest:self.request];
    if (errorIfAny) {
        [self.client URLProtocol:self didFailWithError:errorIfAny];
        return;
    }
    
    NSURLRequest *alternateRequest = [[self class] alternateRequestForRequest:self.request];
    
    self.currentTask = [self.session dataTaskWithRequest:alternateRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [self.client URLProtocol:self didFailWithError:error];
        }
        
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        [self.client URLProtocol:self didLoadData:data];
        
        [self.client URLProtocolDidFinishLoading:self];
    }];
    
    [self.currentTask resume];
    
}

-(void)stopLoading {
    [self.currentTask cancel];
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return  request;
}


@end
