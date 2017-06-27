//
//  PPAccessUnlistedHostReport+NSDictionaryRepresentation.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPAccessUnlistedHostReport+NSDictionaryRepresentation.h"
#import "CommonReportKeys.h"

@implementation PPAccessUnlistedHostReport(NSDictionaryRepresentation)
-(NSDictionary *)dictionaryRepresentation {
    if (!(self.reportDate && self.urlHost)) {
        return nil;
    }
    
    return @{
             kDateKey: self.reportDate,
             kURLReportKey: self.urlHost
             };
}

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary{
    NSString *urlHost = dictionary[kURLReportKey];
    NSDate *date = dictionary[kDateKey];
    
    if (!([urlHost isKindOfClass:[NSString class]] &&
          [date isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    return [self initWithURLHost:urlHost reportedDate:date];
}

@end
