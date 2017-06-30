//
//  UIAboutViewController.h
//  PPCloak
//
//  Created by Costin Andronache on 6/30/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAboutViewControllerExitCallback)();

@interface UIAboutViewController : UIViewController
-(void)setupWithCallback:(UIAboutViewControllerExitCallback)callback;
@end
