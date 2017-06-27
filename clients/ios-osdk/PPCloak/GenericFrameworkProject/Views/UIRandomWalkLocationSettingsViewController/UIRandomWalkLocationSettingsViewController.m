//
//  UIRandomWalkLocationSettingsViewController.m
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIRandomWalkLocationSettingsViewController.h"
#import "UIRandomWalkMapView.h"
#import "Common.h"

@implementation UIRandomWalkLocationSettingsVCCallbacks
@end

@interface UIRandomWalkLocationSettingsViewController ()
@property (strong, nonatomic) UIRandomWalkLocationSettingsVCCallbacks *callbacks;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@property (weak, nonatomic) IBOutlet UIRandomWalkMapView *randomWalkMapView;
@property (strong, nonatomic) RandomWalkGenerator *randomWalkGenerator;

@property (strong, nonatomic) NSArray<CLLocation*> *currentWalk;
@property (strong, nonatomic) RandomWalkBoundCircle *boundCircle;

@end

@implementation UIRandomWalkLocationSettingsViewController

-(void)setupWithModel:(RandomWalkLocationSettingsModel *)model callbacks:(UIRandomWalkLocationSettingsVCCallbacks *)callbacks {
    [self view];
    self.randomWalkGenerator = model.randomWalkGenerator;
    self.currentWalk = model.currentSettings.walkPath;
    self.boundCircle = model.currentSettings.boundCircle;
    [self setupWithSettings:model.currentSettings callbacks:callbacks];
}

-(void)setupWithSettings:(RandomWalkSwizzlerSettings *)settings callbacks:(UIRandomWalkLocationSettingsVCCallbacks *)callbacks{
    
    self.callbacks = callbacks;
    self.enabledSwitch.on = settings.enabled;
    WEAKSELF
    UIRandomWalkMapViewModel *model = [[UIRandomWalkMapViewModel alloc] init];
    model.initialCircle = settings.boundCircle;
    model.initialLocations = settings.walkPath;
    model.editable = YES;
    
    UIRandomWalkMapViewCallbacks *mapViewCallbacks = [[UIRandomWalkMapViewCallbacks alloc] init];
    mapViewCallbacks.onBoundCircleChange = ^(RandomWalkBoundCircle *newCircle) {
        [weakSelf.randomWalkMapView displayAsBusy:YES];
        [weakSelf.randomWalkGenerator generateRandomWalkInCircle:newCircle withCompletion:^(NSArray<CLLocation *> *newWalk) {
            weakSelf.currentWalk = newWalk;
            weakSelf.boundCircle = newCircle;
            [weakSelf.randomWalkMapView drawNewLocations:newWalk];
            
            [weakSelf.randomWalkMapView displayAsBusy:NO];
        }];
        
    };
    
    [self.randomWalkMapView setupWithModel:model callbacks:mapViewCallbacks];
    
}

- (IBAction)didPressBack:(id)sender {
    SAFECALL(self.callbacks.onExit)
}
- (IBAction)didPressSave:(id)sender {
    
    RandomWalkSwizzlerSettings *compiledSettings = [RandomWalkSwizzlerSettings createWithCircle:self.boundCircle walkPath:self.currentWalk enabled:self.enabledSwitch.on error:nil];
    
    SAFECALL(self.callbacks.onSettingsSave, compiledSettings)
}

@end
