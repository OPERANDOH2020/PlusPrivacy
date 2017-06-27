//
//  BaseReportWithDate.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "BaseReportWithDate.h"

@interface BaseReportWithDate()
@property (readwrite, strong, nonatomic) NSDate *reportDate;

@end

@implementation BaseReportWithDate

-(instancetype)initWithDate:(NSDate *)date{
    if (self = [super init]) {
        self.reportDate = date;
    }
    
    return self;
}

@end
