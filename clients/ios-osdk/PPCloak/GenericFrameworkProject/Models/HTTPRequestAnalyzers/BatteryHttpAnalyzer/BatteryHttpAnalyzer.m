//
//  BatteryHttpAnalyzer.m
//  PPCloak
//
//  Created by Costin Andronache on 7/26/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BatteryHttpAnalyzer.h"

@implementation BatteryHttpAnalyzer


-(void)findBatteryValuesSentInRequest:(NSURLRequest *)request completion:(void (^)(NSArray<NSNumber *> * _Nonnull))completion {
    
    [self naiveSearchTextValues:<#(NSArray<NSString *> *)#> inRequestURL:<#(NSURL *)#>]
    
}

@end
