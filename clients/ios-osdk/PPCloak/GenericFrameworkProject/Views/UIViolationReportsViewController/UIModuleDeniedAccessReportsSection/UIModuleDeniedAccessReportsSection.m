//
//  UIModuleDeniedAccessReportsSection.m
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIModuleDeniedAccessReportsSection.h"
#import "ViolationReportCell.h"
#import "Common.h"

@interface UIModuleDeniedAccessReportsSection()
@property (strong, nonatomic) id<PPModuleDeniedAccessReportsSource> reportsSource;
@end

@implementation UIModuleDeniedAccessReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPModuleDeniedAccessReportsSource>)reportsSource {
    if (self = [super initWithSectionIndex:sectionIndex tableView:tableView]) {
        self.reportsSource = reportsSource;
    }
    return self;
}



-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index {
    ViolationReportCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ViolationReportCell identifierNibName]];
    
    PPModuleDeniedAccessReport *report = self.reportsArray[index];
    NSString *message = [NSString stringWithFormat:@"For module [%@]", report.moduleName];
    NSString *subMessage = [NSString stringWithFormat:@"Access to %@ has been denied, at %@", InputType.namesPerInputType[report.inputType], report.reportDate];
    
    [cell setMessage:message subMessage:subMessage];
    return cell;
}


-(void)loadReportsWithCompletion:(void (^)())completion {
    [self.reportsSource getModuleDeniedAccessReportsIn:^(NSArray<PPModuleDeniedAccessReport *> * _Nullable reports, NSError * _Nullable error) {
        if (reports) {
            self.reportsArray = reports;
            SAFECALL(completion)
        }
        
    }];
}

-(NSString *)sectionName {
    return @"Module denied access reports";
}

@end
