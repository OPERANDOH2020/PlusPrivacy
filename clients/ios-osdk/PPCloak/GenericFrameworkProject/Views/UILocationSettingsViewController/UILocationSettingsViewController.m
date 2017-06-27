//
//  UILocationSettingsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UILocationSettingsViewController.h"
#import "Common.h"
#import "UILocationListView.h"
#import "UILocationPinningView.h"
#import "UILocationSettingsView.h"

#pragma mark -

@implementation UserDefinedLocationsSettingsModel
@end

@interface UILocationSettingsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) void(^_Nullable onExitCallback)();
@property (strong, nonatomic) UserDefinedLocationsSettingsModel *model;

@property (weak, nonatomic) IBOutlet UILocationListView *locationListView;
@property (weak, nonatomic) IBOutlet UILocationPinningView *locationPinningView;
@property (weak, nonatomic) IBOutlet UILocationSettingsView *locationSettingsView;

@end



@implementation UILocationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationPinningView.hidden = YES;
}

-(void)setupWithModel:(UserDefinedLocationsSettingsModel *)model onExit:(void (^)())exitCallback {
    [self view];
    
    self.model = model;
    self.onExitCallback = exitCallback;
    
    CommonLocationViewCallbacks *locationPinningViewCallbacks = [self createLocationPinningViewCallbacks];
    CommonLocationViewCallbacks *locationListViewCallbacks = [self createLocationListCallbacks];
    
    UserDefinedLocationsSwizzlerSettings *currentSettings = model.getCallback();
    
    CommonLocationViewModel *locationListViewModel = [[CommonLocationViewModel alloc] initWithLocations:currentSettings.locations editable:YES];
    
    [self.locationListView setupWithModel:locationListViewModel callbacks:locationListViewCallbacks];
    [self.locationPinningView setupWithModel:locationListViewModel callbacks:locationPinningViewCallbacks];
    
    UILocationSettingsViewSettings *settings = [[UILocationSettingsViewSettings alloc] initWithInterval:currentSettings.changeInterval cycle:currentSettings.cycle enabled:currentSettings.enabled];
    UILocationSettingsViewCallbacks *locationSettingsViewCallbacks = [self callbacksForLocationSettingsView];
    [self.locationSettingsView setupWithCurrentSettings:settings editable:YES callbacks:locationSettingsViewCallbacks];
}


-(CommonLocationViewCallbacks*)createLocationListCallbacks{
    WEAKSELF
    
    CommonLocationViewCallbacks *callbacks = [[CommonLocationViewCallbacks alloc] init];
    
    callbacks.onNewLocationAdded = ^void(CLLocation *location){
        [weakSelf.locationPinningView addNewLocation:location];
    };
    
    callbacks.onDeleteAll = ^void() {
        [weakSelf.locationPinningView clearAll];
    };
    
    callbacks.onDeleteLocationAtIndex = ^void(NSInteger index){
        [weakSelf.locationPinningView deleteLocationAt:index];
    };
    
    callbacks.onModifyLocationAtIndex = ^void(CLLocation *location, NSInteger index){
        [weakSelf.locationPinningView modifyLocationAt:index toLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    };
    return callbacks;
}

-(CommonLocationViewCallbacks*)createLocationPinningViewCallbacks{
    CommonLocationViewCallbacks *callbacks = [[CommonLocationViewCallbacks alloc] init];
    WEAKSELF
    callbacks.onNewLocationAdded = ^void(CLLocation *location){
        [weakSelf.locationListView addNewLocation:location];
    };
    
    callbacks.onDeleteLocationAtIndex = ^void(NSInteger index){
        [weakSelf.locationListView removeLocationAt:index];
    };
    
    callbacks.onModifyLocationAtIndex = ^void(CLLocation *location, NSInteger index){
        [weakSelf.locationListView modifyLocationAt:index to:location];
    };
    return callbacks;
}

-(UILocationSettingsViewCallbacks*)callbacksForLocationSettingsView {
    WEAKSELF
    
    UILocationSettingsViewCallbacks *callbacks = [[UILocationSettingsViewCallbacks alloc] init];
    callbacks.onListItemsPress = ^{
        weakSelf.locationPinningView.hidden = YES;
        weakSelf.locationListView.hidden = NO;
    };
    
    
    callbacks.onMapItemsPress = ^{
        weakSelf.locationPinningView.hidden = NO;
        weakSelf.locationListView.hidden = YES;
    };
    
    return callbacks;
}



- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.onExitCallback)
}

- (IBAction)didPressSave:(id)sender {
    [self compileSettingsAndSave];
}

-(void)compileSettingsAndSave {
    UILocationSettingsViewSettings *settings = self.locationSettingsView.currentSettings;
    NSError *error = nil;
    
    UserDefinedLocationsSwizzlerSettings *swizzlerSettings = [UserDefinedLocationsSwizzlerSettings createWithLocations:self.locationListView.currentLocations enabled:settings.enabled cycle:settings.cycle changeInterval:settings.changeInterval error:&error];
    
    if (error) {
        [CommonViewUtils showOkAlertWithMessage:error.localizedDescription completion:nil];
        return;
    }
    SAFECALL(self.model.saveCallback, swizzlerSettings);
    
}

@end
