//
//  PPWebContentBlockerEngine.m
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//
/* This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#import "PPWebContentBlockerEngine.h"
#import "ABPFilterLibWrapper.h"

@interface NSError(PPWebContentBlockerEngine)
+(NSError*)resourceFilerForAdBlockerNotFound;

@end

@implementation NSError(PPWebContentBlockerEngine)
+(NSError *)resourceFilerForAdBlockerNotFound{
    return [[NSError alloc] initWithDomain:@"com.plusPrivacy" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Could not find resource file for adblocker."}];
}
@end

@interface PPWebContentBlockerEngine()
@property (strong, nonatomic) ABPFilterLibWrapper *abpWrapper;
@end

@implementation PPWebContentBlockerEngine


-(void)prepareWithCompletion:(void (^)(NSError * _Nullable))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:@"ABPFilterParserData" ofType:@"dat"];
        if (!path) {
            completion([NSError resourceFilerForAdBlockerNotFound]);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.abpWrapper = [[ABPFilterLibWrapper alloc] init];
        [self.abpWrapper setDataFile:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
        
    });
}

-(WebContentActionType)actionForRequest:(NSURLRequest *)request {
    
    if (!(request.URL && request.mainDocumentURL.host)) {
        return TypeAllowContent;
    }
    
    NSString *mainDocDomain = request.mainDocumentURL.host;
    NSURL *url = request.URL;
    
    
    if ([self.abpWrapper isBlockedConsideringType:url.absoluteString mainDocumentUrl:mainDocDomain acceptHTTPHeader:[request valueForHTTPHeaderField:@"Accept"]]) {
        return TypeBlockContent;
    }
    
    return TypeAllowContent;
}
@end
