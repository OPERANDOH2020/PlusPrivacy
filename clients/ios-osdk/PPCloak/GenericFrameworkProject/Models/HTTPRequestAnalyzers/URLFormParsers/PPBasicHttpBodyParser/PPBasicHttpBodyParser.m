//
//  PPBasicHttpBodyParser.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPBasicHttpBodyParser.h"
#import "GCDWebServerFunctions.h"
#import "NSData+MultipartParsing.h"

@implementation PPBasicHttpBodyParser

-(NSDictionary *)parseJSONFromBodyData:(NSData *)bodyData {
    if (!bodyData) {
        return nil;
    }
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingAllowFragments error:nil];
    
    return result;
}

-(NSDictionary *)parseFormURLEncodedFromBodyData:(NSData *)bodyData {
    if (!bodyData) {
        return nil;
    }
    
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    return GCDWebServerParseURLEncodedForm(bodyString);
}

-(NSDictionary *)parseMultipartBodyData:(NSData *)data withBoundary:(NSString *)boundary {
    if (!(data && boundary)) {
        return nil;
    }
    
    return [data multipartDictionary];
}

@end
