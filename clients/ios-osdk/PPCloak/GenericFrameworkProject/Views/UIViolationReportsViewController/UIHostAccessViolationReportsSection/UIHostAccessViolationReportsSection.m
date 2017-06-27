//
//  UIHostAccessViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIHostAccessViolationReportsSection.h"
#import "Common.h"
#import "ViolationReportCell.h"

@interface UIHostAccessViolationReportsSection()
@property (strong, nonatomic) id<PPUnlistedHostReportsSource> reportsSource;
@end

@implementation UIHostAccessViolationReportsSection
-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPUnlistedHostReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    
    return self;
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getUnlistedHostReportsIn:^(NSArray<PPAccessUnlistedHostReport *> * _Nullable reports, NSError * _Nullable error) {
        self.reportsArray = reports;
        SAFECALL(completion)
    }];
}

-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index{
    ViolationReportCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    if (index >= self.reportsArray.count) {
        return cell;
    }
    
    
    PPAccessUnlistedHostReport *report = self.reportsArray[index];
    NSString *message = [NSString stringWithFormat:@"Request to unlisted host: %@", report.urlHost];
    NSString *subMessage = [NSString stringWithFormat:@"Date: %@", report.reportDate];
    [cell setMessage:message subMessage:subMessage];
    return cell;
}

-(NSString *)sectionName {
    return @"Network";
}

@end
