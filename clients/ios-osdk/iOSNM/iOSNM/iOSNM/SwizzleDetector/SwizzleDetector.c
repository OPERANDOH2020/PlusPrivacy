//
//  SwizzleDetector.c
//  iOSNM
//
//  Created by Costin Andronache on 6/14/17.
//  Copyright © 2017 Personal. All rights reserved.
//  Note: The functions defined here do not check for errors (malloc and realloc). The number of embedded frameworks in an iOS app is usually quite small (< 10-20) and it is unlikely that the system will run out of memory to keep the symbol list for each of these.

// TO DO: The addXinYArray functions contain very similar validation and reallocation code. Maybe I can try a trick with void pointers later

#include "SwizzleDetector.h"
#import "nm.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <dlfcn.h>
#import <string.h>
#import <stdio.h>
#import <stdlib.h>



typedef struct {
    int bufferSize;
    int numOfArrays;
    SymbolInfoArray **arrayList;
}SymbolInfoMatrix;

typedef struct {
    int bufferSize;
    int numOfModels;
    ObjcSymbolsDetectModel **modelsList;
}DetectModelsArray;

typedef struct{
    int bufferSize;
    int numOfStrings;
    char **cStrings;
}CStringArray;

typedef struct {
    SymbolInfoMatrix *symbolInfoMatrix;
    DetectModelsArray *detectModelsArray;
    CStringArray *orderedFrameworkNamesArray;
}DetectContext;




MAKE_HIDDEN CStringArray* createEmptyCStringArray(){
    CStringArray *p = malloc(sizeof(CStringArray));
    p->bufferSize = 16;
    p->cStrings = malloc(p->bufferSize * sizeof(char*));
    p->numOfStrings = 0;
    return p;
}

MAKE_HIDDEN void addStringInCStringArray(char *string, CStringArray *array){
    if (array->bufferSize == array->numOfStrings) {
        array->bufferSize *= 2;
        array->cStrings = realloc(array->cStrings, array->bufferSize);
    }
    
    array->cStrings[array->numOfStrings] = string;
    array->numOfStrings += 1;
}


MAKE_HIDDEN int findIndexOfStringIfAny(char *string, CStringArray *array){
    
    for (int i=0; i<array->numOfStrings; i++) {
        if (strcmp(array->cStrings[i], string) == 0) {
            return i;
        }
    }
    
    return -1;
}





MAKE_HIDDEN SymbolInfoMatrix* createEmptyMatrix() {
    
    SymbolInfoMatrix *matrix = malloc(sizeof(SymbolInfoMatrix));
    matrix->bufferSize = 16;
    matrix->arrayList = malloc(matrix->bufferSize * sizeof(SymbolInfoArray*));
    matrix->numOfArrays = 0;
    
    return matrix;
}

MAKE_HIDDEN void addArrayInMatrix(SymbolInfoArray *array, SymbolInfoMatrix *matrix){
    if (matrix->numOfArrays == matrix->bufferSize) {
        matrix->bufferSize *= 2;
        matrix->arrayList = realloc(matrix->arrayList, matrix->bufferSize);
    }
    
    matrix->arrayList[matrix->numOfArrays] = array;
    matrix->numOfArrays += 1;
}




MAKE_HIDDEN DetectModelsArray *createEmptyDetectModelsArray(){
    DetectModelsArray *p = malloc(sizeof(DetectModelsArray));
    p->bufferSize = 16;
    p->modelsList = malloc(p->bufferSize * sizeof(ObjcSymbolsDetectModel*));
    p->numOfModels = 0;
    
    return p;
}

MAKE_HIDDEN void addDetectModelInArray(ObjcSymbolsDetectModel *context, DetectModelsArray *array){
    
    if (array->bufferSize == array->numOfModels) {
        array->bufferSize *= 2;
        array->modelsList = realloc(array->modelsList, array->bufferSize);
    }
    
    array->modelsList[array->numOfModels] = context;
    array->numOfModels += 1;
}

MAKE_HIDDEN DetectContext *getGlobalDetectContext() {
    static DetectContext *context = NULL;
    if (!context) {
        context = malloc(sizeof(DetectContext));
        context->detectModelsArray = createEmptyDetectModelsArray();
        context->orderedFrameworkNamesArray = createEmptyCStringArray();
        context->symbolInfoMatrix = createEmptyMatrix();
    }
    return context;
}


MAKE_HIDDEN char *extractLastPathItem(const char *path){
    if (!path) {
        return NULL;
    }
    
    char *p = (char *)(path + strlen(path));
    while (*(p-1) != '/' && p != path) {
        p -= 1;
    }
    
    size_t length = strlen(p) + 1;
    char *result = (char*)malloc(length * sizeof(char) + 1);
    strcpy(result, p);
    return result;
    
};

int loadIndexOfFrameworkNamed(const char *unownedFrameworkName){
    DetectContext *globalContext = getGlobalDetectContext();
    return findIndexOfStringIfAny(unownedFrameworkName, globalContext->orderedFrameworkNamesArray);
};

SymbolInfoArray* createFilteredVariantOfOnlyObjcSymbolsFrom(SymbolInfoArray *unownedSymbolsArray){
        
    // Any ObjC symbol has a '[' character in it
    const char *objcChar = "[";
    
    SymbolInfoArray *array = createEmptySymbolArray();
    for (int i=0; i<unownedSymbolsArray->numberOfSymbols; i++) {
        NMSymbolInfo *currentSymbol = unownedSymbolsArray->currentSymbols[i];
        if (strstr(currentSymbol->symbolName, objcChar)) {
            addSymbolInfoPointer(deepCopySymbolInfo(currentSymbol), array);
        }
    }
    
    return array;
}


MAKE_HIDDEN char* checkAnyObjcSymbolContainedInSymbol(ObjcSymbolsDetectModel *detectModel, NMSymbolInfo *info){
    
    for (int i=0; i<detectModel->numOfObjcSymbols; i++) {
        char *currentObjcSymbol = detectModel->objcSymbolsToCheck[i];
        if (strstr(info->symbolName, currentObjcSymbol)) {
            return currentObjcSymbol;
        }
    }
    
    return NULL;
}

MAKE_HIDDEN void checkAgainstFrameworkSymbols(ObjcSymbolsDetectModel *detectModel, SymbolInfoArray* symbolInfoArray, char *frameworkName){
    
    for (int i=0; i<symbolInfoArray->numberOfSymbols; i++) {
        NMSymbolInfo *currentSymbolInfo = symbolInfoArray->currentSymbols[i];
        char *possiblyDefinedSymbol = checkAnyObjcSymbolContainedInSymbol(detectModel, currentSymbolInfo);
        
        if (possiblyDefinedSymbol) {
            detectModel->callback(possiblyDefinedSymbol, frameworkName);
        }
    }
}



MAKE_HIDDEN void processNewlyLoadedSymbols(SymbolInfoArray *symbolsArray, char *frameworkName, DetectContext *detectContext){
    
    //Whenever a library has just been loaded, we need to loop through the existing models
    //and check if their libraries are already loaded. If not, then it's possible the current
    //library may define symbols listed in the models, in which case their respective callback
    //functions must be called.
    
    addArrayInMatrix(symbolsArray, detectContext->symbolInfoMatrix);
    addStringInCStringArray(frameworkName, detectContext->orderedFrameworkNamesArray);
    
    for (int i=0; i<detectContext->detectModelsArray->numOfModels; i++) {
        ObjcSymbolsDetectModel *currentModel = detectContext->detectModelsArray->modelsList[i];
        int orderInFrameworkList = findIndexOfStringIfAny(currentModel->frameworkName, detectContext->orderedFrameworkNamesArray);
        
        if (orderInFrameworkList >= 0) { // its library has been loaded. no need to worry about the next ones that follow
            return;
        }
        
        checkAgainstFrameworkSymbols(currentModel, symbolsArray, frameworkName);
    }
    
}



void checkObjcSymbolsDefinedBeforeFramework(ObjcSymbolsDetectModel *ownedModel) {
    DetectContext *context = getGlobalDetectContext();
    
    addDetectModelInArray(ownedModel, context->detectModelsArray);
    int loadIndexOfModelLibrary = findIndexOfStringIfAny(ownedModel->frameworkName, context->orderedFrameworkNamesArray);
    
    for (int i=0; i<context->orderedFrameworkNamesArray->numOfStrings; i++) {
        char *currentFrameworkName = context->orderedFrameworkNamesArray->cStrings[i];
        int loadIndexOfCurrentFramework = findIndexOfStringIfAny(currentFrameworkName, context->orderedFrameworkNamesArray);
        
        if (loadIndexOfCurrentFramework < loadIndexOfModelLibrary) {
            SymbolInfoArray *currentFrameworkSymbols = context->symbolInfoMatrix->arrayList[i];
            
            checkAgainstFrameworkSymbols(ownedModel, currentFrameworkSymbols, currentFrameworkName);
        }
    }
    
}

MAKE_HIDDEN void dylibListener(const struct mach_header* mh, intptr_t vmaddr_slide){
    
    const intptr_t spot = sizeof(struct mach_header_64) + mh->sizeofcmds;
    intptr_t address = spot + vmaddr_slide;
    Dl_info info;
    if(dladdr((const void*)address, &info)){
        if (strstr(info.dli_fname, "libswift")) {
            // ignore swift libraries
            return;
        }
        char *frameworkName = extractLastPathItem(info.dli_fname);
        SymbolInfoArray *symbolsArray = retrieveSymbolsFromFile(info.dli_fname);
        DetectContext *detectContext = getGlobalDetectContext();
        
        SymbolInfoArray *objcOnlySymbols = createFilteredVariantOfOnlyObjcSymbolsFrom(symbolsArray);
        
        releaseSymbolInfoArray(symbolsArray);
        processNewlyLoadedSymbols(objcOnlySymbols, frameworkName, detectContext);
    }

}

__attribute__((constructor))
MAKE_HIDDEN void registerListener() {
    _dyld_register_func_for_add_image(&dylibListener);
}
