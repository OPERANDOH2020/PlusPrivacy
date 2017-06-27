//
//  UIChangePasswordView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIChangePasswordViewCallbacks{
    let whenConfirmedToChange: ((_ currentPassword: String,
    _ newPassword: String) -> Void)?
    
    let whenCanceled: VoidBlock?
}


let kPasswordsMustMatchLocalizableKey = "kPasswordsMustMatchLocalizableKey"
let kPasswordTooShortLocalizableKey = "kPasswordTooShortLocalizableKey"
let kPasswordsAreTheSameLocalizableKey = "kPasswordsAreTheSameLocalizableKey"

let kMinimumPasswordChars = 5

class UIChangePasswordView: RSNibDesignableView, UITextFieldDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var cancelButtonBottomSpaceConstraint: NSLayoutConstraint!
    
    private var callbacks: UIChangePasswordViewCallbacks?
    private var editingTextField: UITextField?
    
    
    override func commonInit() {
        super.commonInit()
        self.confirmPasswordTF.delegate = self
        self.newPasswordTF.delegate = self
        self.currentPasswordTF.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIChangePasswordView.keyboardWillAppear(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIChangePasswordView.keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setupWith(callbacks: UIChangePasswordViewCallbacks?){
        self.callbacks = callbacks
    }
    
    func clearEverything(){
        self.currentPasswordTF.text = nil
        self.newPasswordTF.text = nil
        self.confirmPasswordTF.text = nil 
    }
    
    //MARK: Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var nextTF: UITextField?
        if textField == self.currentPasswordTF {
            nextTF = self.newPasswordTF
        } else if textField == self.newPasswordTF {
            nextTF = self.confirmPasswordTF
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { 
                textField.resignFirstResponder()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            nextTF?.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.editingTextField = textField
        return true
    }
    
    //Mark: IBActions
    
    
    @IBAction func didPressCancel(_ sender: AnyObject) {
        self.callbacks?.whenCanceled?()
    }
    
    @IBAction func didPressChange(_ sender: AnyObject) {
        
        if let errorMessage = self.errorMessageForValidatingPasswords() {
            OPViewUtils.displayAlertWithMessage(message: errorMessage, withTitle: "", addCancelAction: false, withConfirmation: nil)
            return
        }
        
        self.callbacks?.whenConfirmedToChange?(self.currentPasswordTF.text!, self.newPasswordTF.text!)
        
    }
    
    //MARK: Keyboard management
    
    func keyboardWillAppear(_ notification: NSNotification){
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let editingTF = self.editingTextField,
            editingTF != self.currentPasswordTF else{
            return
        }
        
        let rect = value.cgRectValue
        self.cancelButtonBottomSpaceConstraint.constant = rect.size.height + 55 
        UIView.animate(withDuration: 0.5) {
            self.scrollView.layoutIfNeeded()
            let offset = CGPoint(x: 0, y: editingTF.frame.origin.y)
            self.scrollView.setContentOffset(offset, animated: false)
        }

    }
    
    func keyboardWillDisappear(_ notification: NSNotification){
        self.cancelButtonBottomSpaceConstraint.constant = 55;
        UIView.animate(withDuration: 0.5, animations: { 
            self.scrollView.layoutIfNeeded()
            }, completion: nil)
    }
    
    //MARK: private utilities 
    
    private func errorMessageForValidatingPasswords() -> String? {
        guard let newPassword = self.newPasswordTF.text,
            let confirmation = self.confirmPasswordTF.text,
            let currentPassword = self.currentPasswordTF.text else {
             return Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey)
        }
        
        guard currentPassword.characters.count > 0 else {
            return Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey)
        }
        
        guard newPassword.characters.count >= kMinimumPasswordChars else {
            return Bundle.localizedStringFor(key: kPasswordTooShortLocalizableKey)
        }
        
        guard newPassword == confirmation else {
            return Bundle.localizedStringFor(key: kPasswordsMustMatchLocalizableKey)
        }
        
        guard newPassword != currentPassword else {
            return Bundle.localizedStringFor(key: kPasswordsAreTheSameLocalizableKey)
        }
        
        return nil
        
    }
    
}
