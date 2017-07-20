//
//  InputSupervisorDelegate.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef InputSupervisorDelegate_h
#define InputSupervisorDelegate_h

#import <PPCommonTypes/PPCommonTypes.h>
#import "PPAccessFrequencyViolationReport.h"
#import "PPAccessUnlistedHostReport.h"
#import "PPUsageLevelViolationReport.h"
#import "PPUnlistedInputAccessViolation.h"
#import "InputSupervisorModel.h"
#import "PPModuleDeniedAccessReport.h"

@protocol InputSupervisorDelegate <NSObject>
-(void)newURLHostViolationReported:(PPAccessUnlistedHostReport* _Nonnull)report;
-(void)newPrivacyLevelViolationReported:(PPUsageLevelViolationReport* _Nonnull)report;
-(void)newUnlistedInputAccessViolationReported:(PPUnlistedInputAccessViolation* _Nonnull)report;
-(void)newAccessFrequencyViolationReported:(PPAccessFrequencyViolationReport* _Nonnull)report;

-(void)newModuleDeniedAccessReport:(PPModuleDeniedAccessReport* _Nonnull)report;

@end

@protocol InputSourceSupervisor <NSObject>
-(void)setupWithModel:(InputSupervisorModel* _Nonnull)model;
@end



#endif /* InputSupervisorDelegate_h */
