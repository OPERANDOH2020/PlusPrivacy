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
#import <unistd.h>
#import <execinfo.h>



//---- Utility functions -------


bool isEmbeddedFrameworkOrApp(char *binaryPath){
    char *progname = getprogname();
    if (strstr(binaryPath, progname)) {
        return true;
    }
    
    return false;
}

char* PPApiHooks_copyLastPathItemFrom(char* string) {
    
    char *p = string + strlen(string);
    while (*(p-1) != '/') {
        p--;
    }
    
    size_t lastPathLength = strlen(p);
    char *buffer = malloc(lastPathLength + 1);
    strcpy(buffer, p);
    
    return buffer;
}

extern NSArray *PPApiHooks_moduleNamesInCallStack(int skipLastN){
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if (skipLastN < 0) {
        return  result;
    }
    
    
    void *stackAdresses[32];
    int stackSize = backtrace(stackAdresses, 32);
    
    Dl_info info;
    for (int i=skipLastN; i<stackSize; i++) {
        if (dladdr(stackAdresses[i], &info) && isEmbeddedFrameworkOrApp(info.dli_fname)) {
            char *moduleName = PPApiHooks_copyLastPathItemFrom(info.dli_fname);
            NSString *string = [[NSString alloc] initWithCString:moduleName encoding:NSASCIIStringEncoding];
            
            [result addObject:string];
            free(moduleName);
        }
    }
    
    return result;
}


void PPApiHooks_printCallStack() {
    
    void *stackAdresses[32];
    int stackSize = backtrace(stackAdresses, 32);
    
    Dl_info info;
    for (int i=0; i<stackSize; i++) {
        if (dladdr(stackAdresses[i], &info)) {
            NSLog(@"%s embeddedFramework: %d", PPApiHooks_copyLastPathItemFrom(info.dli_fname), isEmbeddedFrameworkOrApp(info.dli_fname));
        }
    }
}

//---- End of utility functions -----




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



