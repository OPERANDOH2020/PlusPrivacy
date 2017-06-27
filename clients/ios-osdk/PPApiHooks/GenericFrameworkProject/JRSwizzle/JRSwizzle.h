// JRSwizzle.h semver:1.0
//   Copyright (c) 2007-2011 Jonathan 'Wolf' Rentzsch: http://rentzsch.com
//   Some rights reserved: http://opensource.org/licenses/MIT
//   https://github.com/rentzsch/jrswizzle

/* Due to the possibility JRSwizzle is a widely used for swizzling, its presence here could cause duplicate symbol errors for the developers embedding PPApiHooksCore. 
 */

#import <Foundation/Foundation.h>

@interface NSObject (JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end
