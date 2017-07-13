//
//  ContactsInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ContactsInputSupervisor.h"
#import <Contacts/Contacts.h>
#import "CommonUtils.h"
#import "Common.h"
#import <PPApiHooksCore/PPApiHooksCore.h>

@interface ContactsInputSupervisor()
@property (strong, nonatomic) AccessedInput *contactsSource;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation ContactsInputSupervisor



-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.contactsSource = [CommonUtils extractInputOfType:InputType.Contacts from:model.scdDocument.accessedInputs];
    
    
    WEAKSELF
    [PPEventDispatcher.sharedInstance appendNewEventHandler:^(PPEvent * _Nonnull event, NextHandlerConfirmation  _Nullable nextHandlerIfAny) {
        
        if (event.eventIdentifier.eventType == PPCNContactStoreEvent) {
            [weakSelf processContactsAccessEvent:event];
        }
        
        SAFECALL(nextHandlerIfAny)
    }];
}



-(void)processContactsAccessEvent:(PPEvent*)event {
    if (!self.contactsSource) {
        return;
    }
    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.contactsSource.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
    //generate a report
    [self.model.delegate newModuleDeniedAccessReport:[[ModuleDeniedAccessReport alloc] initWithModuleName:moduleName inputType:self.contactsSource.inputType]];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.contactsSource) {
        return  nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Contacts dateReported:[NSDate date]];
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
