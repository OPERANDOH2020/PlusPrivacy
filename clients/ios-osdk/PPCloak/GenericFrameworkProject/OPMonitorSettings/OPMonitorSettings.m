//
//  OPMonitorSettings.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitorSettings.h"

static  NSString *kMonitorSettingsKey = @"kMonitorSettingsKey";

@implementation OPMonitorSettings

-(instancetype)initFromDefaults {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:kMonitorSettingsKey]) {
            self.allowNotifications = [[defaults objectForKey:kMonitorSettingsKey] boolValue];
        } else {
            self.allowNotifications = YES;
        }
    }
    
    return self;
}

-(void)synchronize {
    [[NSUserDefaults standardUserDefaults] setBool:self.allowNotifications forKey:kMonitorSettingsKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAllowNotifications:(BOOL)allowNotifications {
    _allowNotifications = allowNotifications;
    [self synchronize];
}

@end
