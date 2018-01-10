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

struct UILoginViewOutlets {
    let emailTF: UITextField?
    let passwordTF: UITextField?
    let rememberMeSwitch: UISwitch?
    let signInButton: UIButton?
    let forgotPasswordButton: UIButton?
}

class UILoginViewLogic: NSObject, UITextFieldDelegate {
    
    let outlets: UILoginViewOutlets
    var callbacks: UILoginViewCallbacks?
    
    init(outlets: UILoginViewOutlets) {
        self.outlets = outlets;
        super.init()
        
        outlets.emailTF?.delegate = self
        outlets.passwordTF?.delegate = self
        
        outlets.signInButton?.addTarget(self, action: #selector(didPressSignInButton(_:)), for: .touchUpInside)
        outlets.forgotPasswordButton?.addTarget(self, action: #selector(didPressForgotPassword(_:)), for: .touchUpInside)
        
        if let credentials = CredentialsStore.retrieveLastSavedCredentialsIfAny() {
            outlets.emailTF?.text = credentials.username
            outlets.passwordTF?.text = credentials.password
        }
        
    }
    
    func setupWith(callbacks: UILoginViewCallbacks?){
        self.callbacks = callbacks;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.endEditing(true)
            
            if let emailTF = self.outlets.emailTF, textField == emailTF {
                self.outlets.passwordTF?.becomeFirstResponder()
            } else {
                self.didPressSignInButton(nil)
            }
        }
        return true
    }
    
    @IBAction func didPressForgotPassword(_ sender: AnyObject) {
        self.callbacks?.whenUserForgetsPassword?();
    }
    
    @IBAction func didPressSignInButton(_ sender: AnyObject?) {
        
        let loginInfo = LoginInfo(email: self.outlets.emailTF?.text ?? "", password: self.outlets.passwordTF?.text ?? "", wishesToBeRemembered: true);
        self.callbacks?.whenUserWantsToLogin?(loginInfo);
    }
}


class UILoginView: RSNibDesignableView {

    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    lazy var logic: UILoginViewLogic = {
       return UILoginViewLogic(outlets: UILoginViewOutlets(emailTF: self.emailTF, passwordTF: self.passwordTF, rememberMeSwitch: self.rememberMeSwitch, signInButton: self.signInButton, forgotPasswordButton: self.forgotPasswordButton))
    }()

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    

}
