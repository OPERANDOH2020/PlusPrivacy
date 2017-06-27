//
//  NSObject+SwizzleMethods.m
//  PPApiHooks
//
//  Created by Costin Andronache on 4/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "NSObject+AutoSwizzle.h"
#import <objc/runtime.h>
#import "JRSwizzle.h"


Method findMethodInList(const char *methodName, Method *methodListHead){
    Method *methodIterator = methodListHead;
    
    while (*methodIterator) {
        const char *name = sel_getName(method_getName(*methodIterator));
        if (strcmp(methodName, name) == 0) {
            return *methodIterator;
        }
        
        methodIterator += 1;
    }
    
    return NULL;
}

typedef void(^BlockApplySelectors)(SEL originalSelector, SEL selectorWithPrefix);



@implementation NSObject(AutoSwizzle)

+(void)autoSwizzleMethodsWithThoseBeginningWith:(NSString*)prefix {
    
    Method *instanceMethodsListHead = class_copyMethodList(self, NULL);
    [self findPairsOfMethodsFromList:instanceMethodsListHead withOneHavingPrefix:prefix andApply:^(SEL originalSelector, SEL selectorWithPrefix) {
        [self jr_swizzleMethod:originalSelector withMethod:selectorWithPrefix error:nil];
    }];
    
    free(instanceMethodsListHead);
    
    Method *classMethodsListHead = class_copyMethodList(object_getClass(self), NULL);
    [self findPairsOfMethodsFromList:classMethodsListHead withOneHavingPrefix:prefix andApply:^(SEL originalSelector, SEL selectorWithPrefix) {
        [self jr_swizzleClassMethod:originalSelector withClassMethod:selectorWithPrefix error:nil];
    }];
    
    free(classMethodsListHead);
}

+(void)findPairsOfMethodsFromList:(Method*)methodListHead withOneHavingPrefix:(NSString*)prefix andApply:(void(^)(SEL originalSelector, SEL selectorWithPrefix))applyBlock {
    
    Method *methodIterator = methodListHead;
    
    const char *cPrefix = [prefix cStringUsingEncoding:NSASCIIStringEncoding];
    size_t cPrefixLength = strlen(cPrefix);
        
    while (*methodIterator != NULL) {
        const char *name = sel_getName(method_getName(*methodIterator));
        
        if (strstr(name, cPrefix)) {
            
            char methodNameWithoutPrefix[512];
            strcpy(methodNameWithoutPrefix, name + cPrefixLength);
            
            Method originalMethod = findMethodInList(methodNameWithoutPrefix, methodListHead);
            if (originalMethod) {
                SEL originalSelector = method_getName(originalMethod);
                SEL selectorWithPrefix = method_getName(*methodIterator);
                applyBlock(originalSelector, selectorWithPrefix);
            }
            
        }
        
        methodIterator += 1;
    }
}

@end
