//
//  UILocationListView.m
//  PPCloak
//
//  Created by Costin Andronache on 3/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationListView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "NSBundle+RSFrameworkHooks.h"
#import "UILocationListViewCell.h"
#import "Common.h"
#import "CommonViewUtils.h"




@interface UILocationListView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;

@property (strong, nonatomic) CommonLocationViewModel *model;
@property (strong, nonatomic) CommonLocationViewCallbacks *callbacks;

@property (readwrite, strong, nonatomic) NSMutableArray<CLLocation*> *allLocations;
@property (assign, nonatomic) NSInteger highlightedIndex;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightCn;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation UILocationListView

-(void)commonInit {
    [super commonInit];
    self.allLocations = [[NSMutableArray alloc] init];
    [self setupTableView];
}

-(void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:[UILocationListViewCell identifierNibName] bundle:[NSBundle PPCloakBundle]];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:[UILocationListViewCell identifierNibName]];
    
    self.tableView.rowHeight = 70;
}

-(void)setupWithModel:(CommonLocationViewModel *)model callbacks:(CommonLocationViewCallbacks *)callbacks{
    [self setupWithInitialList:model.initialLocations callbacks:callbacks];
    self.model = model;
    if (!self.model.editable) {
        self.toolbarHeightCn.constant = 0;
        self.toolbar.hidden = YES;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        if (!self.model.initialLocations.count) {
            self.tutorialLabel.text = @"No locations added";
        } else {
            self.tutorialLabel.hidden = YES;
        }
    }
}

-(void)setupWithInitialList:(NSArray<CLLocation *> *)initialLocations callbacks:(CommonLocationViewCallbacks *)callbacks {
    if (initialLocations) {
        [self.allLocations addObjectsFromArray:initialLocations];
    }
    self.callbacks = callbacks;
    self.tutorialLabel.hidden = self.allLocations.count;
}

-(void)addNewLocation:(CLLocation *)location {
    [self.allLocations addObject:location];
    [self.tableView reloadData];
    self.tutorialLabel.hidden = YES;
}

-(void)removeLocationAt:(NSInteger)index {
    [self.allLocations removeObjectAtIndex:index];
    [self.tableView reloadData];
}

-(void)modifyLocationAt:(NSInteger)index to:(CLLocation *)location{
    [self.allLocations replaceObjectAtIndex:index withObject:location];
    [self.tableView reloadData];
}

-(void)highlightLocationAt:(NSInteger)index {
    
    if (self.highlightedIndex >= 0 && self.highlightedIndex < self.allLocations.count) {
        UILocationListViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.highlightedIndex inSection:0]];
        [cell setSelected:NO animated:YES];
    }
    
    self.highlightedIndex = index;
    UILocationListViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [cell setSelected:YES animated:YES];
    
}

#pragma mark - 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILocationListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UILocationListViewCell identifierNibName]];
    
    CLLocationCoordinate2D coord = self.allLocations[indexPath.row].coordinate;
    __weak typeof(self) weakSelf = self;
    __weak UILocationListViewCell *weakCell = cell;

    
    UILocationListViewCellCallbacks *callbacks = [[UILocationListViewCellCallbacks alloc] init];
    callbacks.onCoordinatesUpdate = ^void(double latitude, double longitude) {
        NSIndexPath *idxPath = [weakSelf.tableView indexPathForCell:weakCell];

        CLLocation *locaton = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        [weakSelf.allLocations replaceObjectAtIndex:idxPath.row withObject:locaton];
        SAFECALL(weakSelf.callbacks.onModifyLocationAtIndex, locaton, indexPath.row)
    };
    
    callbacks.onDelete = ^void() {
        NSIndexPath *idxPath = [weakSelf.tableView indexPathForCell:weakCell];
        if (idxPath) {
            [weakSelf.allLocations removeObjectAtIndex:idxPath.row];
            [weakSelf.tableView reloadData];
            SAFECALL(weakSelf.callbacks.onDeleteLocationAtIndex, idxPath.row)
            weakSelf.tutorialLabel.hidden = weakSelf.allLocations.count;
        }
    };
    
    
    UILocationListViewCellModel *model = [[UILocationListViewCellModel alloc] init];
    model.latitude = coord.latitude;
    model.longitude = coord.longitude;
    model.locationIndex = indexPath.row + 1;
    model.editable = self.model.editable;
    
    [cell setupWithModel:model callbacks:callbacks];
    [cell setSelected:self.highlightedIndex == indexPath.row animated:NO];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - 

- (IBAction)didPressDeleteAll:(id)sender {
    
    [CommonViewUtils showConfirmAlertWithMessage:@"Are you sure you want to delete all items?" onConfirm:^{
        [self.allLocations removeAllObjects];
        [self.tableView reloadData];
        SAFECALL(self.callbacks.onDeleteAll)
        self.tutorialLabel.hidden = NO;
    }];
    
}


- (IBAction)didPressAdd:(id)sender {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    [self.allLocations addObject:location];
    [self.tableView reloadData];
    SAFECALL(self.callbacks.onNewLocationAdded, location)
    self.tutorialLabel.hidden = YES;
}

-(NSArray<CLLocation *> *)currentLocations {
    return [NSArray arrayWithArray:self.allLocations];
}

@end
