//
//  PPInputAccessViolation.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>
#import "BaseReportWithDate.h"


@interface PPUnlistedInputAccessViolation: BaseReportWithDate
@property (readonly, nonatomic) InputType *inputType;

-(instancetype)initWithInputType:(InputType*)inputType dateReported:(NSDate*)dateReported;
@end
