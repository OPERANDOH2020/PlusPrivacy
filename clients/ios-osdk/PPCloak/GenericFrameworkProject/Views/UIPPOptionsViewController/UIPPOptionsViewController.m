//
//  UIPPOptionsViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIPPOptionsViewController.h"
#import "Common.h"

@implementation UIPPOptionsViewControllerCallbacks
@end

@interface UIPPOptionsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (strong, nonatomic) UIPPOptionsViewControllerCallbacks *callbacks;
@property (strong, nonatomic) OPMonitorSettings *monitorSettings;

@end

@implementation UIPPOptionsViewController

-(void)setupWithCallbacks:(UIPPOptionsViewControllerCallbacks *)callbacks andMonitorSettings:(OPMonitorSettings *)monitorSettings {
    self.callbacks = callbacks;
    self.monitorSettings = monitorSettings;
    
    
    
    [self view];
    self.notificationsSwitch.on = monitorSettings.allowNotifications;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^cellCallback)() = [self getCallbackForCellAtIndex:indexPath];
    SAFECALL(cellCallback)
}



-(void(^ __nullable)())getCallbackForCellAtIndex:(NSIndexPath*)indexPath {
    if (indexPath.section == 1) {
        return nil;
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return  self.callbacks.whenChoosingOverrideLocation;
        }
        return self.callbacks.whenChoosingLocationStatus;
    }
    
    switch (indexPath.row) {
        case 0:
            return self.callbacks.whenChoosingSCDInfo;
            break;
        case 1:
            return self.callbacks.whenChoosingViewSCD;
            break;
        case 2:
            return self.callbacks.whenChoosingReportsInfo;
            break;
        case 3:
            return self.callbacks.whenChoosingUsageGraphs;
        default:
            break;
    }
    
    return nil;
}


- (IBAction)didChangeSwitchValue:(id)sender {
    self.monitorSettings.allowNotifications = self.notificationsSwitch.on;
}

- (IBAction)didPressClose:(id)sender {
    SAFECALL(self.callbacks.whenExiting)
}


@end
