//
//  UISignInViewControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/3/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UISignInViewControllerLogicTests: XCTestCase {
    
    func test_onCreateAccount_CallsCorrectCallback(){
        
        let exp = self.expectation(description: "")
        let outlets = UISignInViewControllerOutlets(loginViewLogic: nil, registerButton: UIButton())
        let logic = UISignInViewControllerLogic(outlets: outlets, callbacks: .allNil)
        
        logic.setupWithCallbacks(UISignInViewControllerCallbacks(whenUserWantsToLogin: nil, whenUserForgotPassword: nil, whenUserPressedRegister: {
            exp.fulfill()
        }))
        
        outlets.registerButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_onForgotPasswordAndInvalidEmail_CallsToPresentMessageAlert(){
        let exp = self.expectation(description: "")
        
        let (loginViewLogic, loginViewOutlets) = createLogicPopulated(with: LoginInfo(email: "", password: "", wishesToBeRemembered: true))
        
        let outlets = UISignInViewControllerOutlets(loginViewLogic: loginViewLogic, registerButton: nil)
        
        let logic = UISignInViewControllerLogic(outlets: outlets, callbacks: UISignInViewControllerLogicCallbacks(presentOkAlert: { message in
            
            XCTAssert(message == Bundle.localizedStringFor(key: kEmailIsNotValidLocalizableKey))
            exp.fulfill()
            
        }, presentForgotEmailInputAlert: { sendEmailString in
            sendEmailString?("badEmailasdf")
        }))
        
        logic.setupWithCallbacks(UISignInViewControllerCallbacks.allNil)
        loginViewOutlets.forgotPasswordButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    
    
    func test_onForgotPasswordValidEmail_CallsCorrectCallback() {
        
        let email = "goodEmail@gmail.com"
        let exp = self.expectation(description: "")
        
        let (loginViewLogic, loginViewOutlets) = createLogicPopulated(with: LoginInfo(email: "", password: "", wishesToBeRemembered: true))
        let outlets = UISignInViewControllerOutlets(loginViewLogic: loginViewLogic, registerButton: nil)
        
        let logic = UISignInViewControllerLogic(outlets: outlets, callbacks: UISignInViewControllerLogicCallbacks(presentOkAlert: nil, presentForgotEmailInputAlert: { $0?(email)}));
        
        logic.setupWithCallbacks(UISignInViewControllerCallbacks(whenUserWantsToLogin: nil, whenUserForgotPassword: {
            XCTAssert(email == $0)
            exp.fulfill()
        }, whenUserPressedRegister: nil))
        
        loginViewOutlets.forgotPasswordButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_OnLogin_CallsCorrectCallback() {
        let loginInfo: LoginInfo = LoginInfo(email: "email@email.com", password: "password", wishesToBeRemembered: true)
        
        let exp = self.expectation(description: "")
        let (loginViewLogic, loginViewOutlets) = createLogicPopulated(with: loginInfo)
        let outlets: UISignInViewControllerOutlets = UISignInViewControllerOutlets(loginViewLogic: loginViewLogic, registerButton: nil)
        
        let logic = UISignInViewControllerLogic(outlets: outlets, callbacks: .allNil)
        logic.setupWithCallbacks(UISignInViewControllerCallbacks(whenUserWantsToLogin: { info in
            XCTAssert(info.email == loginInfo.email)
            XCTAssert(info.password == loginInfo.password)
            XCTAssert(info.wishesToBeRemembered == loginInfo.wishesToBeRemembered)
            exp.fulfill()
        }, whenUserForgotPassword: nil, whenUserPressedRegister: nil))
        
        loginViewOutlets.signInButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
