//
//  Security.h
//  PPCloak
//
//  Created by Costin Andronache on 6/15/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef Security_h
#define Security_h

#include <stdio.h>


extern inline void checkNoSwizzlingForApiHooks();
extern inline void checkNoSwizzlingForOPMonitor();
extern inline void checkForOtherFrameworks();
extern inline void printErrorForMissingFramework(char *missingFramework, char *key);
#endif /* Security_h */
