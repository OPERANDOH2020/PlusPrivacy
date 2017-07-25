//
//  PPUsageLevelViolationReport+DictionaryRepresentation.m
//  PPCloak
//
//  Created by Costin Andronache on 7/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPUsageLevelViolationReport+DictionaryRepresentation.h"

@implementation PPUsageLevelViolationReport (DictionaryRepresentation)

-(instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
    NSNumber *rawUsageLevelType = dictionary[@"rawUsageLevelType"];
    NSString *rawInputType = dictionary[@"rawInputType"];
    NSString *destinationURL = dictionary[@"destinationURL"];
    
    if (!(rawInputType || rawUsageLevelType || destinationURL)) {
        return nil;
    }
    
    InputType *inputType = [InputType createFromRawValue:rawInputType];
    if (!rawInputType) {
        return nil;
    }
    
    return [self initWithInputType:inputType violatedUsageLevel:rawUsageLevelType.integerValue destinationURL:destinationURL];
    
}


-(NSDictionary *)dictionaryRepresentation {
    return @{
             @"rawUsageLevelType": @(self.violatedPrivacyLevel),
             @"rawInputType": self.inputType.rawValue,
             @"destinationURL": self.destinationURLForData
             };
}

@end
