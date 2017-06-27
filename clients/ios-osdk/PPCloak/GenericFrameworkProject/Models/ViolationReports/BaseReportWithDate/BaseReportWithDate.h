//
//  BaseReportWithDate.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseReportWithDate : NSObject
@property (readonly, nonatomic) NSDate *reportDate;

-(instancetype)initWithDate:(NSDate*)date;
@end
