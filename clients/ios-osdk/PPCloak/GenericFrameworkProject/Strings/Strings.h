//
//  Strings.h
//  PPCloak
//
//  Created by Costin Andronache on 6/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef Strings_h
#define Strings_h

#include <stdio.h>
#include <CoreFoundation/CoreFoundation.h>

typedef CFStringRef (*StringGenerator)();


extern StringGenerator NSContactsUsageDescription;
extern StringGenerator PPContactsApiHook;
extern StringGenerator NSLocationAlwaysUsageDescription;
extern StringGenerator PPLocationApiHooks;
extern StringGenerator NSLocationWhenInUseUsageDescription;


#endif /* Strings_h */
