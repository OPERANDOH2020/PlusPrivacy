//
//  UIRandomWalkLocationSettingsViewController.h
//  PPCloak
//
//  Created by Costin Andronache on 4/7/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomWalkSwizzlerSettings.h"
#import "CommonLocationViewModels.h"

@interface UIRandomWalkLocationSettingsVCCallbacks : NSObject
@property (strong, nonatomic) void (^onSettingsSave)(RandomWalkSwizzlerSettings *newSettings);
@property (strong, nonatomic) void (^onExit)();
@end


@interface UIRandomWalkLocationSettingsViewController : UIViewController
-(void)setupWithModel:(RandomWalkLocationSettingsModel*)model callbacks:(UIRandomWalkLocationSettingsVCCallbacks*)callbacks;
@end
