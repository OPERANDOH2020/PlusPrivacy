//
//  PPPrivacyLevelViolationReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPUsageLevelViolationReport.h"

@interface PPUsageLevelViolationReport()
@property (readwrite, strong, nonatomic) InputType *inputType;
@property (readwrite, assign, nonatomic) UsageLevelType violatedPrivacyLevel;
@property (readwrite, strong, nonatomic) NSString *destinationURLForData;
@end

@implementation PPUsageLevelViolationReport

-(instancetype)initWithInputType:(InputType *)inputType violatedUsageLevel:(UsageLevelType)privacyLevel destinationURL:(NSString *)destinationURL {
    if (self = [super init]) {
        self.inputType = inputType;
        self.violatedPrivacyLevel = privacyLevel;
        self.destinationURLForData = destinationURL;
    }
    
    return self;
}

@end
