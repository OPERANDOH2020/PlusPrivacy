//
//  DefaultConfirmationSupervisor.m
//  PPCloak
//
//  Created by Costin Andronache on 7/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "DefaultConfirmationSupervisor.h"

@implementation DefaultConfirmationSupervisor


-(void)setupWithModel:(InputSupervisorModel *)model {
    
    [model.eventsDispatcher appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        PPVoidBlock eventConfirmationHandlerIfAny = event.eventData[kPPConfirmationCallbackBlock];
        
        SAFECALL(eventConfirmationHandlerIfAny)
    }];
    
}

@end
