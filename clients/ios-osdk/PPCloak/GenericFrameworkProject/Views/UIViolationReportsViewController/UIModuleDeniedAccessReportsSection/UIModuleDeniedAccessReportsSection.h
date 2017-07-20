//
//  UIModuleDeniedAccessReportsSection.h
//  PPCloak
//
//  Created by Costin Andronache on 7/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViolationReportsSection.h"
#import "ReportsStorageProtocol.h"

@interface UIModuleDeniedAccessReportsSection : UIViolationReportsSection

-(instancetype _Nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView * _Nullable)tableView reportsSource:(id<PPModuleDeniedAccessReportsSource> _Nullable)reportsSource;

@end
