//
//  PPAccessUnlistedURLReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPAccessUnlistedHostReport.h"


@interface PPAccessUnlistedHostReport()

@property (strong, readwrite, nonatomic) NSString *urlHost;

-(instancetype)initWithURLHost:(NSString*)urlHost reportedDate:(NSDate*)date;

@end

@implementation PPAccessUnlistedHostReport

-(instancetype)initWithURLHost:(NSString *)urlHost reportedDate:(NSDate *)date {
    if (self = [super initWithDate:date]) {
        self.urlHost = urlHost;
    }
    return self;
}

@end
