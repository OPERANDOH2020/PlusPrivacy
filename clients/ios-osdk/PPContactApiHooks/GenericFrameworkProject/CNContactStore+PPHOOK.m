//
//  CNContactStore+rsHook.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNContactStore+PPHOOK.h"
#import <PPApiHooksCore/PPApiHooksCore.h>


PPEventDispatcher *_cnDispatcher;

@implementation CNContactStore(PPHOOK)


+(void)load {
    if (NSClassFromString(@"CNContactStore")) {
        [self autoSwizzleMethodsWithThoseBeginningWith:PPHOOKPREFIX];
        PPApiHooks_registerHookedClass(self);
    }
}

HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher) {
    _cnDispatcher = dispatcher;
}


HOOKPrefixInstance(void, requestAccessForEntityType:(CNEntityType)entityType completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler) {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPContactStoreEntityTypeValue] = @(entityType);
    evData[kPPContactStoreBOOLErrorBlock] = completionHandler;
    PPVoidBlock confirmationOrDefault = ^{
        CALL_PREFIXED(weakSelf, requestAccessForEntityType: entityType completionHandler:completionHandler);
    };
    evData[kPPConfirmationCallbackBlock] = confirmationOrDefault;
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreRequestAccessForEntityType) eventData:evData whenNoHandlerAvailable:confirmationOrDefault];

    
    [_cnDispatcher fireEvent:event];
}

HOOKPrefixClass(CNAuthorizationStatus, authorizationStatusForEntityType:(CNEntityType)entityType){
    CNAuthorizationStatus actualStatus = CALL_PREFIXED(self, authorizationStatusForEntityType:entityType);
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    evData[kPPContactStoreEntityTypeValue] = @(entityType);
    evData[kPPContactStoreAuthorizationStatusValue] = @(actualStatus);
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreGetAuthorizationStatusForEntityType) eventData:evData whenNoHandlerAvailable:nil];
    

    
    
    [_cnDispatcher fireEvent:event];
    return [evData[kPPContactStoreAuthorizationStatusValue] integerValue];
}

HOOKPrefixInstance(NSArray<CNContact *> *,unifiedContactsMatchingPredicate:(NSPredicate *)predicate keysToFetch:(NSArray<id<CNKeyDescriptor>> *)keys error:(NSError *__autoreleasing  _Nullable *)error){
    
    NSError *localError = nil;
    NSArray<CNContact*> *contactsArray = CALL_PREFIXED(self, unifiedContactsMatchingPredicate:predicate keysToFetch: keys error: &localError);
    
    if (localError) {
        *error = localError;
        return nil;
    }
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStorePredicateValue, predicate)
    SAFEADD(evData, kPPContactStoreKeyDescriptorsArrayValue, keys)
    SAFEADD(evData, kPPContactStoreContactsArrayValue, contactsArray)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreGetUnifiedContactsMatchingPredicate) eventData:evData whenNoHandlerAvailable:nil];
    

    
    [_cnDispatcher fireEvent:event];
    
    *error = evData[kPPContactStoreErrorValue];
    return evData[kPPContactStoreContactsArrayValue];
}


HOOKPrefixInstance(CNContact*, unifiedContactWithIdentifier:(NSString *)identifier keysToFetch:(NSArray<id<CNKeyDescriptor>> *)keys error:(NSError *__nullable *__nullable)error) {
    
    NSError *localError = nil;
    CNContact *localContact = CALL_PREFIXED(self, unifiedContactWithIdentifier:identifier keysToFetch: keys error: &localError);
    
    if (localError) {
        *error = localError;
        return nil;
    }
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStoreContactValue, localContact)
    SAFEADD(evData, kPPContactStoreUnifiedContactIdentifierValue, identifier)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreGetUnifiedContactWithIdentifier) eventData:evData whenNoHandlerAvailable:nil];
    
    
    [_cnDispatcher fireEvent:event];
    *error = evData[kPPContactStoreErrorValue];
    return evData[kPPContactStoreContactValue];
    
}

HOOKPrefixInstance(BOOL, enumerateContactsWithFetchRequest:(CNContactFetchRequest *)fetchRequest error:(NSError *__autoreleasing  _Nullable *)error usingBlock:(void (^)(CNContact * _Nonnull, BOOL * _Nonnull))block){
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStoreFetchRequestValue, fetchRequest)
    SAFEADD(evData, kPPContactStoreContactEnumerationBlock, block)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreEnumerateContactsWithFetchRequest) eventData:evData whenNoHandlerAvailable:nil];
    
    
    [_cnDispatcher fireEvent:event];
    
    BOOL evReturnValue = [evData[kPPContactStoreBOOLReturnValue] boolValue];
    if (!evReturnValue) {
        *error = evData[kPPContactStoreErrorValue];
        return NO;
    }
    
    void(^possiblyOtherBlock)(CNContact*, BOOL*) = evData[kPPContactStoreContactEnumerationBlock];
    CNContactFetchRequest *possiblyModifiedFR = evData[kPPContactStoreFetchRequestValue];
    
    return CALL_PREFIXED(self, enumerateContactsWithFetchRequest:possiblyModifiedFR error: error usingBlock: possiblyOtherBlock);
}

HOOKPrefixInstance(NSArray<CNGroup*>*, groupsMatchingPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing  _Nullable *)error){
    
    NSError *localError = nil;
    NSArray<CNGroup*> *groups = CALL_PREFIXED(self, groupsMatchingPredicate:predicate error:&localError);
    if (localError) {
        *error = localError;
        return nil;
    }
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStorePredicateValue, predicate)
    SAFEADD(evData, kPPContactStoreGroupsArrayValue, groups)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreGetGroupsMatchingPredicate) eventData:evData whenNoHandlerAvailable:nil];
    

    [_cnDispatcher fireEvent:event];
    *error = evData[kPPContactStoreErrorValue];
    return evData[kPPContactStoreGroupsArrayValue];
}


HOOKPrefixInstance(NSArray<CNContainer*>*, containersMatchingPredicate:(NSPredicate *)predicate error:(NSError *__autoreleasing  _Nullable *)error){
    
    NSError *localError = nil;
    NSArray<CNContainer*> *containers = CALL_PREFIXED(self, containersMatchingPredicate:predicate error:&localError);
    
    if (localError) {
        *error = localError;
        return containers;
    }
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStorePredicateValue, predicate)
    SAFEADD(evData, kPPContactStoreContainersArrayValue, containers)
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactStoreGetContainersMatchingPredicate) eventData:evData whenNoHandlerAvailable:nil];
    
    [_cnDispatcher fireEvent:event];
    *error = evData[kPPContactStoreErrorValue];
    return evData[kPPContactStoreContainersArrayValue];
}


HOOKPrefixInstance(BOOL, executeSaveRequest:(CNSaveRequest *)saveRequest error:(NSError *__autoreleasing  _Nullable *)error){
    
    NSMutableDictionary *evData = [[NSMutableDictionary alloc] init];
    SAFEADD(evData, kPPContactStoreSaveRequestValue, saveRequest)
    
    PPEvent *event = [[PPEvent alloc] initWithEventIdentifier:PPEventIdentifierMake(PPCNContactStoreEvent, EventContactsStoreExecuteSaveRequest) eventData:evData whenNoHandlerAvailable:nil];
    
    [_cnDispatcher fireEvent:event];
    
    *error = evData[kPPContactStoreErrorValue];
    BOOL allow = [evData[kPPContactStoreAllowExecuteSaveRequest] boolValue];
    if (allow) {
        return CALL_PREFIXED(self, executeSaveRequest: saveRequest error: error);
    }
    
    return NO;
}

@end


