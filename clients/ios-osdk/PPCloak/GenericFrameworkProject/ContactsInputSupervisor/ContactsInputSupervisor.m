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
@end

@implementation ContactsInputSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return event.eventIdentifier.eventType == PPCNContactStoreEvent;
}

-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    event.eventData[kPPContactStoreAuthorizationStatusValue] = @(2); // 2 == CNAuthorizationStatusDenied
    event.eventData[kPPContactStoreErrorValue] = [NSError errorContactsAccessDenied];
    event.eventData[kPPContactStoreContactsArrayValue] = @[];
    event.eventData[kPPContactStoreContactValue] = nil;
    event.eventData[kPPContactStoreBOOLReturnValue] = @(NO);
    event.eventData[kPPContactStoreGroupsArrayValue] = @[];
    event.eventData[kPPContactStoreContainersArrayValue] = @[];
    event.eventData[kPPContactStoreAllowExecuteSaveRequest] = @(NO);
    
}

-(InputType *)monitoringInputType {
    return InputType.Contacts;
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
