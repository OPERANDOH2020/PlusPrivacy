//
//  BaseHTTPAnalyzer.h
//  PPCloak
//
//  Created by Costin Andronache on 7/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseHTTPAnalyzer : NSObject

-(void)naiveSearchTextValue:(NSString*)textValue inRequest:(NSURLRequest*)request;

@end
