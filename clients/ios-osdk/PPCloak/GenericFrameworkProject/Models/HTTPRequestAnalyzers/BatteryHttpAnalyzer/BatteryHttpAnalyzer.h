//
//  BatteryHttpAnalyzer.h
//  PPCloak
//
//  Created by Costin Andronache on 7/26/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHTTPAnalyzer.h"

@interface BatteryHttpAnalyzer : BaseHTTPAnalyzer
-(void)findBatteryValuesSentInRequest:(NSURLRequest* _Nonnull)request completion:(void(^ _Nullable)(NSArray<NSNumber*>* _Nonnull batteryValues))completion;
@end

