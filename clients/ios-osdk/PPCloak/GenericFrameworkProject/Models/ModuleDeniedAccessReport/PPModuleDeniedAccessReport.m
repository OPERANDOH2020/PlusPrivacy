//
//  PPModuleDeniedAccessReport.m
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPModuleDeniedAccessReport.h"

@interface PPModuleDeniedAccessReport()
@property (readwrite, strong, nonatomic) NSString *moduleName;
@property (readwrite, strong, nonatomic) InputType *inputType;
@end

@implementation PPModuleDeniedAccessReport
-(instancetype)initWithModuleName:(NSString *)moduleName inputType:(InputType *)inputType date:(NSDate *)date{
    if (self = [super initWithDate:date]) {
        self.moduleName = moduleName;
        self.inputType = inputType;
    }
    
    return self;
}
@end
