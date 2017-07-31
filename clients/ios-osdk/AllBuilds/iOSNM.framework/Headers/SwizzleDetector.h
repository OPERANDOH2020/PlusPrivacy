//
//  SwizzleDetector.h
//  iOSNM
//
//  Created by Costin Andronache on 6/14/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#ifndef SwizzleDetector_h
#define SwizzleDetector_h

#include "SymbolInfo.h"

typedef void(*FoundDefinedSymbolInFrameworkCallback)(char *unownedSymbol, char *unownedFrameworkName);

typedef struct {
    char **objcSymbolsToCheck;
    char *frameworkName;
    
    int numOfObjcSymbols;
    FoundDefinedSymbolInFrameworkCallback callback;
    
} ObjcSymbolsDetectModel;

void checkObjcSymbolsDefinedBeforeFramework(ObjcSymbolsDetectModel *ownedModel);
SymbolInfoArray* createFilteredVariantOfOnlyObjcSymbolsFrom(SymbolInfoArray *unownedSymbolsArray);

int loadIndexOfFrameworkNamed(const char *unownedFrameworkName);

#endif /* SwizzleDetector_h */
