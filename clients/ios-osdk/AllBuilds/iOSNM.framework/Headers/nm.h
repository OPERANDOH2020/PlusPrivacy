//
//  nm.h
//  PPApiHooksCore
//
//  Created by Costin Andronache on 6/12/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef nm_h
#define nm_h

#include "SymbolInfo.h"


typedef SymbolInfoArray* (*SymbolsProviderFromFile)(const char* filePath);

extern SymbolsProviderFromFile retrieveSymbolsFromFile;
//SymbolInfoArray* retrieveSymbolsFromFile(const char* filePath);
#endif /* nm_h */
