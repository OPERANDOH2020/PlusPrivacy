//
//  UIRegistrationView.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct RegistrationInfo {
    let email: String
    let password: String
}

typealias RegistrationCallback = (_ registrationInfo: RegistrationInfo) -> Void


struct UIRegistrationViewOutlets {
    let passswordTF: UITextField?
    let confirmPasswordTF: UITextField?
    let emailTF: UITextField?
    
    let signUpButton: UIButton?
    let scrollView: UIScrollView?
    
    let passwordsDontMatchLabel: UILabel?
    let invalidEmailLabel: UILabel?
    
    let showSecureEntrySwitch: UISwitch?
    
    static let allNil: UIRegistrationViewOutlets = UIRegistrationViewOutlets(passswordTF: nil, confirmPasswordTF: nil, emailTF: nil, signUpButton: nil, scrollView: nil, passwordsDontMatchLabel: nil, invalidEmailLabel: nil, showSecureEntrySwitch: nil)
    
    static let allDefault: UIRegistrationViewOutlets = UIRegistrationViewOutlets(passswordTF: .init(), confirmPasswordTF: .init(), emailTF: .init(), signUpButton: .init(), scrollView: .init(), passwordsDontMatchLabel: .init(), invalidEmailLabel: .init(), showSecureEntrySwitch: .init())
}


struct UIRegistrationViewLogicCallbacks {
    let presentOkAlert: CallbackWithString?
    let registrationCallback: RegistrationCallback?
}

class UIRegistrationViewLogic: NSObject, UITextFieldDelegate {
    
    let outlets: UIRegistrationViewOutlets
    var callbacks: UIRegistrationViewLogicCallbacks?
    
    let normalScrollViewInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
    
    
    init(outlets: UIRegistrationViewOutlets){
        self.outlets = outlets;
        super.init()
        self.commonInit()
    }
    
    func commonInit() {
        
        outlets.invalidEmailLabel?.isHidden = true;
        outlets.passwordsDontMatchLabel?.isHidden = true;
        
        outlets.emailTF?.delegate = self;
        outlets.confirmPasswordTF?.delegate = self;
        outlets.passswordTF?.delegate = self
        
        outlets.emailTF?.text = ""
        outlets.passswordTF?.text = ""
        outlets.confirmPasswordTF?.text = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        self.disableSignupButton();
        outlets.scrollView?.contentInset = normalScrollViewInsets
        
        
        outlets.emailTF?.addTarget(outlets.passswordTF, action: #selector(UITextField.becomeFirstResponder), for: .editingDidEndOnExit)
        
        outlets.passswordTF?.addTarget(outlets.confirmPasswordTF, action: #selector(UITextField.becomeFirstResponder), for: .editingDidEndOnExit)
        
        outlets.signUpButton?.addTarget(self, action: #selector(didPressSignUp(_:)), for: .touchUpInside)
        outlets.showSecureEntrySwitch?.addTarget(self, action: #selector(didSwitchShowPasswordsOnOrOff(_:)), for: .editingChanged)
        
        outlets.showSecureEntrySwitch?.isOn = true 
    }
    
    
    func setupWith(callbacks: UIRegistrationViewLogicCallbacks?){
        self.callbacks = callbacks
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self);
    }
    
    
    //MARK: Keyboard
    
    func keyboardWillAppear(notification: NSNotification){
        outlets.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0);
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        outlets.scrollView?.contentInset = normalScrollViewInsets
    }
    
    @IBAction func didPressSignUp(_ sender: AnyObject){
        if let registrationInfo = self.createRegistrationInfo() {
            callbacks?.registrationCallback?(registrationInfo)
        }
    }
    
    @IBAction func didSwitchShowPasswordsOnOrOff(_ sender: UISwitch){
        self.setSecureTextEntry(entry: !sender.isOn);
    }
    
    
    //MARK: textfield delegate
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if let emailTF = outlets.emailTF, emailTF == textField {
            self.handleEmailDidEndEditing();
        }
        
        if let confirmTF = outlets.confirmPasswordTF, confirmTF == textField {
            self.handleConfirmationTFDidEndEditing();
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let confirmTF = outlets.confirmPasswordTF, textField == confirmTF {
            textField.resignFirstResponder()
        }
        return true;
    }
    
    
    //MARK: internal utils
    
    private func createRegistrationInfo() -> RegistrationInfo? {
        guard
            let email = outlets.emailTF?.text,
            let password = outlets.passswordTF?.text,
            !(email.isEmpty || password.isEmpty) else {
                self.callbacks?.presentOkAlert?(Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey))
                return nil
        }
        
        
        return RegistrationInfo(email: email, password: password)
    }
    
    private func handleEmailDidEndEditing(){
        if self.isEmailValid() == false{
            outlets.invalidEmailLabel?.isHidden = false;
        }
        else {
            outlets.invalidEmailLabel?.isHidden = true;
            
            if self.doPasswordsMatch(){
                self.enableSignupButton();
            }
            else{
                self.disableSignupButton();
            }
        }
    }
    
    private func handleConfirmationTFDidEndEditing(){
        if self.doPasswordsMatch() == false{
            outlets.passwordsDontMatchLabel?.isHidden = false;
            self.disableSignupButton();
        }
        else{
            outlets.passwordsDontMatchLabel?.isHidden = true;
            if self.isEmailValid(){
                self.enableSignupButton();
            }
            else{
                self.disableSignupButton()
            }
        }
    }
    
    private func isEmailValid() -> Bool{
        guard let email = outlets.emailTF?.text else {return false}
        return OPUtils.isValidEmail(email: email);
    }
    
    private func doPasswordsMatch() -> Bool{
        guard let password = outlets.passswordTF?.text else {return false}
        guard let confirmation = outlets.confirmPasswordTF?.text else {return false}
        guard password.characters.count > 0 else {return false}
        
        
        return password == confirmation;
    }
    
    private func disableSignupButton(){
        outlets.signUpButton?.isUserInteractionEnabled = false;
        outlets.signUpButton?.alpha = 0.6;
    }
    
    private func enableSignupButton(){
        outlets.signUpButton?.isUserInteractionEnabled = true;
        outlets.signUpButton?.alpha = 1.0;
    }
    
    private func setSecureTextEntry(entry: Bool){
        outlets.confirmPasswordTF?.isSecureTextEntry = entry;
        outlets.passswordTF?.isSecureTextEntry = entry;
    }
}


class UIRegistrationView: RSNibDesignableView, UITextFieldDelegate
{
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
 
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var passwordsDontMatchLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var showPasswordSwitch: UISwitch?
    
    lazy var logic: UIRegistrationViewLogic = {
        let outlets: UIRegistrationViewOutlets = UIRegistrationViewOutlets(passswordTF: self.passwordTF, confirmPasswordTF: self.confirmPasswordTF, emailTF: self.emailTF, signUpButton: self.signUpBtn, scrollView: self.scrollView, passwordsDontMatchLabel: self.passwordsDontMatchLabel, invalidEmailLabel: self.invalidEmailLabel, showSecureEntrySwitch: self.showPasswordSwitch)
        
        let logic: UIRegistrationViewLogic = UIRegistrationViewLogic(outlets: outlets)
        return logic
        
    }()
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    
}
