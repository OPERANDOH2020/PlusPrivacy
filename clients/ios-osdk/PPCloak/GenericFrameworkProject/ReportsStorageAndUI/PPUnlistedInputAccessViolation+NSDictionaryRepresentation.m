//
//  PPUnlistedInputAccessViolation+NSDictionaryRepresentation.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPUnlistedInputAccessViolation+NSDictionaryRepresentation.h"
#import "CommonReportKeys.h"


@implementation PPUnlistedInputAccessViolation(NSDictionaryRepresentation)

-(NSDictionary *)dictionaryRepresentation {
    if (!(self.inputType && self.reportDate)) {
        return nil;
    }
    
    return @{
             kInputTypeRawValueKey: self.inputType.rawValue,
             kDateKey: self.reportDate
             };
}

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary{
    NSString *rawValueInputType = dictionary[kInputTypeRawValueKey];
    NSDate *date = dictionary[kDateKey];
    if (!(rawValueInputType && date)) {
        return nil;
    }
    
    if (!([rawValueInputType isKindOfClass:[NSString class]] &&
          [date isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    InputType *inputType = [InputType createFromRawValue:rawValueInputType];
    if (!inputType) {
        return nil;
    }
    
    return [self initWithInputType:inputType dateReported:date];
}

@end
