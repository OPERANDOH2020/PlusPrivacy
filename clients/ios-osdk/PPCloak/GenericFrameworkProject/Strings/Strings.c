//
//  Strings.c
//  PPCloak
//
//  Created by Costin Andronache on 6/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//  Note: Must create the actual char* arrays via obfuscation,
//  not by plainly exposing them in the cStrings section in the binary.
//  Also, this file should not be made public
#include "Strings.h"

#define MAKE_HIDDEN __attribute__((visibility("hidden")))



MAKE_HIDDEN static CFStringRef generateNSLocationAlwaysUsageDescription(){
    return CFSTR("NSLocationAlwaysUsageDescription");
}

MAKE_HIDDEN static CFStringRef generatePPContactsApiHook(){
    return CFSTR("PPContactsApiHook");
}

MAKE_HIDDEN static CFStringRef generateNSLocationWhenInUseUsageDescription(){
    return CFSTR("NSLocationWhenInUseUsageDescription");
}

MAKE_HIDDEN static CFStringRef generateNSContactsUsageDescription() {
    return CFSTR("NSContactsUsageDescription");
}

MAKE_HIDDEN static CFStringRef generatePPLocationApiHooks(){
    return CFSTR("PPLocationApiHooks");
}

StringGenerator NSContactsUsageDescription = &generateNSContactsUsageDescription;
StringGenerator NSLocationAlwaysUsageDescription = &generateNSLocationAlwaysUsageDescription;
StringGenerator PPContactsApiHook = &generatePPContactsApiHook;
StringGenerator PPLocationApiHooks = &generatePPLocationApiHooks;
StringGenerator NSLocationWhenInUseUsageDescription = &generateNSLocationWhenInUseUsageDescription;
