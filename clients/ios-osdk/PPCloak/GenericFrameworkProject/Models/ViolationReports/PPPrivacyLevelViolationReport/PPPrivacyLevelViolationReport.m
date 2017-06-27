//
//  PPPrivacyLevelViolationReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPPrivacyLevelViolationReport.h"

@interface PPPrivacyLevelViolationReport()
@property (readwrite, strong, nonatomic) InputType *inputType;
@property (readwrite, assign, nonatomic) PrivacyLevelType violatedPrivacyLevel;
@property (readwrite, strong, nonatomic) NSString *destinationURLForData;
@end

@implementation PPPrivacyLevelViolationReport

-(instancetype)initWithInputType:(InputType *)inputType violatedPrivacyLevel:(PrivacyLevelType)privacyLevel destinationURL:(NSString *)destinationURL {
    if (self = [super init]) {
        
    }
    
    return self;
}

@end
