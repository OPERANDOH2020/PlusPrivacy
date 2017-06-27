//
//  NSBundle+RSFrameworkHooks.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "NSBundle+RSFrameworkHooks.h"

@implementation NSBundle (RSFrameworkHooks)

+(NSBundle *)PPCloakBundle {
    static NSBundle *bundle = nil;
    if (!bundle) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PPCloakBundle" ofType:@"bundle"];
        
        bundle = [NSBundle bundleWithPath:path];
    }
    
    return bundle;
}

@end
