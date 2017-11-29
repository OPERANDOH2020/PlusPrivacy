//
//  UISignInViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

typealias LoginCallback = (_ loginInfo: LoginInfo) -> Void
typealias CallbackWithString = (_ arg: String) -> Void
typealias CallbackPresentForgotEmailInputAlert = (_ completion: CallbackWithString? ) -> Void

struct UISignInViewControllerCallbacks {
    let whenUserWantsToLogin: LoginCallback?
    let whenUserForgotPassword: ((_ email: String) -> Void)?
    let whenUserPressedRegister: VoidBlock?
    
    static let allNil: UISignInViewControllerCallbacks = UISignInViewControllerCallbacks(whenUserWantsToLogin: nil, whenUserForgotPassword: nil, whenUserPressedRegister: nil)
    
}

struct UISignInViewControllerOutlets {
    let loginViewLogic: UILoginViewLogic?
    let registerButton: UIButton?
}

struct UISignInViewControllerLogicCallbacks {
    let presentOkAlert: CallbackWithString?
    let presentForgotEmailInputAlert: CallbackPresentForgotEmailInputAlert?
    
    public static let allNil: UISignInViewControllerLogicCallbacks = UISignInViewControllerLogicCallbacks(presentOkAlert: nil, presentForgotEmailInputAlert: nil)
}

class UISignInViewControllerLogic: NSObject {
    
    private var signInCallbacks: UISignInViewControllerCallbacks?
    
    private let callbacks: UISignInViewControllerLogicCallbacks
    private let outlets: UISignInViewControllerOutlets
    
    init(outlets: UISignInViewControllerOutlets, callbacks: UISignInViewControllerLogicCallbacks) {
        self.outlets = outlets
        self.callbacks = callbacks
        super.init()
        
        outlets.registerButton?.addTarget(self, action: #selector(didPressRegisterButton(_:)), for: .touchUpInside)
    }
    
    func setupWithCallbacks(_ cbs: UISignInViewControllerCallbacks?) {
        self.signInCallbacks = cbs
        self.outlets.loginViewLogic?.setupWith(callbacks: self.callbacksForLoginView());
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        self.signInCallbacks?.whenUserPressedRegister?()
    }
    
    
    private func callbacksForLoginView() -> UILoginViewCallbacks?
    {
        weak var weakSelf = self
        return UILoginViewCallbacks(whenUserWantsToLogin: self.signInCallbacks?.whenUserWantsToLogin, whenUserForgetsPassword: {
            weakSelf?.callbacks.presentForgotEmailInputAlert? { email in
                
                guard OPUtils.isValidEmail(email: email) else {
                    weakSelf?.callbacks.presentOkAlert?(Bundle.localizedStringFor(key: kEmailIsNotValidLocalizableKey))
                    return
                }
                
                weakSelf?.signInCallbacks?.whenUserForgotPassword?(email)
            }
        })
    }

    
}

class UISignInViewController: UIViewController {
    

    @IBOutlet weak var loginView: UILoginView!
    @IBOutlet weak var registerButton: UIButton?
    
    lazy var logic: UISignInViewControllerLogic = {
        let _ = self.view;
        
        let outlets: UISignInViewControllerOutlets = UISignInViewControllerOutlets(loginViewLogic: self.loginView.logic, registerButton: self.registerButton)
        
        let logic = UISignInViewControllerLogic(outlets: outlets, callbacks: UISignInViewControllerLogicCallbacks(presentOkAlert: { message in
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: message)
            
        }, presentForgotEmailInputAlert: OPViewUtils.displayForgotEmailPassword
        ))
        
        return logic;
    }()
        
}
