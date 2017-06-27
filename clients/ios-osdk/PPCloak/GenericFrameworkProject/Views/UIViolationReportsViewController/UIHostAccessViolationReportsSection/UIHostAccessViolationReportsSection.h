//
//  UIHostAccessViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViolationReportsSection.h"
#import "ReportsStorageProtocol.h"

@interface UIHostAccessViolationReportsSection: UIViolationReportsSection
-(instancetype _Nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPUnlistedHostReportsSource> _Nullable)reportsSource;
@end
