//
//  PPEventIdentifier.h
//  PPApiHooks
//
//  Created by Costin Andronache on 4/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef PPEventIdentifier_h
#define PPEventIdentifier_h
#import "Common.h"

/*
  Do not rely on the current definition, for it may change.
  Instead use the helper functions to access the members.
 */
struct _PPEventIdentifier{
    PPEventType eventType;
    NSInteger eventSubtype;
};
typedef struct _PPEventIdentifier PPEventIdentifier;

PPEventType PPEventIdentifierGetEventType(PPEventIdentifier eventIdentifier);
NSInteger PPEventIdentifierGetSubType(PPEventIdentifier eventIdentifier);
PPEventIdentifier PPEventIdentifierMake(PPEventType eventType, NSInteger eventSubtype);

#endif /* PPEventIdentifier_h */
