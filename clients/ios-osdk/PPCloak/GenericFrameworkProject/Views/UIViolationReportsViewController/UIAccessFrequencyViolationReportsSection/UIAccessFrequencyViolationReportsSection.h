//
//  UIAccessFrequencyViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportsStorageProtocol.h"
#import "UIViolationReportsSection.h"

@interface UIAccessFrequencyViolationReportsSection : UIViolationReportsSection
-(instancetype _Nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView * _Nullable)tableView reportsSource:(id<PPAccessFrequencyReportsSource> _Nullable)reportsSource;
@end
