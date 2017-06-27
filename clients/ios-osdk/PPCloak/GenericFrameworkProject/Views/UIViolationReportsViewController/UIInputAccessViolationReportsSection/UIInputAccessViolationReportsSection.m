//
//  UIInputAccessViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIInputAccessViolationReportsSection.h"
#import "Common.h"
#import "ViolationReportCell.h"
#import "PPUnlistedInputAccessViolation.h"

@interface UIInputAccessViolationReportsSection()
@property (strong, nonatomic) id<PPUnlistedInputReportsSource> reportsSource;
@end

@implementation UIInputAccessViolationReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView inputAccessReportsSource:(id<PPUnlistedInputReportsSource>)source {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = source;
    }
    return self;
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getUnlistedInputReportsIn:^(NSArray<PPUnlistedInputAccessViolation *> * _Nullable reports, NSError * _Nullable error ) {
        self.reportsArray = reports;
        SAFECALL(completion)
    }];
}

-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index {
    ViolationReportCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    if (index >= self.reportsArray.count) {
        return cell;
    }
    
    PPUnlistedInputAccessViolation *report = self.reportsArray[index];
    NSString *message = [NSString stringWithFormat:@"Accessed unlisted input %@", InputType.namesPerInputType[report.inputType]];
    
    NSString *subMessage = [NSString stringWithFormat:@"Date: %@", report.reportDate];
    
    [cell setMessage:message subMessage:subMessage];
    
    return cell;
}

-(NSString *)sectionName {
    return  @"Sensors & other input";
}

@end
