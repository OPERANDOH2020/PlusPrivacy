//
//  UIView+FullConstrain.h
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewUtils : NSObject 
+(void)fullyConstrainView:(UIView*)view inHostView:(UIView*)hostView;
+(void)showOkAlertWithMessage:(NSString*)message completion:(void(^)())completion;
+(void)showConfirmAlertWithMessage:(NSString*)message onConfirm:(void(^)())confirm;
@end
