//
//  UILocationStatusViewController.m
//  PPCloak
//
//  Created by Costin Andronache on 4/4/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationStatusViewController.h"
#import "UILocationListView.h"
#import "UILocationPinningView.h"
#import "UILocationSettingsView.h"
#import "Common.h"

@implementation UILocationStatusModel
@end

@interface UILocationStatusViewController ()

@property (weak, nonatomic) IBOutlet UILocationListView *locationListView;
@property (weak, nonatomic) IBOutlet UILocationPinningView *locationPinningView;
@property (weak, nonatomic) IBOutlet UILocationSettingsView *locationSettingsView;
@property (strong, nonatomic) void (^exitCallback)();
@property (strong, nonatomic) CurrentActiveLocationIndexChangedCallback changeCallback;
@property (strong, nonatomic) UILocationStatusModel *model;
@end

@implementation UILocationStatusViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.locationPinningView.hidden = YES;
}

-(void)setupWithModel:(UILocationStatusModel *)model onExit:(void (^)())exitCallback {
    WEAKSELF
    [self view];
    
    self.exitCallback = exitCallback;
    self.model = model;
    
    CommonLocationViewModel *commonVM = [[CommonLocationViewModel alloc] initWithLocations:model.currentSettings.locations editable:NO];
    [self.locationPinningView setupWithModel:commonVM callbacks:nil];
    [self.locationListView setupWithModel:commonVM callbacks:nil];
    
    [self.locationListView highlightLocationAt:model.currentActiveLocationIndex];
    [self.locationPinningView highlightLocationAt:model.currentActiveLocationIndex];
    
    
    UILocationSettingsViewCallbacks *locSetttingsCbs = [[UILocationSettingsViewCallbacks alloc] init];
    locSetttingsCbs.onMapItemsPress = ^{
        weakSelf.locationPinningView.hidden = NO;
        weakSelf.locationListView.hidden = YES;
    };
    
    locSetttingsCbs.onListItemsPress = ^{
        weakSelf.locationListView.hidden = NO;
        weakSelf.locationPinningView.hidden = YES;
    };
    
    UILocationSettingsViewSettings *displayedSettings = [[UILocationSettingsViewSettings alloc] initWithInterval:model.currentSettings.changeInterval cycle:model.currentSettings.cycle enabled:model.currentSettings.enabled];
    
    [self.locationSettingsView setupWithCurrentSettings:displayedSettings editable:NO callbacks:locSetttingsCbs];
    
    self.changeCallback = ^(NSInteger newIndex) {
        [weakSelf.locationPinningView highlightLocationAt:newIndex];
        [weakSelf.locationListView highlightLocationAt:newIndex];
    };
    
    SAFECALL(model.registerChangeCallback, self.changeCallback)
}

-(void)dealloc {
    SAFECALL(self.model.removeChangeCallback, self.changeCallback)
}
- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.exitCallback)
}

@end
