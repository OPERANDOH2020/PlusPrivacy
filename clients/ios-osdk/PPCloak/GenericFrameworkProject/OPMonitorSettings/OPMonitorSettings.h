//
//  OPMonitorSettings.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPMonitorSettings : NSObject

@property (assign, nonatomic) BOOL allowNotifications;


-(instancetype)initFromDefaults;
@end
