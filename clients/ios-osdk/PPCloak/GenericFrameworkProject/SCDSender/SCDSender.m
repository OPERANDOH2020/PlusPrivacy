//
//  SCDSender.m
//  PPCloak
//
//  Created by Costin Andronache on 7/21/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "SCDSender.h"

#define kBaseURL @"http://192.168.100.173:8080"

@interface SCDSendParamaters()
@property (readwrite, strong, nonatomic) NSString *scdJSONText;
@property (readwrite, strong, nonatomic) NSString *deviceId;
@property (readwrite, strong, nonatomic) NSString *appBundleIdentifier;
@end


@implementation SCDSendParamaters

-(instancetype)initWithJSON:(NSString *)JSON deviceId:(NSString *)deviceId bundleId:(NSString *)bundleId {
    if (self = [super init]) {
        self.appBundleIdentifier = bundleId;
        self.deviceId = deviceId;
        self.scdJSONText = JSON;
    }
    
    return self;
}

@end

@implementation SCDSender

-(void)sendSCDParameters:(SCDSendParamaters *)params withCompletion:(void (^)(NSError * _Nullable))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self buildSendSCDURL:params]]];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params.scdJSONText dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"URLResponse: %@", response);
        if (data) {
            NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response data: %@", message);
        }
        completion(error);
    }];
    
    [task resume];
}


-(NSString*)buildSendSCDURL:(SCDSendParamaters*)paramters {
    return [NSString stringWithFormat:@"%@/registerApplication/%@/%@", kBaseURL, paramters.deviceId, paramters.appBundleIdentifier];
}

@end
