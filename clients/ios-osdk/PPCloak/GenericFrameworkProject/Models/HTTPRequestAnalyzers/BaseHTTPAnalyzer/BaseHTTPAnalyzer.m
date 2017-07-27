//
//  BaseHTTPAnalyzer.m
//  PPCloak
//
//  Created by Costin Andronache on 7/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BaseHTTPAnalyzer.h"
#import "Common.h"

@interface NSURLRequest(AnalyzingUtilities)
-(NSString*)contentType;
@end

@implementation NSURLRequest(AnalyzingUtilities)

-(NSString *)contentType {
    NSString *contentTypeHeader = @"Content-Type";
    NSString *value = [self valueForHTTPHeaderField:contentTypeHeader];
    if (!value) {
        value = [self valueForHTTPHeaderField:[contentTypeHeader lowercaseString]];
    }
    return value;
}

@end

NSString* numberToString(NSNumber *number, NSInteger fractionDigits){
    static NSNumberFormatter *nfm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nfm = [[NSNumberFormatter alloc] init];
        nfm.roundingMode = NSNumberFormatterRoundDown;
    });
    
    nfm.maximumFractionDigits = fractionDigits;
    
    return [nfm stringFromNumber:number];
}

@interface BaseHTTPAnalyzer()
@property (readwrite, strong, nonatomic) id<HTTPBodyParser> httpBodyParser;
@end


@implementation BaseHTTPAnalyzer

-(instancetype)initWithHttpBodyParser:(id<HTTPBodyParser>)parser {
    if (self = [super init]) {
        self.httpBodyParser = parser;
    }
    
    return self;
}

-(void)naiveSearchTextValues:(NSArray<NSString *> *)textValues inRequestBody:(NSURLRequest *)request completion:(void (^)(NSArray<NSString*> *foundValues))completion {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (request.HTTPBody) {
        NSString *textBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        for (NSString *aValue in textValues) {
            if ([textBody containsString:aValue]) {
                [result addObject:aValue];
            }
        }
    }
    
    if (result.count) {
        SAFECALL(completion, result);
        return;
    }
    SAFECALL(completion, nil);
}


-(NSArray<NSString*>* _Nullable)naiveSearchTextValues:(NSArray<NSString*> *)textValues inRequestURL:(NSURL*)url {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    NSString *absoluteURL = url.absoluteString;
    for (NSString *aValue in textValues) {
        if ([absoluteURL containsString:aValue]) {
            [results addObject:aValue];
        }
    }
    
    if (results.count) {
        return results;
    }
    
    return nil;
}

-(NSArray<NSNumber *> *)naiveSearchNumericValues:(NSArray<NSNumber *> *)numericValues compareUpToFractionDigit:(NSInteger)frDigit inRequestURL:(NSURL *)url {
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    NSString *absoluteURL = url.absoluteString;
    for (NSNumber *num in numericValues) {
        NSString *numStr = numberToString(num, frDigit);
        if ([absoluteURL containsString:numStr]) {
            [results addObject:num];
        }
    }
    
    
    if (results.count) {
        return results;
    }
    return nil;
}


-(void)naiveSearchNumericValues:(NSArray<NSNumber *> *)numericValues compareUpToFractionDigit:(NSInteger)frDigit inRequestBody:(NSURLRequest *)request completin:(void (^)(NSArray<NSNumber *> * _Nullable))completion {
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    if (request.HTTPBody) {
        NSString *textBody = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        for (NSNumber *num in numericValues) {
            NSString *numString = numberToString(num, frDigit);
            if ([textBody containsString:numString]) {
                [results addObject:num];
            }
        }
    }

    
    if (results.count) {
        SAFECALL(completion, results);
        return;
    }
    
    SAFECALL(completion, nil);
}

-(BOOL)searchRecursivelyInDictValues:(NSArray*)dictValues processingNumbersArray:(BOOL(^)(NSArray<NSNumber*>*))numbersArrayProcessor processingStringsArray:(BOOL(^)(NSArray<NSString*>*))stringsArrayProcessor {
    
    
    NSMutableArray *numbersArray = [[NSMutableArray alloc] init];
    NSMutableArray *stringsArray = [[NSMutableArray alloc] init];
    NSMutableArray *collectionsArray = [[NSMutableArray alloc] init];
    
    
    for (id val in dictValues) {
        if ([val isKindOfClass:[NSNumber class]]) {
            [numbersArray addObject:val];
        } else if ([val isKindOfClass:[NSString class]]) {
            [stringsArray addObject:val];
        } else {
            [collectionsArray addObject:val];
        }
    }
    
    
    if (numbersArrayProcessor(numbersArray) || stringsArrayProcessor(stringsArray)) {
        return YES;
    }
    
    for (id collection in collectionsArray) {
        if ([collection isKindOfClass:[NSArray class]]) {
            if([self searchRecursivelyInDictValues:collection processingNumbersArray:numbersArrayProcessor processingStringsArray:stringsArrayProcessor]) {
                return YES;
            }
        } else if([collection isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = collection;
            if([self searchRecursivelyInDictValues:dict.allValues processingNumbersArray:numbersArrayProcessor processingStringsArray:stringsArrayProcessor]) {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)dictionaryFromRequestBody:(NSURLRequest*)request withCompletion:(DictionaryParsingCompletion)completion {
    
    NSString *contentType = request.contentType.lowercaseString;
    if ([contentType containsString:@"json"]) {
        [self.httpBodyParser parseJSONFromBodyData:request.HTTPBody withCompletion:completion];
    }
    else if([contentType containsString:@"x-www"]){
        [self.httpBodyParser parseFormURLEncodedFromBodyData:request.HTTPBody withCompletion:completion];
    } else if([contentType containsString:@"multipart"]) {
        [self.httpBodyParser parseMultipartBodyData:request.HTTPBody withCompletion:completion];
    } else {
        SAFECALL(completion, nil, nil);
    }
}

@end
