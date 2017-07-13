//
//  NSArray+ContainsAnyFromArray.m
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "NSArray+ContainsAnyFromArray.h"

@implementation NSArray (ContainsAnyFromArray)


-(id)PPCloak_containsAnyFromArray:(NSArray*)other{
    
    for (id something in other) {
        if ([self containsObject:something]) {
            return something;
        }
    }
    
    return nil;
}

@end
