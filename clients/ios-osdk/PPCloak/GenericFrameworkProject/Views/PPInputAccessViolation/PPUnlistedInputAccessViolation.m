//
//  PPInputAccessViolation.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPUnlistedInputAccessViolation.h"

@interface PPUnlistedInputAccessViolation()
@property (readwrite, strong, nonatomic) InputType *inputType;
@end

@implementation PPUnlistedInputAccessViolation
-(instancetype)initWithInputType:(InputType *)inputType dateReported:(NSDate *)dateReported {
    if (self = [super initWithDate:dateReported]) {
        self.inputType = inputType;
    }
    
    return self;
}
@end
