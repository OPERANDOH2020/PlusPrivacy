//
//  UISCDViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/14/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UISCDViewController : UIViewController

-(void)setupWithSCD:(NSDictionary*)scdDict onClose:(void (^)())closeCallback;

@end
