//
//  PPPrivacyLevelViolationReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>

@interface PPUsageLevelViolationReport : NSObject

@property (readonly, nonatomic) InputType *inputType;
@property (readonly, nonatomic) UsageLevelType violatedPrivacyLevel;
@property (readonly, nonatomic) NSString *destinationURLForData;

-(instancetype)initWithInputType:(InputType*)inputType violatedUsageLevel:(UsageLevelType)privacyLevel destinationURL:(NSString*)destinationURL;

@end
