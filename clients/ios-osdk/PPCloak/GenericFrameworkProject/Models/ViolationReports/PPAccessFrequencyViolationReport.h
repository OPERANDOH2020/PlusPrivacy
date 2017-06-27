//
//  PPAccessFrequencyViolationReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>
#import "BaseReportWithDate.h"

@interface PPAccessFrequencyViolationReport : NSObject

@property (readonly, nonatomic) InputType *inputType;
@property (readonly, nonatomic) AccessFrequencyType *registeredFrequency;
@property (readonly, nonatomic) AccessFrequencyType *actualFrequency;



-(instancetype)initWithInput:(InputType*)inputType registeredFrequency:(AccessFrequencyType*)registeredFrequency actualFrequency:(AccessFrequencyType*)actualFrequency;


@end
