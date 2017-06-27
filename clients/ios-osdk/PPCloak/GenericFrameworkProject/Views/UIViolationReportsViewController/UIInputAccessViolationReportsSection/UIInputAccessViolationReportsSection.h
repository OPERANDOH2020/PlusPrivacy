//
//  UIInputAccessViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViolationReportsSection.h"
#import "ReportsStorageProtocol.h"

@interface UIInputAccessViolationReportsSection : UIViolationReportsSection

-(instancetype __nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView * _Nullable)tableView inputAccessReportsSource:(id<PPUnlistedInputReportsSource> _Nullable)source;

@end
