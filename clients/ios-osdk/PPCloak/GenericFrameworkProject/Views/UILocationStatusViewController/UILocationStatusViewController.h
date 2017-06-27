//
//  UILocationStatusViewController.h
//  PPCloak
//
//  Created by Costin Andronache on 4/4/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefinedLocationsSwizzlerSettings.h"
#import "CommonLocationViewModels.h"

@interface UILocationStatusModel: NSObject
@property (strong, nonatomic) UserDefinedLocationsSwizzlerSettings *currentSettings;
@property (assign, nonatomic) NSInteger currentActiveLocationIndex;
@property (strong, nonatomic) ActiveLocationChangeBlockArgument registerChangeCallback;
@property (strong, nonatomic) ActiveLocationChangeBlockArgument removeChangeCallback;


@end

@interface UILocationStatusViewController : UIViewController

-(void)setupWithModel:(UILocationStatusModel*)model onExit:(void(^)())exitCallback;

@end
