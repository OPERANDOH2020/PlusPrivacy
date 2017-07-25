//
//  UIPrivacyLevelViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIPrivacyLevelViolationReportsSection.h"
#import "Common.h"
#import "ViolationReportCell.h"

@interface UIPrivacyLevelViolationReportsSection()
@property (strong, nonatomic) id<PPPrivacyLevelReportsSource> reportsSource;
@end

@implementation UIPrivacyLevelViolationReportsSection
-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPPrivacyLevelReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    return self;
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getPrivacyLevelReportsIn:^(NSArray<PPUsageLevelViolationReport *> * _Nullable reports, NSError * _Nullable error) {
        self.reportsArray = reports;
        SAFECALL(completion)
    }];
}


-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index {
    ViolationReportCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    PPUsageLevelViolationReport *report = self.reportsArray[index];
    NSString *message = [NSString stringWithFormat:@"Usage level violation: %@", InputType.namesPerInputType[report.inputType]];
    
    NSString *subMessage = [NSString stringWithFormat:@"Data sent to: %@", report.destinationURLForData];
    
    [cell setMessage:message subMessage:subMessage];
    
    return cell;
}

-(NSString *)sectionName {
    return @"Usage level violations";
}

@end
