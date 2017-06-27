//
//  UIRandomWalkLocationStatusViewController.h
//  PPCloak
//
//  Created by Costin Andronache on 4/11/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonLocationViewModels.h"



@interface UIRandomWalkLocationStatusViewController : UIViewController

-(void)setupWithModel:(RandomWalkLocationStatusModel*)model onExit:(void(^)())exitCallback;

@end
