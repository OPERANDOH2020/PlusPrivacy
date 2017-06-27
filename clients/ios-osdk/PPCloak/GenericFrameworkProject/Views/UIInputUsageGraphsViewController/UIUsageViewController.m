//
//  UIInputUsageGraphsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIUsageViewController.h"
#import "Common.h"
#import "CommonReportKeys.h"

@implementation UIUsageViewControllerCallbacks
@end

@implementation UIUsageViewControllerModel
@end

@interface UIUsageViewController ()

@property (strong, nonatomic) UIUsageViewControllerModel *model;
@property (strong, nonatomic) UIUsageViewControllerCallbacks *callbacks;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UIUsageViewController

-(void)setupWithModel:(UIUsageViewControllerModel* __nullable)model andCallbacks:(UIUsageViewControllerCallbacks* __nullable)callbacks {
    
    self.model = model;
    self.callbacks = callbacks;
    [self view];
    [self.tableView reloadData];
    
}

    


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sections = 0;
    if (self.model.displayNetworkReportsOption) {
        sections++;
    }
    
    if (self.model.inputTypesOptions.count > 0) {
        sections++;
    }
    
    
    return sections;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.model.displayNetworkReportsOption) {
        return @"Network";
    }
    
    return @"Sensors & Other input";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.model.displayNetworkReportsOption) {
        return 1;
    }
    return self.model.inputTypesOptions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicTitleCell"];
    
    if (indexPath.section == 0 && self.model.displayNetworkReportsOption) {
        cell.textLabel.text = @"Unregistered URL Access";
        return cell;
    }
    
    InputType *inputType = self.model.inputTypesOptions[indexPath.row];
    NSString *inputName = InputType.namesPerInputType[inputType];
    cell.textLabel.text = inputName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && self.model.displayNetworkReportsOption) {
        SAFECALL(self.callbacks.networkReportsSelectedCallback)
        return;
    }
    
    InputType *inputType = self.model.inputTypesOptions[indexPath.row];
    SAFECALL(self.callbacks.inputTypeSelectedCallback, inputType);
}
- (IBAction)didPressBackButton:(id)sender {
    SAFECALL(self.callbacks.exitCallback)
}

@end
