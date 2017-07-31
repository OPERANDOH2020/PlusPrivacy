//
//  SymbolInfo.h
//  iOSNM
//
//  Created by Costin Andronache on 6/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#ifndef SymbolInfo_h
#define SymbolInfo_h

#include <stdio.h>
#define MAKE_HIDDEN __attribute__((visibility("hidden")))


typedef enum {
    RefType_Unknown,
    RefType_Dynamic,
    RefType_Weak_Private_External,
    RefType_Private_External,
    RefType_Weak_External_Auto_Hidden,
    RefType_Weak_External,
    RefType_External,
    RefType_Non_External
} NMSymbolReferenceType;

typedef struct  {
    char* segmentName;
    char* sectionName;
    char* libraryNameIfAny;
    char* symbolName;
    NMSymbolReferenceType referenceType;
} NMSymbolInfo;

typedef struct {
    NMSymbolInfo **currentSymbols;
    int numberOfSymbols;
    int bufferSize;
} SymbolInfoArray;


void printSymbolInfo(NMSymbolInfo *unownedInfo);
void releaseSymbolInfoArray(SymbolInfoArray *unownedArray);

MAKE_HIDDEN NMSymbolInfo* createEmptySymbolInfo();
MAKE_HIDDEN SymbolInfoArray* createEmptySymbolArray();
MAKE_HIDDEN NMSymbolInfo* deepCopySymbolInfo(NMSymbolInfo *unownedInfo);
MAKE_HIDDEN void addSymbolInfoPointer(NMSymbolInfo *unownedInfo, SymbolInfoArray *unownedArray);


MAKE_HIDDEN char* copyOfString(char *string);


#endif /* SymbolInfo_h */
