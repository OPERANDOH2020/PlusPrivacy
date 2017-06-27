//
//  UIAccessFrequencyViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIAccessFrequencyViolationReportsSection.h"
#import "ViolationReportCell.h"
#import <PPCommonTypes/PPCommonTypes.h>
#import "Common.h"

@interface UIAccessFrequencyViolationReportsSection()
@property (strong, nonatomic) id<PPAccessFrequencyReportsSource> reportsSource;
@end

@implementation UIAccessFrequencyViolationReportsSection



-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPAccessFrequencyReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
        self.amExpanded = NO;
    }
    
    return self;
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getFrequencyReportsIn:^(NSArray<PPAccessFrequencyViolationReport *> * _Nullable reportsArray, NSError * _Nullable error) {
        self.reportsArray = reportsArray;
        SAFECALL(completion);
    }];
}

-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index {
    ViolationReportCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    [cell setMessage:@"Access frequency error" subMessage:@""];
    
    return cell;
}

-(NSString *)sectionName {
    return @"Access frequency violation";
}

@end
