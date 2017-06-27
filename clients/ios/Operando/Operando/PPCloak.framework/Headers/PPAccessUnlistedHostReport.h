//
//  PPAccessUnlistedURLReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseReportWithDate.h"

@interface PPAccessUnlistedHostReport : BaseReportWithDate

@property (readonly, nonatomic) NSString *urlHost;

-(instancetype)initWithURLHost:(NSString*)urlHost reportedDate:(NSDate*)date;

@end
