//
//  PPEventIdentifier.c
//  PPApiHooks
//
//  Created by Costin Andronache on 4/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#include <stdio.h>
#import "PPEventIdentifier.h"

PPEventType PPEventIdentifierGetEventType(PPEventIdentifier eventIdentifier){
    return eventIdentifier.eventType;
};

NSInteger PPEventIdentifierGetSubType(PPEventIdentifier eventIdentifier){
    return eventIdentifier.eventSubtype;
};

PPEventIdentifier PPEventIdentifierMake(PPEventType eventType, NSInteger eventSubtype){
    PPEventIdentifier e;
    e.eventSubtype = eventSubtype;
    e.eventType = eventType;
    return e;
};
