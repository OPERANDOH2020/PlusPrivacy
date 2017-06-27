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


-(instancetype __nullable)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView* __nullable)tableView;

-(void)prepare;

// - protected, to be overriden by subclasses
-(void)loadReportsWithCompletion:(void(^ _Nonnull)())completion;
-(NSString* _Nullable)sectionName;

// - public, to be overriden -

-(NSInteger)numberOfRows;
-(UITableViewCell* _Nonnull)cellForRowAtIndex:(NSInteger)index;
-(UIView* _Nullable)sectionHeader;
-(CGFloat)headerHeight;
@end
