//
//  OPAlertUtils.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

let kResetLocalizableKey = "kResetLocalizableKey"
let kCancelLocalizableKey = "kCancelLocalizableKey"
let kResetPasswordAlertTitleLocalizableKey = "kResetPasswordAlertTitleLocalizableKey"
let kResetPasswordAlertDescriptionLocalizableKey = "kResetPasswordAlertDescriptionLocalizableKey"

class OPViewUtils
{
    class func disableViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 0.6;
            view.isUserInteractionEnabled = false;
        }
    }
    
    class func enbleViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 1.0;
            view.isUserInteractionEnabled = true;
        }
    }
    
    class func showOkAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok");
        alert.show();
    }
    
    
    class func displayAlertWithMessage(message: String, withTitle title: String, addCancelAction:Bool, withConfirmation confirmation: (() -> ())?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            confirmation?();
        }
        alert.addAction(okAction);
        
        if addCancelAction
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
            alert.addAction(cancelAction);
        }
        
        let hostController = UIApplication.shared.delegate?.window??.rootViewController?.topMostPresentedControllerOrSelf
        hostController?.present(alert, animated: true, completion: nil)
    }
    
    
    class func displayForgotEmailPassword(whenDone: ((_ email: String) -> Void)?) {
        
        let alertController = UIAlertController(title: Bundle.localizedStringFor(key: kResetPasswordAlertTitleLocalizableKey), message: Bundle.localizedStringFor(key: kResetPasswordAlertDescriptionLocalizableKey), preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: Bundle.localizedStringFor(key: kResetLocalizableKey), style: .default) { (_) in
            if let text = alertController.textFields?.first?.text {
                whenDone?(text)
            }
            
        
        }
        
        doneAction.isEnabled = false
        let cancelAction = UIAlertAction(title: Bundle.localizedStringFor(key: kCancelLocalizableKey), style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .done
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                doneAction.isEnabled = textField.text != ""
            }
        }
        

        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension UIView{
    public func attachPopUpAnimationWithDuration(_ duration: CFTimeInterval)
    {
        let animation = CAKeyframeAnimation(keyPath: "transform");
        
        let scale1 = CATransform3DMakeScale(1.3, 1.3, 1) //CATransform3DMakeScale(0.5, 0.5, 1);
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1)//CATransform3DMakeScale(1.2, 1.2, 1);
        let scale3 = CATransform3DMakeScale(1.1, 1.1, 1)//CATransform3DMakeScale(0.9, 0.9, 1);
        let scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
        
        let frameValues = [NSValue(caTransform3D: scale1),
                           NSValue(caTransform3D:scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)];
        
        animation.values = frameValues;
        animation.fillMode = kCAFillModeForwards;
        animation.isRemovedOnCompletion = false;
        animation.duration = duration;
        
        
        animation.keyTimes = [NSNumber(value: 0.0 as Float), NSNumber(value: 0.3 as Float), NSNumber(value: 0.6 as Float), NSNumber(value: 1.0 as Float)];
        self.layer.add(animation, forKey: nil);
    }

}
