//
//  PPFlowBuilder.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPFlowBuilder.h"
#import "ReportsStorageProtocol.h"
#import "UIViolationReportsViewController.h"
#import "UIPPOptionsViewController.h"
#import "UIEncapsulatorViewController.h"
#import "UISCDViewController.h"
#import "NSBundle+RSFrameworkHooks.h"
#import "UIUsageViewController.h"
#import "UIInputGraphViewController.h"
#import "UIRandomWalkLocationSettingsViewController.h"
#import "UIRandomWalkLocationStatusViewController.h"

@implementation PPFlowBuilderLocationModel
@end

@implementation PPFlowBuilderModel
@end



@implementation PPFlowBuilder

-(UIViewController *)buildFlowWithModel:(PPFlowBuilderModel *)model {
    
    NSBundle *bundle = [NSBundle PPCloakBundle];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PPViews" bundle:bundle];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBarHidden = true;
    
    __weak UINavigationController *weakNavgController = navigationController;
    
    UIPPOptionsViewController *optionsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIPPOptionsViewController"];
    
    UIPPOptionsViewControllerCallbacks *callbacks = [[UIPPOptionsViewControllerCallbacks alloc] init];
    
    callbacks.whenChoosingSCDInfo = ^{
        
        CommonUIDisplayModel *displayModel = [[CommonUIDisplayModel alloc] init];
        displayModel.titleBarHeight = 64;
        displayModel.exitButtonType = UISCDDocumentsControllerExitButtonTypeTypeArrowLeft;
        
        UIViewController *commonUIVC = [CommonUIBUilder buildFlowFor:model.scdRepository displayModel:displayModel whenExiting:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
    
        UIViewController *commonUIIncapsulator = [[UIEncapsulatorViewController alloc] init];
        [commonUIIncapsulator ppAddChildContentController:commonUIVC];
        
        [weakNavgController pushViewController:commonUIIncapsulator animated:true];
    };
    
    callbacks.whenChoosingReportsInfo = ^{
        UIViolationReportsViewController *reportsVC = [storyboard instantiateViewControllerWithIdentifier:@"UIViolationReportsViewController"];
        [reportsVC setupWithReportSources:model.reportSources onExit:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
        
        [weakNavgController pushViewController:reportsVC animated:true];
    };
    
    callbacks.whenChoosingViewSCD = ^{
        UISCDViewController *scdVC = [storyboard instantiateViewControllerWithIdentifier:@"UISCDViewController"];
        
        [scdVC setupWithSCD:model.scdJSON onClose:^{
            [weakNavgController popViewControllerAnimated:true];
        }];
        
        [weakNavgController pushViewController:scdVC animated:true];
    };
    
    callbacks.whenChoosingOverrideLocation = ^{
        UIRandomWalkLocationSettingsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UIRandomWalkLocationSettingsViewController"];
        
        RandomWalkLocationSettingsModel *randomWalkModel = model.eveythingLocationRelated.getCurrentRandomWalkSettingsCallback();
        
        UIRandomWalkLocationSettingsVCCallbacks *callbacks = [[UIRandomWalkLocationSettingsVCCallbacks alloc] init];
        callbacks.onExit = ^{
            [weakNavgController popViewControllerAnimated:YES];
        };
        
        callbacks.onSettingsSave = model.eveythingLocationRelated.onSaveCurrentRandomWalkSettings;
        
        [vc setupWithModel:randomWalkModel callbacks:callbacks];
        [weakNavgController pushViewController:vc animated:YES];
    };
    
    
    callbacks.whenChoosingLocationStatus = ^{
        UIRandomWalkLocationStatusViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UIRandomWalkLocationStatusViewController"];
        
        RandomWalkLocationStatusModel *statusModel = [[RandomWalkLocationStatusModel alloc] init];
        statusModel.currentSentLocationIndex = model.eveythingLocationRelated.getCurrentActiveLocationIndex();
        statusModel.currentSettings = model.eveythingLocationRelated.getCurrentRandomWalkSettingsCallback().currentSettings;
        statusModel.registerCallbackForChanges = model.eveythingLocationRelated.registerChangeCallback;
        statusModel.removeCallbackForChanges = model.eveythingLocationRelated.removeChangeCallback;
        
        [vc setupWithModel:statusModel onExit:^{
            [weakNavgController popViewControllerAnimated:YES];
        }];
        
        [weakNavgController pushViewController:vc animated:YES];
    };
    
//    callbacks.whenChoosingOverrideLocation = ^{
//        UILocationSettingsViewController *locSettingsVC = [storyboard instantiateViewControllerWithIdentifier:@"UILocationSettingsViewController"];
//        [locSettingsVC setupWithModel:model.eveythingLocationRelated.UserDefinedLocationsSettingsModel onExit:^{
//            [weakNavgController popViewControllerAnimated:YES];
//        }];
//        [weakNavgController pushViewController:locSettingsVC animated:YES];
//    };
    
//    callbacks.whenChoosingLocationStatus = ^{
//        UILocationStatusViewController *statusVC = [storyboard instantiateViewControllerWithIdentifier:@"UILocationStatusViewController"];
//        
//        UILocationStatusModel *locStatusModel = [[UILocationStatusModel alloc] init];
//        locStatusModel.removeChangeCallback = model.eveythingLocationRelated.removeChangeCallback;
//        locStatusModel.registerChangeCallback = model.eveythingLocationRelated.registerChangeCallback;
//        locStatusModel.currentActiveLocationIndex = model.eveythingLocationRelated.getCurrentActiveLocationIndex();
//        locStatusModel.currentSettings = model.eveythingLocationRelated.UserDefinedLocationsSettingsModel.getCallback();
//        
//        [statusVC setupWithModel:locStatusModel onExit:^{
//            [weakNavgController popViewControllerAnimated:YES];
//        }];
//        
//        [weakNavgController pushViewController:statusVC animated:YES];
//    };
    
    
    callbacks.whenExiting = model.onExitCallback;
    [optionsVC setupWithCallbacks:callbacks andMonitorSettings:model.monitoringSettings];
    navigationController.automaticallyAdjustsScrollViewInsets = NO;
    navigationController.viewControllers = @[optionsVC];
    return navigationController;
}

@end
