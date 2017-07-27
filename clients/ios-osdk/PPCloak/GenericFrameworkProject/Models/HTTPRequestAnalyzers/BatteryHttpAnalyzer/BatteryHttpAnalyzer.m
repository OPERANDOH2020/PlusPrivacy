//
//  BatteryHttpAnalyzer.m
//  PPCloak
//
//  Created by Costin Andronache on 7/26/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BatteryHttpAnalyzer.h"
#import "Common.h"

@implementation BatteryHttpAnalyzer


-(void)findBatteryValues:(NSArray<NSNumber *> *)batteryValues sentInRequest:(NSURLRequest *)request completion:(void (^)(NSArray<NSNumber *> * _Nonnull))completion {
    
    NSArray *inURL = [self naiveSearchNumericValues:batteryValues compareUpToFractionDigit:2 inRequestURL:request.URL];
    
    if (inURL) {
        SAFECALL(completion, inURL);
        return;
    }
    
    [self naiveSearchNumericValues:batteryValues compareUpToFractionDigit:2 inRequestBody:request completin:^(NSArray<NSNumber *> * _Nullable foundValues) {
        
        if (foundValues) {
            SAFECALL(completion, foundValues);
            return;
        }
        
        SAFECALL(completion, @[]);
    }];
}

@end
