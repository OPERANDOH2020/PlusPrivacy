//
//  PPAccessFrequencyViolationReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPAccessFrequencyViolationReport.h"

@interface PPAccessFrequencyViolationReport()

@property (readwrite, strong, nonatomic) InputType *inputType;
@property (readwrite, strong, nonatomic) AccessFrequencyType *registeredFrequency;
@property (readwrite, strong, nonatomic) AccessFrequencyType *actualFrequency;

@end

@implementation PPAccessFrequencyViolationReport

-(instancetype)initWithInput:(InputType*)inputType registeredFrequency:(AccessFrequencyType*)registeredFrequency actualFrequency:(AccessFrequencyType*)actualFrequency {
    if (self = [super init]) {
        self.inputType = inputType;
        self.registeredFrequency = registeredFrequency;
        self.actualFrequency = actualFrequency;
    }
    
    return self;
}
@end
