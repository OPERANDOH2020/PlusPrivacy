//
//  UIRegistrationView.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIRegistrationView: RSNibDesignableView, UITextFieldDelegate
{
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
 
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordsDontMatchLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    
    override func commonInit() {
        super.commonInit()
        
        self.invalidEmailLabel.hidden = true;
        self.passwordsDontMatchLabel.hidden = true;
        
        self.emailTF.delegate = self;
        self.confirmPasswordTF.delegate = self;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIRegistrationView.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIRegistrationView.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil);
        
        self.disableSignupButton();
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillAppear(notification: NSNotification)
    {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0);
    }
    
    func keyboardWillDisappear(notification: NSNotification)
    {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
    
    @IBAction func didPressSignUp(sender: AnyObject)
    {
        
    }
    
    @IBAction func didSwitchShowPasswordsOnOrOff(sender: UISwitch)
    {
        self.setSecureTextEntry(!sender.on);
    }
    
    
    //MARK: textfield delegate
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField == self.emailTF
        {
            self.handleEmailDidEndEditing();
        }
        
        if textField == self.confirmPasswordTF
        {
            self.handleConfirmationTFDidEndEditing();
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true);
        return true;
    }
    
    
    //MARK: internal utils
    private func handleEmailDidEndEditing()
    {
        if self.isEmailValid() == false
        {
            self.invalidEmailLabel.hidden = false;
        }
        else
        {
            self.invalidEmailLabel.hidden = true;
            
            if self.doPasswordsMatch()
            {
                self.enableSignupButton();
            }
            else
            {
                self.disableSignupButton();
            }
        }
    }
    
    private func handleConfirmationTFDidEndEditing()
    {
        if self.doPasswordsMatch() == false
        {
            self.passwordsDontMatchLabel.hidden = false;
            self.disableSignupButton();
        }
        else
        {
            self.passwordsDontMatchLabel.hidden = true;
            if self.isEmailValid()
            {
                self.enableSignupButton();
            }
            else
            {
                self.disableSignupButton()
            }
        }
    }
    
    private func isEmailValid() -> Bool
    {
        guard let email = self.emailTF.text else {return false}
        return OPUtils.isValidEmail(email);
    }
    
    private func doPasswordsMatch() -> Bool
    {
        guard let password = self.passwordTF.text else {return false}
        guard let confirmation = self.confirmPasswordTF.text else {return false}
        guard password.characters.count > 0 else {return false}
        
        
        return password == confirmation;
    }
    
    private func disableSignupButton()
    {
        self.signUpBtn.userInteractionEnabled = false;
        self.signUpBtn.alpha = 0.6;
    }
    
    private func enableSignupButton()
    {
        self.signUpBtn.userInteractionEnabled = true;
        self.signUpBtn.alpha = 1.0;
    }
    
    private func setSecureTextEntry(entry: Bool)
    {
        self.confirmPasswordTF.secureTextEntry = entry;
        self.passwordTF.secureTextEntry = entry;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesCancelled(touches, withEvent: event);
        self.endEditing(true);
    }
}
