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


@interface NSError(ContactsInputSupervisor)
+(NSError*)errorContactsAccessDenied;
@end

@implementation NSError(ContactsInputSupervisor)

+(NSError *)errorContactsAccessDenied{
    return [NSError errorWithDomain:@"com.plusPrivacy.ContactsInputSupervisor" code:0 userInfo:@{NSLocalizedDescriptionKey: @"The access attempt has been blocked by the OSDK"}];
}

@end

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
            [weakSelf processContactsAccessEvent:event nextHandler:nextHandlerIfAny];
        } else {
            SAFECALL(nextHandlerIfAny)
        }
        
    }];
}



-(void)processContactsAccessEvent:(PPEvent*)event nextHandler:(NextHandlerConfirmation)nextHandler {

    
    NSString *aPossibleModule = [[self.model.scdDocument modulesDeniedForInputType:self.contactsSource.inputType] PPCloak_containsAnyFromArray:event.moduleNamesInCallStack];
    
    if (aPossibleModule) {
        [self denyValuesOrActionsForModuleName:aPossibleModule inEvent:event];
        return;
    }
    
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
        return;
    }
    
    [self processEventNormally:event];
    SAFECALL(nextHandler)
}

-(void)processEventNormally:(PPEvent*)event {
    
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    event.eventData[kPPContactStoreAuthorizationStatusValue] = @(2); // 2 == CNAuthorizationStatusDenied
    
    
    event.eventData[kPPContactStoreErrorValue] = [NSError errorContactsAccessDenied];
    event.eventData[kPPContactStoreContactsArrayValue] = @[];
    event.eventData[kPPContactStoreContactValue] = nil;
    event.eventData[kPPContactStoreBOOLReturnValue] = @(NO);
    event.eventData[kPPContactStoreGroupsArrayValue] = @[];
    event.eventData[kPPContactStoreContainersArrayValue] = @[];
    event.eventData[kPPContactStoreAllowExecuteSaveRequest] = @(NO);
    
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
