//
//  ReportsStorageProtocol.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef ReportsStorageProtocol_h
#define ReportsStorageProtocol_h

#import "PPUnlistedInputAccessViolation.h"
#import "PPPrivacyLevelViolationReport.h"
#import "PPAccessFrequencyViolationReport.h"
#import "PPAccessUnlistedHostReport.h"

#pragma mark - Block typedefs
// -- Block typedefs ---

typedef void(^InputTypesCallback)(NSArray<InputType*>* __nullable, NSError * __nullable);
typedef void(^UnlistedInputReportsCallback)(NSArray<PPUnlistedInputAccessViolation*>* __nullable, NSError * __nullable);

typedef void(^PrivacyLevelReportsCallback)(NSArray<PPPrivacyLevelViolationReport*>* __nullable, NSError * __nullable);

typedef void(^UnlistedHostReportsCallback)(NSArray<PPAccessUnlistedHostReport*>* __nullable, NSError * __nullable);

typedef void(^AccessFrequencyReportsCallback)(NSArray<PPAccessFrequencyViolationReport*> * __nullable, NSError* __nullable);

typedef void(^PossibleErrorCallback)(NSError * __nullable error);

// -- End of block typedefs ---

#pragma mark - Source protocols
// -- Source protocols

@protocol PPUnlistedInputReportsSource <NSObject>
-(void)getUnlistedInputReportsIn:(UnlistedInputReportsCallback __nullable )callback;
-(void)getCurrentInputTypesInViolationReportsIn:(InputTypesCallback __nullable)callback;
-(void)getViolationReportsOfInputType:(InputType* _Nonnull)inputType in:(UnlistedInputReportsCallback __nullable)callback;
@end

@protocol PPPrivacyLevelReportsSource <NSObject>
-(void)getPrivacyLevelReportsIn:(PrivacyLevelReportsCallback __nullable )callback;
@end

@protocol PPUnlistedHostReportsSource <NSObject>
-(void)getUnlistedHostReportsIn:(UnlistedHostReportsCallback __nullable)callback;
@end

@protocol PPAccessFrequencyReportsSource <NSObject>
-(void)getFrequencyReportsIn:(AccessFrequencyReportsCallback __nullable)callback;
@end

#pragma mark - Repository protocols
// -- Repository protocols

@protocol PPUnlistedInputReportsRepository <PPUnlistedInputReportsSource>
-(void)addUnlistedInputReport:(PPUnlistedInputAccessViolation* _Nonnull)report withCompletion:(PossibleErrorCallback __nullable)completion;
@end

@protocol PPPrivacyLevelReportsRepository <PPPrivacyLevelReportsSource>
-(void)addPrivacyLevelReport:(PPPrivacyLevelViolationReport* _Nonnull)report withCompletion:(PossibleErrorCallback __nullable)completion;
@end

@protocol PPUnlistedHostReportsRepository <PPUnlistedHostReportsSource>
-(void)addUnlistedHostReport:(PPAccessUnlistedHostReport* _Nonnull)report withCompletion:(PossibleErrorCallback __nullable)completion;
@end

@protocol PPAccessFrequencyReportsRepository <PPAccessFrequencyReportsSource>
-(void)addAccessFrequencyReport:(PPAccessFrequencyViolationReport* _Nonnull)report withCompletion:(PossibleErrorCallback __nullable)completion;
@end

#endif /* ReportsStorageProtocol_h */
