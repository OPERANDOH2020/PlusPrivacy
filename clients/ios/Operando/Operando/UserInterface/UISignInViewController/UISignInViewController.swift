//
//  UISignInViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

typealias LoginCallback = (_ loginInfo: LoginInfo) -> Void

let kEmailIsNotValidLocalizableKey = "kEmailIsNotValidLocalizableKey"

struct UISignInViewControllerCallbacks
{
    let whenUserWantsToLogin: LoginCallback?
    let whenUserForgotPassword: ((_ email: String) -> Void)?
    let whenUserPressedRegister: VoidBlock?
}

class UISignInViewController: UIViewController {
    

    @IBOutlet weak var loginView: UILoginView!
    fileprivate var callbacks: UISignInViewControllerCallbacks?
    
    
    
    func setupWithCallbacks(_ cbs: UISignInViewControllerCallbacks?)
    {
        let _ = self.view
        self.callbacks = cbs
        self.loginView.setupWithCallbacks(callbacks: self.callbacksForLoginView(loginView: self.loginView));

    }
    
    
    @IBAction func didPressRegisterButton(_ sender: UIButton)
    {
        
        self.callbacks?.whenUserPressedRegister?()
    }
    
    
    private func callbacksForLoginView(loginView: UILoginView) -> UILoginViewCallbacks?
    {
        weak var weakSelf = self
        return UILoginViewCallbacks(whenUserWantsToLogin: self.callbacks?.whenUserWantsToLogin, whenUserForgetsPassword: {
            OPViewUtils.displayForgotEmailPassword { email in
                guard OPUtils.isValidEmail(testStr: email) else {
                    OPViewUtils.showOkAlertWithTitle(title: "", andMessage: Bundle.localizedStringFor(key: kEmailIsNotValidLocalizableKey))
                    return
                }
                
                weakSelf?.callbacks?.whenUserForgotPassword?(email)
            }
        })
    }
    
}
