
//
//  SymbolInfo.c
//  iOSNM
//
//  Created by Costin Andronache on 6/15/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#include "SymbolInfo.h"
#include <stdlib.h>
#include <string.h>

const char* safeString = "SAFESTRING";

char* copyOfString(char *string){
    if (string == NULL) {
        return NULL;
    }
    
    size_t length = strlen(string) + 3;
    char *newString = malloc(length);
    strcpy(newString, string);
    return newString;
}

SymbolInfoArray* createEmptySymbolArray(){
    SymbolInfoArray *p = malloc(sizeof(SymbolInfoArray));
    
    p->bufferSize = 256;
    p->currentSymbols = malloc(p->bufferSize * sizeof(NMSymbolInfo*));
    p->numberOfSymbols = 0;
    return p;
}

NMSymbolInfo* createEmptySymbolInfo() {
    NMSymbolInfo *p = malloc(sizeof(NMSymbolInfo));
    p->libraryNameIfAny = NULL;
    p->sectionName = NULL;
    p->segmentName = NULL;
    p->symbolName = NULL;
    
    p->referenceType = RefType_Unknown;
    
    return p;
}

void addSymbolInfoPointer(NMSymbolInfo *info, SymbolInfoArray *array) {
    
    if (array->numberOfSymbols == array->bufferSize) {
        array->bufferSize *= 2;
        array->currentSymbols = realloc(array->currentSymbols, array->bufferSize * sizeof(NMSymbolInfo*));
    }
    
    array->currentSymbols[array->numberOfSymbols] = info;
    array->numberOfSymbols += 1;
}

void releaseSymbolInfo(NMSymbolInfo *info){
    
    if (!info) {
        return;
    }
    
    if (info->libraryNameIfAny) {
        free(info->libraryNameIfAny);
    }
    
    if (info->sectionName) {
        free(info->sectionName);
    }
    
    if (info->segmentName) {
        free(info->segmentName);
    }
    
    if (info->symbolName) {
        free(info->symbolName);
    }
    
    free(info);
}




void releaseSymbolInfoArray(SymbolInfoArray *context){
    if (!context) {
        return;
    }
    if (context->currentSymbols) {
        for (int i=0; i<context->numberOfSymbols; i++) {
            releaseSymbolInfo(context->currentSymbols[i]);
        }
        
        free(context->currentSymbols);
    }
    
    free(context);
}

NMSymbolInfo* deepCopySymbolInfo(NMSymbolInfo *unownedInfo){
    NMSymbolInfo *info = createEmptySymbolInfo();
    
    info->sectionName = copyOfString(unownedInfo->sectionName);
    info->segmentName = copyOfString(unownedInfo->segmentName);
    info->symbolName = copyOfString(unownedInfo->symbolName);
    info->libraryNameIfAny = copyOfString(info->libraryNameIfAny);
    
    info->referenceType = unownedInfo->referenceType;

    return info;
}

void printSymbolInfo(NMSymbolInfo *info) {
    printf("\n (%s, %s) %s", info->segmentName, info->sectionName, info->symbolName);
    if (info->libraryNameIfAny) {
        printf(" from %s", info->libraryNameIfAny);
    }
}
