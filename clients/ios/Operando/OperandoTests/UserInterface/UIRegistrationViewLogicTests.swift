//
//  UIRegistrationViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/3/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UIRegistrationViewLogicTests: XCTestCase {
    
    func test_OnInit_PreparesUIElements() {
        
        let outlets: UIRegistrationViewOutlets = .allDefault
        
        let logic: UIRegistrationViewLogic = UIRegistrationViewLogic(outlets: outlets)
        
        XCTAssert(outlets.showSecureEntrySwitch!.isOn)
        XCTAssert(outlets.invalidEmailLabel!.isHidden)
        XCTAssert(outlets.passwordsDontMatchLabel!.isHidden)
        XCTAssert(outlets.emailTF!.text?.isEmpty ?? true)
        XCTAssert(outlets.passswordTF?.text?.isEmpty ?? true)
        XCTAssert(outlets.confirmPasswordTF?.text?.isEmpty ?? true)
        XCTAssert(!(outlets.signUpButton?.isUserInteractionEnabled ?? false) )
        
    }
    
    func test_OnEmptyField_DisplaysMessageAlert() {
        
        // emtpy Email
        _OnEmptyField_DisplaysMessageAlert { outlets in
            outlets.emailTF?.text = ""
            outlets.passswordTF?.text = "1223"
        }
        
        _OnEmptyField_DisplaysMessageAlert { outlets in
            outlets.passswordTF?.text = ""
            outlets.emailTF?.text = ""
        }
        
    }
    
    func test_onShowPasswordsSwitchChange_UpdatesPasswordTextFields() {
        _onShowPasswordsSwitchChange(to: true)
        _onShowPasswordsSwitchChange(to: false)
    }
    
    private func _onShowPasswordsSwitchChange(to value: Bool) {
        let outlets: UIRegistrationViewOutlets = .allDefault
        let logic = UIRegistrationViewLogic(outlets: outlets)
        
        outlets.showSecureEntrySwitch?.isOn = value
        outlets.showSecureEntrySwitch?.sendActions(for: .editingChanged)
        
        XCTAssert(outlets.confirmPasswordTF!.isSecureTextEntry == !value)
        XCTAssert(outlets.passswordTF!.isSecureTextEntry == !value)
    }
    
    func test_OnEmptyEmailTextField_showsLabelDisablesSignUp() {
        let outlets: UIRegistrationViewOutlets = .allDefault
        let logic = UIRegistrationViewLogic(outlets: outlets)
        
        logic.textFieldDidEndEditing(outlets.emailTF!)
        
        XCTAssert(!outlets.invalidEmailLabel!.isHidden)
        XCTAssert(!outlets.signUpButton!.isUserInteractionEnabled)
    }
    
    func test_OnNonMatchingPasswords_showsLabelDisablesSignUp(){
        let outlets: UIRegistrationViewOutlets = .allDefault
        let logic = UIRegistrationViewLogic(outlets: outlets)
        
        outlets.confirmPasswordTF?.text = "asdf1"
        outlets.passswordTF?.text = "qowq"
        
        logic.textFieldDidEndEditing(outlets.confirmPasswordTF!)
        XCTAssert(!outlets.passwordsDontMatchLabel!.isHidden)
        XCTAssert(!outlets.signUpButton!.isUserInteractionEnabled)
    }
    
    func _OnEmptyField_DisplaysMessageAlert(outletsModifier: (_ outlets: UIRegistrationViewOutlets) -> Void) {
        
        let exp = self.expectation(description: "")
        let outlets: UIRegistrationViewOutlets = .allDefault
        
        let logic: UIRegistrationViewLogic = UIRegistrationViewLogic(outlets: outlets)
        
        outletsModifier(outlets)
        
        logic.setupWith(callbacks: UIRegistrationViewLogicCallbacks(presentOkAlert: { message in
            XCTAssert(message == Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey))
            exp.fulfill()
        }, registrationCallback: nil))
        
        outlets.signUpButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_onSignup_CallsWithCorrectRegistrationInfo(){
        callsWithCorrectRegistration(info: RegistrationInfo(email: "goodEmail1@email.com", password: "pass1"))
        
        callsWithCorrectRegistration(info: RegistrationInfo(email: "email2@email.com", password: "awfhh"))
    }
    
    private func callsWithCorrectRegistration(info: RegistrationInfo){
        let exp = self.expectation(description: "")
        
        let outlets: UIRegistrationViewOutlets = .allDefault
        let logic: UIRegistrationViewLogic = UIRegistrationViewLogic(outlets: outlets)
        
        outlets.emailTF?.text = info.email
        outlets.passswordTF?.text = info.password
        outlets.confirmPasswordTF?.text = info.password
        
        logic.setupWith(callbacks: UIRegistrationViewLogicCallbacks(presentOkAlert: nil, registrationCallback: { regInfo in
            XCTAssert(regInfo.email == info.email)
            XCTAssert(regInfo.password == info.password)
            exp.fulfill()
        }))
        
        outlets.signUpButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}
