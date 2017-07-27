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

NSArray<NSString*>* locationsArrayToStrings(NSArray<CLLocation*>* locations){
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    static NSNumberFormatter *nf = nil;
    if (!nf) {
        nf = [[NSNumberFormatter alloc] init];
        nf.minimumFractionDigits = 3;
        nf.maximumFractionDigits = 3;
        nf.roundingMode = NSNumberFormatterRoundDown;
    }
    
    for(CLLocation *location in locations) {
        NSString *latString = [nf stringFromNumber:[NSNumber numberWithDouble:location.coordinate.latitude]];
        NSString *lonString = [nf stringFromNumber:[NSNumber numberWithDouble:location.coordinate.longitude]];
        
        [strings addObject:latString];
        [strings addObject:lonString];
    }
    
    
    return strings;
}

@interface LocationHTTPAnalyzer()
@end

@implementation LocationHTTPAnalyzer



-(void)checkIfAnyLocationFrom:(NSArray<CLLocation *> *)locations isSentInRequest:(NSURLRequest *)request withCompletion:(void (^)(BOOL))completion {
    
    if (request.URL == nil) {
        SAFECALL(completion, NO)
        return;
    }
    
    NSArray *locationStrings = locationsArrayToStrings(locations);
    
    if ([self naiveSearchTextValues:locationStrings inRequestURL:request.URL]) {
        SAFECALL(completion, YES);
        return;
    }
    
    [self dictionaryFromRequestBody:request withCompletion:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        
        if (result) {
            
            BOOL foundInBody = [self searchRecursivelyInDictValues:result.allValues processingNumbersArray:^BOOL(NSArray<NSNumber *> *numbersArray) {
                return [self findLocations:locations inNumberValues:numbersArray];
            } processingStringsArray:^BOOL(NSArray<NSString *> *stringsArray) {
                return [self findLocations:locations inStringValues:stringsArray];
            }];
            
            SAFECALL(completion, foundInBody);
            
        } else {
            [self naiveSearchTextValues:locationStrings inRequestBody:request completion:^(NSArray<NSString *> * _Nullable foundValues) {
                SAFECALL(completion, foundValues.count > 0)
            }];
        }
    }];
    

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
