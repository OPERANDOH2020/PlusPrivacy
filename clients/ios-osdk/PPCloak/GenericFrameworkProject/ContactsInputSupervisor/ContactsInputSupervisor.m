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

@interface ContactsInputSupervisor()
@property (strong, nonatomic) AccessedInput *contactsSource;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation ContactsInputSupervisor



-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.contactsSource = [CommonUtils extractInputOfType:InputType.Contacts from:model.scdDocument.accessedInputs];
}



-(void)processContactsAccess {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
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
