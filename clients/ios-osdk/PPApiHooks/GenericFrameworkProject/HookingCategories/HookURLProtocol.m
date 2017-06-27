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


@implementation HookURLProtocol

+(void)load {
    if([NSURLProtocol registerClass:[HookURLProtocol class]]){
        NSLog(@"did register HookURLProtocol class");
    }
    
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
    PPApiHooks_registerHookedClass(self);
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher){
    _urlDispatcher = dispatcher;
}

+(BOOL)canInitWithTask:(NSURLSessionTask *)task {
    return NO;
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPWebViewRequest, request)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPWKWebViewEvent, EventAllowWebViewRequest) eventData:evData whenNoHandlerAvailable:nil];
    
    
      
        [_urlDispatcher fireEvent:event  ];
       
    
    // this method returning YES means that the request will be blocked
    // 
    return ![evData[kPPAllowWebViewRequestValue] boolValue];
}

-(void)startLoading {
    NSError *error = [[NSError alloc] initWithDomain:@"com.plusprivacy.ApiHooks "code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Request blocked"}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.client URLProtocol:self didFailWithError:error];
    });
}

-(void)stopLoading {
    
}

+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return  request;
}



@end
