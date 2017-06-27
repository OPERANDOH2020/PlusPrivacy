//
//  PPApiHooksStart.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPApiHooksStart.h"
#import "NSURLSession+PPHOOK.h"
#import "UIDevice+PPHOOK.h"
#import "HookURLProtocol.h"
#import "LAContext+PPHOOK.h"
#import "CMPedometer+PPHOOK.h"
#import "CMMotionManager+PPHOOK.h"
#import "CMAltimeter+PPHOOK.h"
#import "AVCaptureDevice+PPHOOK.h"
#import "UIDevice+PPHOOK.h"
#import <mach-o/dyld.h>
#import <libgen.h>
#import <dlfcn.h>
#import <mach-o/loader.h>




NSMutableArray* getGlobalClassListArray(){
    static NSMutableArray *array = nil;
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    
    return array;
}

void PPApiHooks_registerHookedClass(Class class){
    
    NSMutableArray *array = getGlobalClassListArray();
    [array addObject:class];
    PPEventDispatcher *sharedDispatcher = [PPEventDispatcher sharedInstance];
    CALL_PREFIXED(class, setEventsDispatcher: sharedDispatcher);
};

char** PPApiHooks_createListOfCurrentlyRegisteredClassNames(int *nCount){
    
    NSMutableArray *array = getGlobalClassListArray();
    
    char **cStringsArray = malloc(array.count * sizeof(char*));
    for (int i = 0; i<array.count; i++) {
        Class aClass = array[i];
        NSString *stringClass = NSStringFromClass(aClass);
        cStringsArray[i] = (char*)[stringClass UTF8String];
    }
    
    if (nCount) {
        *nCount = (int)array.count;
    }
    
    return cStringsArray;
}



