//
//  UIViolationReportsSection.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PPCommonUI/PPCommonUI.h>

@interface UIViolationReportsSection : NSObject

// -protected properties.
@property (strong, nonatomic, nullable) NSArray *reportsArray;
@property (assign, nonatomic) BOOL amExpanded;
@property (strong, nonatomic, nullable) SCDSectionHeader *scdSectionHeader;

@property (readonly, nonatomic, weak, nullable) UITableView *tableView;
@property (readonly, nonatomic) NSInteger sectionIndex;
// -end of protected properties

// - public
-(instancetype __nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView* __nullable)tableView;

// - end of public

// - protected, must be overriden by subclasses
-(NSString* _Nullable)sectionName;
-(UITableViewCell* _Nonnull)cellForRowAtIndex:(NSInteger)index;
-(void)loadReportsWithCompletion:(void(^ _Nonnull)())completion;

// - public, with default implementation but can be overriden
-(void)prepare;
-(NSInteger)numberOfRows;
-(UIView* _Nullable)sectionHeader;
-(CGFloat)headerHeight;
@end
