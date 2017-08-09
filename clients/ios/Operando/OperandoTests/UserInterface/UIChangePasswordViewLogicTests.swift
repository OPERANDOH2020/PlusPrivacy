//
//  UIChangePasswordViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UIChangePasswordViewLogicTests: XCTestCase {
    
    func test_OnSetup_AllFieldsAreCleared() {
        let outlets: UIChangePasswordViewOutlets = .allDefault
        let logic: UIChangePasswordViewLogic = UIChangePasswordViewLogic(outlets: outlets, logicCallbacks: nil)
        
        logic.setupWith(callbacks: nil)
        
        XCTAssert((outlets.currentPasswordTF?.text?.characters.count ?? 0) == 0)
        XCTAssert((outlets.confirmPasswordTF?.text?.characters.count ?? 0) == 0)
        XCTAssert((outlets.newPasswordTF?.text?.characters.count ?? 0) == 0)
    }
    
    func test_OnCancelPress_CallsCancelCallback(){
        let outlets: UIChangePasswordViewOutlets = .allDefault
        let logic: UIChangePasswordViewLogic = UIChangePasswordViewLogic(outlets: outlets, logicCallbacks: nil)
        
        let exp = self.expectation(description: "")
        
        logic.setupWith(callbacks: UIChangePasswordViewCallbacks(whenConfirmedToChange: nil, whenCanceled: {
            exp.fulfill()
        }))
        
        outlets.cancelButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    
    func test_OnChange_IncompleteFields_ShowsAlertWithMessage(){
        let message = Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey)
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { outlets in
            outlets.currentPasswordTF?.text = "some"
            outlets.newPasswordTF?.text = "password"
        }
        
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { outlets in
            outlets.confirmPasswordTF?.text = "asd"
            outlets.newPasswordTF?.text = "dfs"
        }
        
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { outlets in
            outlets.currentPasswordTF?.text = "another"
            outlets.confirmPasswordTF?.text = "another"
        }
    }
    
    func test_OnChange_NewPasswordLessThan5Chars_ShowsAlertWithMessage(){
        let message = Bundle.localizedStringFor(key: kPasswordTooShortLocalizableKey)
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { (outlets) in
            outlets.currentPasswordTF?.text = "currentPassword"
            outlets.confirmPasswordTF?.text = "currentPassword"
            outlets.newPasswordTF?.text = "ac12"
        }
        
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { (outlets) in
            outlets.currentPasswordTF?.text = "currentPassword2"
            outlets.confirmPasswordTF?.text = "currentPassword2"
            outlets.newPasswordTF?.text = "bxz"
        }
        
    }
    
    func test_OnChange_PasswordsNotMatching_ShowsAlertWithMessage() {
        let message = Bundle.localizedStringFor(key: kPasswordsMustMatchLocalizableKey)
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { (outlets) in
            outlets.newPasswordTF?.text = "newPassword"
            outlets.currentPasswordTF?.text = "abc123"
            outlets.confirmPasswordTF?.text = "zasqsf"
        }
        
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { (outlets) in
            outlets.newPasswordTF?.text = "newPassword"
            outlets.currentPasswordTF?.text = "absd23"
            outlets.confirmPasswordTF?.text = "zaasf"
        }
        
        _OnChange_AndAlteredFields_AssertAlertMessage(message: message) { (outlets) in
            outlets.newPasswordTF?.text = "newPassword"
            outlets.currentPasswordTF?.text = "retxed"
            outlets.confirmPasswordTF?.text = "LLSaGFG"
        }
    }
    
    func test_OnChange_AndEverythingOk_CallsCallbackWithPasswords(){
        _OnChange_AndEverythingOk_CallsCallbackWithPasswords(currentPassword: "currentPass1", newPassword: "newPassword1")
        
        _OnChange_AndEverythingOk_CallsCallbackWithPasswords(currentPassword: "currPass2", newPassword: "newPass2")
        
        _OnChange_AndEverythingOk_CallsCallbackWithPasswords(currentPassword: "aPassword", newPassword: "aNewPassword")
    }
    
    func _OnChange_AndEverythingOk_CallsCallbackWithPasswords(currentPassword: String,
                                                                  newPassword: String){
        
        let outlets: UIChangePasswordViewOutlets = .allDefault
        let logic: UIChangePasswordViewLogic = UIChangePasswordViewLogic(outlets: outlets, logicCallbacks: nil)
        
        let exp = self.expectation(description: "")
        logic.setupWith(callbacks: UIChangePasswordViewCallbacks(whenConfirmedToChange: { (oldPass, newPass) in
            XCTAssert(oldPass == currentPassword)
            XCTAssert(newPass == newPassword)
            exp.fulfill()
        }, whenCanceled: nil))
        
        outlets.currentPasswordTF?.text = currentPassword;
        outlets.confirmPasswordTF?.text = newPassword;
        outlets.newPasswordTF?.text = newPassword;
        
        outlets.changePasswordButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func _OnChange_AndAlteredFields_AssertAlertMessage(message: String, action: (UIChangePasswordViewOutlets) -> Void){
        
        let exp = self.expectation(description: "")
        let outlets: UIChangePasswordViewOutlets = .allDefault
        let logic: UIChangePasswordViewLogic = UIChangePasswordViewLogic(outlets: outlets, logicCallbacks: UIChangePasswordViewLogicCallbacks(displayAlertMessage: { alertMessage in
            XCTAssert(alertMessage == message)
            exp.fulfill()
        }))
        
        logic.setupWith(callbacks: nil)
        action(outlets)
        outlets.changePasswordButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
}
