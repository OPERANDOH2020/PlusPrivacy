//
//  LocationHTTPAnalyzer.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "LocationHTTPAnalyzer.h"
#import "Common.h"

BOOL approximatelyEqual(double a, double b, double epsilon){
    return fabs(a - b) < epsilon;
}

BOOL isNumberALocationCoordinate(NSNumber *number, NSArray<CLLocation*>* locations){
    double epsilon = 1e-3;

    for (CLLocation *location in locations) {
        double latitude = location.coordinate.latitude;
        double longitude = location.coordinate.longitude;
        if (approximatelyEqual(latitude, number.doubleValue, epsilon) ||
            approximatelyEqual(longitude, number.doubleValue, epsilon)) {
            return YES;
        }
    }
    
    return NO;
}

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

@interface LocationHTTPAnalyzer()
@property (strong, nonatomic) id<HTTPBodyParser> httpBodyParser;
@end

@implementation LocationHTTPAnalyzer

-(instancetype)initWithHttpBodyParser:(id<HTTPBodyParser>)parser {
    if (self = [super init]) {
        self.httpBodyParser = parser;
    }
    return self;
}

-(void)checkIfAnyLocationFrom:(NSArray<CLLocation *> *)locations isSentInRequest:(NSURLRequest *)request withCompletion:(void (^)(BOOL))completion {
    
    [self dictionaryFromRequestBody:request withCompletion:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (result) {
            if ([self findValuesOfLocations:locations inArrayOfDictionaryValues:result.allValues]) {
                SAFECALL(completion, YES);
            } else {
                SAFECALL(completion, NO);
            }
        }
    }];
    
    SAFECALL(completion, NO);
}

-(void)dictionaryFromRequestBody:(NSURLRequest*)request withCompletion:(DictionaryParsingCompletion) completion {
    
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

-(BOOL)findValuesOfLocations:(NSArray<CLLocation*>*)locations inArrayOfDictionaryValues:(NSArray*)dictValues {
    
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
    
    if ([self findLocations:locations inNumberValues:numbersArray] || [self findLocations:locations inStringValues:stringsArray]) {
        return YES;
    }
    
    for (id collection in collectionsArray) {
        if ([collection isKindOfClass:[NSArray class]]) {
            return [self findValuesOfLocations:locations inArrayOfDictionaryValues:collection];
        } else if([collection isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = collection;
            return [self findValuesOfLocations:locations inArrayOfDictionaryValues:dict.allValues];
        }
    }
    
    return NO;
}

-(BOOL)findLocations:(NSArray<CLLocation*>*)locations inNumberValues:(NSArray<NSNumber*>*)numberValues {

    for (NSNumber* value in numberValues) {
        if (isNumberALocationCoordinate(value, locations)) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)findLocations:(NSArray<CLLocation*>*)locations inStringValues:(NSArray<NSString*>*)values {
    
    static NSNumberFormatter *nf = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nf = [[NSNumberFormatter alloc] init];
        nf.allowsFloats = YES;
        nf.numberStyle = NSNumberFormatterDecimalStyle;
        nf.maximumFractionDigits = 3;
    });
    
    for (NSString *value in values) {
        NSNumber *number = [nf numberFromString:value];
        if (number && isNumberALocationCoordinate(number, locations)) {
            return YES;
        }
    }
    
    for (CLLocation *loc in locations) {
        NSString *latitudeString = [nf stringFromNumber:@(loc.coordinate.latitude)];
        NSString *longitudeString = [nf stringFromNumber:@(loc.coordinate.longitude)];
        
        for (NSString *value in values) {
            if ([value containsString:latitudeString] || [value containsString:longitudeString]) {
                return YES;
            }
        }
    }
    
    return NO;
}




@end
