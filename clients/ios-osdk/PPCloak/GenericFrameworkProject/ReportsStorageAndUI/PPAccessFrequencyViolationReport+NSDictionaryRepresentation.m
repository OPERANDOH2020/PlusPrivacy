//
//  PPAccessFrequencyViolationReport+NSDictionaryRepresentation.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPAccessFrequencyViolationReport+NSDictionaryRepresentation.h"
#import "CommonReportKeys.h"



@implementation PPAccessFrequencyViolationReport(NSDictionaryRepresentation)

-(NSDictionary *)dictionaryRepresentation {
    if (!(self.inputType && self.actualFrequency && self.registeredFrequency)) {
        return nil;
    }
    
    return @{
             kActualFrequencyRawValueKey: self.actualFrequency.rawValue,
             kRegisteredFrequencyRawValueKey: self.registeredFrequency.rawValue,
             kInputTypeRawValueKey: self.inputType.rawValue
             };
    
}

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary {
    AccessFrequencyType *actualFrequency, *registeredFrequency;
    InputType *inputType;
    
    NSString *actualFrRawValue = dictionary[kActualFrequencyRawValueKey];
    NSString *registerdFrRawValue = dictionary[kRegisteredFrequencyRawValueKey];
    NSString *inputTypeRawValue = dictionary[kInputTypeRawValueKey];
    
    if (!(actualFrRawValue && registerdFrRawValue && inputTypeRawValue)) {
        return nil;
    }
    
    Class stringClass = [NSString class];
    if (!([actualFrRawValue isKindOfClass:stringClass] &&
          [registerdFrRawValue isKindOfClass:stringClass] &&
          [inputTypeRawValue isKindOfClass:stringClass])) {
        return nil;
    }
    
    inputType = [InputType createFromRawValue:inputTypeRawValue];
    actualFrequency = [AccessFrequencyType createFromRawValue:actualFrRawValue];
    registeredFrequency = [AccessFrequencyType createFromRawValue:registerdFrRawValue];
    
    if (!(inputType && actualFrequency && registeredFrequency)) {
        return nil;
    }
    
    return [self initWithInput:inputType registeredFrequency:registeredFrequency actualFrequency:actualFrequency];
}

@end
