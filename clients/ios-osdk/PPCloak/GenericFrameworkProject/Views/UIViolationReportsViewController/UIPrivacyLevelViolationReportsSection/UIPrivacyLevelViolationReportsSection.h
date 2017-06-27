//
//  UIPrivacyLevelViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportsStorageProtocol.h"
#import "UIViolationReportsSection.h"

@interface UIPrivacyLevelViolationReportsSection : UIViolationReportsSection
-(instancetype _Nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView reportsSource:(id<PPPrivacyLevelReportsSource>)reportsSource;
@end
