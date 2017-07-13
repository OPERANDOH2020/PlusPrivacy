//
//  NSObject+SwizzleMethods.h
//  PPApiHooks
//
//  Created by Costin Andronache on 4/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(AutoSwizzle)
+(void)autoSwizzleMethodsWithThoseBeginningWith:(NSString*)prefix;
@end
