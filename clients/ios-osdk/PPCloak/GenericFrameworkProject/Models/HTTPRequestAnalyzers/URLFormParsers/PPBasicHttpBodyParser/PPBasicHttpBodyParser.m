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
#import "Common.h"

@interface NSError(HTTPParsing)
+(NSError*)errorDataArgumentNil;
@end

@implementation NSError(HTTPParsing)

+(NSError *)errorDataArgumentNil {
    return [NSError errorWithDomain:@"com.plusPrivacy.HTTPParsing" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Data body argument is nil"}];
}

@end

@implementation PPBasicHttpBodyParser

-(void)parseJSONFromBodyData:(NSData *)bodyData withCompletion:(DictionaryParsingCompletion _Nullable)completion {
    if (!bodyData) {
        SAFECALL(completion, nil, [NSError errorDataArgumentNil])
        return;
    }
    
    
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingAllowFragments error:&error];
    
    SAFECALL(completion, result, nil)
}

-(void)parseFormURLEncodedFromBodyData:(NSData *)bodyData withCompletion:(DictionaryParsingCompletion _Nullable)completion{
    if (!bodyData) {
        SAFECALL(completion, nil, [NSError errorDataArgumentNil])
        return;
    }
    
    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    NSDictionary *result =  GCDWebServerParseURLEncodedForm(bodyString);
    
    SAFECALL(completion, result, nil);
}

-(void)parseMultipartBodyData:(NSData *)data withCompletion:(DictionaryParsingCompletion)completion{
    if (!data) {
        SAFECALL(completion, nil, [NSError errorDataArgumentNil])
        return;
    }
    
    NSDictionary *result = [data multipartDictionary];
    SAFECALL(completion, result, nil);
}

@end
