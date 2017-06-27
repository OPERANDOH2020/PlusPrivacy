//
//  UIViolationReportsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIViolationReportsViewController.h"
#import "ViolationReportCell.h"
#import "Common.h"
#import "NSBundle+RSFrameworkHooks.h"
#import <PPCommonUI/PPCommonUI.h>
#import "UIPrivacyLevelViolationReportsSection.h"
#import "UIInputAccessViolationReportsSection.h"
#import "UIHostAccessViolationReportsSection.h"
#import "UIAccessFrequencyViolationReportsSection.h"

@interface UIViolationReportsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) void (^exitCallback)();
@property (strong, nonatomic) NSArray<UIViolationReportsSection*> *reportSections;
@property (weak, nonatomic) IBOutlet UILabel *noReportsLabel;

@end

@implementation UIViolationReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noReportsLabel.hidden = YES;
    [self setupTableView:self.tableView];
}


-(void)setupWithReportSources:(PPReportsSourcesBundle*)reportSources
                       onExit:(void (^)())exitCallback {
    [self view];
    self.exitCallback = exitCallback;
    self.reportSections = [self createReportSectionsWith:reportSources];
    [self.tableView reloadData];
}


-(NSArray<UIViolationReportsSection*>*)createReportSectionsWith:(PPReportsSourcesBundle*)reportSourcesBundle {
    
    NSArray *sectionsArray =  @[
             [[UIInputAccessViolationReportsSection alloc] initWithSectionIndex:0 tableView:self.tableView inputAccessReportsSource:reportSourcesBundle.unlistedInputReportsSource],
             
             [[UIHostAccessViolationReportsSection alloc] initWithSectionIndex:1 tableView:self.tableView reportsSource:reportSourcesBundle.unlistedHostReportsSource],
             
             [[UIPrivacyLevelViolationReportsSection alloc] initWithSectionIndex:2 tableView:self.tableView reportsSource:reportSourcesBundle.privacyViolationReportsSource],
             
             [[UIAccessFrequencyViolationReportsSection alloc] initWithSectionIndex:3 tableView:self.tableView reportsSource:reportSourcesBundle.accessFrequencyReportsSource]
             
             ] ;
    
    for (UIViolationReportsSection *section in sectionsArray) {
        [section prepare];
    }
    
    return sectionsArray;
}

#pragma mark -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.reportSections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.reportSections.count) {
        return 0;
    }
    
    return self.reportSections[section].numberOfRows;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section >= self.reportSections.count) {
        return nil;
    }
    return self.reportSections[section].sectionHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section >= self.reportSections.count) {
        return 0;
    }
    
    return self.reportSections[section].headerHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= self.reportSections.count) {
        return [[UITableViewCell alloc] init];
    }
    
    return [self.reportSections[indexPath.section] cellForRowAtIndex:indexPath.row];
}

#pragma mark -


-(void)setupTableView:(UITableView*)tableView {
    
    NSBundle *bundle = [NSBundle PPCloakBundle];
    UINib *nib = [UINib nibWithNibName:[ViolationReportCell identifierNibName] bundle:
                  bundle];
    
    [tableView registerNib:nib forCellReuseIdentifier:[ViolationReportCell identifierNibName]];
    
    tableView.estimatedRowHeight = 80;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (IBAction)backButtonPressed:(id)sender {
    SAFECALL(self.exitCallback)
}

@end
