//
//  LoginView.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct LoginInfo
{
    let username : String
    let password: String
    let wishesToBeRemembered: Bool
}

struct UILoginViewCallbacks
{
    let whenUserWantsToLogin : ((info : LoginInfo) -> ())?
    let whenUserForgetsPassword: (() -> ())?
}

class UILoginView: RSNibDesignableView {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    private var callbacks: UILoginViewCallbacks?
    
    
    func setupWithCallbacks(callbacks: UILoginViewCallbacks?)
    {
        self.callbacks = callbacks;
    }
    
    @IBAction func didPressForgotPassword(sender: AnyObject)
    {
        self.callbacks?.whenUserForgetsPassword?();
    }
    
    @IBAction func didPressSignInButton(sender: AnyObject)
    {
        let loginInfo = LoginInfo(username: self.emailTF.text ?? "", password: self.passwordTF.text ?? "", wishesToBeRemembered: self.rememberMeSwitch.on);
        self.callbacks?.whenUserWantsToLogin?(info: loginInfo);
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event);
        self.endEditing(true);
    }
}
