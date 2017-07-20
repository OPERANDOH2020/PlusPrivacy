//
//  PPModuleDeniedAccessReport+NSDictionaryRepresentation.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPModuleDeniedAccessReport+NSDictionaryRepresentation.h"
#import "Common.h"

@implementation PPModuleDeniedAccessReport (NSDictionaryRepresentation)

-(instancetype)initWithNSDictionary:(NSDictionary *)dictionary {
    NSDate *date = dictionary[@"date"];
    NSString *inputTypeRaw = dictionary[@"inputTypeRaw"];
    NSString *moduleName = dictionary[@"moduleName"];
    
    if (date && inputTypeRaw && moduleName) {
        InputType *inputType = [InputType createFromRawValue:inputTypeRaw];
        if (inputType) {
            return [self initWithModuleName:moduleName inputType:inputType date:date];
        }
    }
    
    return self;
}

-(NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    SAFEADD(dict, @"date", self.reportDate)
    SAFEADD(dict, @"inputTypeRaw", self.inputType.rawValue)
    SAFEADD(dict, @"moduleName", self.moduleName)
    
    return dict;
}

@end
