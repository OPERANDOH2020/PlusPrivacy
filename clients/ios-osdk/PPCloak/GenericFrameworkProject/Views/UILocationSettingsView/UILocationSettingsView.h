//
//  UILocationSettingsView.h
//  PPCloak
//
//  Created by Costin Andronache on 4/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloakNibView.h"
#import "UserDefinedLocationsSwizzlerSettings.h"

@interface UILocationSettingsViewCallbacks : NSObject
@property (strong, nonatomic) void(^onMapItemsPress)();
@property (strong, nonatomic) void(^onListItemsPress)();
@end

@interface UILocationSettingsViewSettings : NSObject
@property (readonly, nonatomic) BOOL enabled;
@property (readonly, nonatomic) BOOL cycle;
@property (readonly, nonatomic) NSTimeInterval changeInterval;

-(instancetype)initWithInterval:(NSTimeInterval)changeInterval cycle:(BOOL)cycle enabled:(BOOL)enabled;
@end

@interface UILocationSettingsView : CloakNibView
@property (readonly, nonatomic) UILocationSettingsViewSettings* currentSettings;

-(void)setupWithCurrentSettings:(UILocationSettingsViewSettings*)settings editable:(BOOL)editable callbacks:(UILocationSettingsViewCallbacks*)callbacks;

@end
