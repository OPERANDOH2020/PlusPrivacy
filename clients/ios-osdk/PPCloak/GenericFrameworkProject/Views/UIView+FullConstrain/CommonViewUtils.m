//
//  UIView+FullConstrain.m
//  PPCloak
//
//  Created by Costin Andronache on 4/3/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonViewUtils.h"
#import "Common.h"

@implementation CommonViewUtils

+(void)fullyConstrainView:(UIView*)view inHostView:(UIView*)hostView {
    view.translatesAutoresizingMaskIntoConstraints = false;
    [hostView addSubview:view];
    
    NSLayoutConstraint*(^buildConstraintWithSelfForAttribute)(NSLayoutAttribute attribute) = ^NSLayoutConstraint*(NSLayoutAttribute attribute){
        return [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:hostView attribute:attribute multiplier:1.0 constant:0];
    };
    
    [hostView addConstraints:@[buildConstraintWithSelfForAttribute(NSLayoutAttributeTop),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeBottom),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeLeft),
                           buildConstraintWithSelfForAttribute(NSLayoutAttributeRight)]];
}


+(void)showOkAlertWithMessage:(NSString *)message completion:(void (^)())completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(alertController) weakController = alertController;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SAFECALL(completion)
        [weakController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootController presentViewController:alertController animated:YES completion:nil];
}


+(void)showConfirmAlertWithMessage:(NSString *)message onConfirm:(void (^)())confirm {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(alertController) weakController = alertController;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        SAFECALL(confirm)
        [weakController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    
    UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootController presentViewController:alertController animated:YES completion:nil];

}

@end
