//
//  UIViolationReportsSection.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIViolationReportsSection.h"

@interface UIViolationReportsSection()
@property (readwrite, weak, nonatomic) UITableView *tableView;
@property (readwrite, assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) dispatch_once_t onceToken;
@end

@implementation UIViolationReportsSection

-(instancetype)initWithSectionIndex:(NSInteger)sectionIndex tableView:(UITableView *)tableView{
    if (self = [super init]) {
        self.sectionIndex = sectionIndex;
        self.tableView = tableView;
    }
    
    return self;
}

// - Intended to be overriden by subclasses
#pragma mark -
-(void)reloadTableViewIfNecessary{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.sectionIndex];
    
    if (self.reportsArray.count && self.amExpanded) {
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSInteger)numberOfRows {
    if (self.amExpanded) {
        return self.reportsArray.count;
    }
    
    return 0;
}

-(void)prepare {
    [self loadReportsWithCompletion:^{
        [self setupSectionHeader];
    }];
}

-(void)loadReportsWithCompletion:(void (^)())completion {
    //intended to be overriden by subclasses
    completion();
}

-(UITableViewCell *)cellForRowAtIndex:(NSInteger)index{
    return [[UITableViewCell alloc] init];
}

-(SCDSectionHeader *)scdSectionHeader {
    dispatch_once(&_onceToken, ^{
        self.scdSectionHeader = [[SCDSectionHeader alloc] init];
    });
    
    return _scdSectionHeader;
}

-(UIView *)sectionHeader {
    
    [self setupSectionHeader];
    return self.scdSectionHeader;
}

-(NSString *)sectionName{
    return @"Base section class!";
}

-(void)setupSectionHeader {
    
    NSString *name = [self sectionName];
    SCDSectionHeaderModel *model = [[SCDSectionHeaderModel alloc] initWithName:name expanded:self.amExpanded enabled:self.reportsArray.count > 0];
    
    SCDSectionHeaderCallbacks *callbacks = [self getCallbacksForSectionHeader];
    [self.scdSectionHeader setupWithModel:model callbacks:callbacks];
}


-(SCDSectionHeaderCallbacks*)getCallbacksForSectionHeader {
    
    __weak typeof(self) weakSelf = self;
    
    return [[SCDSectionHeaderCallbacks alloc] initWithCallToExpand:^(void (^callbackToConfirmExpand)(BOOL))
            {
                weakSelf.amExpanded = YES;
                [weakSelf.tableView insertRowsAtIndexPaths:[weakSelf indexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
                callbackToConfirmExpand(YES);
                
            } callToContract:^(void (^ callbackToConfirmContract)(BOOL))
            {
                weakSelf.amExpanded = NO;
                [weakSelf.tableView deleteRowsAtIndexPaths:[weakSelf indexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
                callbackToConfirmContract(YES);
            }];
    
}

-(NSArray<NSIndexPath*>*)indexPaths {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.reportsArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:self.sectionIndex];
        [result addObject:indexPath];
    }
    
    return result;
}


-(CGFloat)headerHeight{
    return 60;
}

@end
