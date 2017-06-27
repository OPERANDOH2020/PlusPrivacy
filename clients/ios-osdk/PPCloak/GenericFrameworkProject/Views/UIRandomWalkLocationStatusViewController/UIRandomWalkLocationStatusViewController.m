//
//  UIRandomWalkLocationStatusViewController.m
//  PPCloak
//
//  Created by Costin Andronache on 4/11/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIRandomWalkLocationStatusViewController.h"
#import "UIRandomWalkMapView.h"
#import "Common.h"

@interface UIRandomWalkLocationStatusViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@property (weak, nonatomic) IBOutlet UIRandomWalkMapView *mapView;
@property (strong, nonatomic) RandomWalkLocationStatusModel *model;
@property (strong, nonatomic) CurrentActiveLocationIndexChangedCallback callbackForChanges;
@property (strong, nonatomic) void(^exitCallback)();
@end

@implementation UIRandomWalkLocationStatusViewController

-(void)setupWithModel:(RandomWalkLocationStatusModel *)model onExit:(void (^)())exitCallback {
    [self view];
    self.enabledSwitch.on = model.currentSettings.enabled;
    self.model = model;
    self.exitCallback = exitCallback;
    
    UIRandomWalkMapViewModel *mapVM = [[UIRandomWalkMapViewModel alloc] init];
    mapVM.initialCircle = model.currentSettings.boundCircle;
    mapVM.initialLocations = model.currentSettings.walkPath;
    mapVM.editable = NO;
    
    [self.mapView setupWithModel:mapVM callbacks:nil];
    [self.mapView displayPinForLocationAt:model.currentSentLocationIndex];
    
    WEAKSELF
    self.callbackForChanges = ^(NSInteger newIndex) {
        [weakSelf.mapView displayPinForLocationAt:newIndex];
    };
    
    SAFECALL(model.registerCallbackForChanges, self.callbackForChanges)
}


- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.exitCallback)
}


-(void)dealloc {
    SAFECALL(self.model.removeCallbackForChanges, self.callbackForChanges)
}

@end
