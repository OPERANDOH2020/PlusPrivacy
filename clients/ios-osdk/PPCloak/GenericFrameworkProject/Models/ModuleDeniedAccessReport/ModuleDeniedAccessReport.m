//
//  ModuleDeniedAccessReport.m
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "ModuleDeniedAccessReport.h"

@interface ModuleDeniedAccessReport()
@property (readwrite, strong, nonatomic) NSString *moduleName;
@property (readwrite, strong, nonatomic) InputType *inputType;
@end

@implementation ModuleDeniedAccessReport
-(instancetype)initWithModuleName:(NSString *)moduleName inputType:(InputType *)inputType{
    if (self = [super init]) {
        self.moduleName = moduleName;
        self.inputType = inputType;
    }
    
    return self;
}
@end
