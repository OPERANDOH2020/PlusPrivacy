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
    let email : String
    let password: String
    let wishesToBeRemembered: Bool
}

struct UILoginViewCallbacks
{
    let whenUserWantsToLogin : ((_ info : LoginInfo) -> ())?
    let whenUserForgetsPassword: (() -> ())?
}

class UILoginView: RSNibDesignableView, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    private var callbacks: UILoginViewCallbacks?
    
    override func commonInit() {
        super.commonInit()
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
    }
    
    func setupWithCallbacks(callbacks: UILoginViewCallbacks?)
    {
        self.callbacks = callbacks;
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.endEditing(true)
            if textField == self.emailTF {
                self.passwordTF.becomeFirstResponder()
            } else {
                self.didPressSignInButton(nil)
            }
        }
        return true 
    }
    
    @IBAction func didPressForgotPassword(_ sender: AnyObject)
    {
        self.callbacks?.whenUserForgetsPassword?();
    }
    
    @IBAction func didPressSignInButton(_ sender: AnyObject?)
    {
        let loginInfo = LoginInfo(email: self.emailTF.text ?? "", password: self.passwordTF.text ?? "", wishesToBeRemembered: self.rememberMeSwitch.isOn);
        self.callbacks?.whenUserWantsToLogin?(loginInfo);
    }
    
    
    //MARK: TextField 
    

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    

}
