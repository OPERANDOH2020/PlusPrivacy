//
//  UIViolationReportsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPReportsSourcesBundle.h"


@interface UIViolationReportsViewController : UIViewController
-(void)setupWithReportSources:(PPReportsSourcesBundle*)reportSources
                    onExit:(void (^)())exitCallback;
@end
