//
//  UILoginViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/2/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando
class UILoginViewLogicTests: XCTestCase {
    
    
    func testLoginLogic_OnForgotPassword_CallsCorrectCallback(){
        let expectation = self.expectation(description: "")
        
        let forgotPasswordBtn = UIButton(frame: .zero)
        let logic = UILoginViewLogic(outlets: UILoginViewOutlets(emailTF: nil, passwordTF: nil, rememberMeSwitch: nil, signInButton: nil, forgotPasswordButton: forgotPasswordBtn))
        
        logic.setupWith(callbacks: UILoginViewCallbacks(whenUserWantsToLogin: nil, whenUserForgetsPassword: { 
            expectation.fulfill()
        }))
        
        forgotPasswordBtn.sendActions(for: .touchUpInside)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func testLoginLogic_OnSignIn_CallsWithCorrectValues() {
        LoginLogic_OnSignIn_CallsWithCorrectValues(from: LoginInfo(email: "asdftest1", password: "asdftestt1", wishesToBeRemembered: true))
        
        LoginLogic_OnSignIn_CallsWithCorrectValues(from: LoginInfo(email: "opoqaz", password: "xothssgh", wishesToBeRemembered: false))
    }
    
    private func LoginLogic_OnSignIn_CallsWithCorrectValues(from info: LoginInfo) {
        
        let exp = self.expectation(description: "")
        let outlets = UILoginViewOutlets(emailTF: UITextField(), passwordTF: UITextField(), rememberMeSwitch: UISwitch(), signInButton: UIButton(), forgotPasswordButton: nil)
        
        let logic = UILoginViewLogic(outlets: outlets)
        
        outlets.emailTF?.text = info.email
        outlets.passwordTF?.text = info.password
        outlets.rememberMeSwitch?.isOn = info.wishesToBeRemembered
        
        logic.setupWith(callbacks: UILoginViewCallbacks(whenUserWantsToLogin: { testInfo in
            
            XCTAssert(testInfo.email == info.email)
            XCTAssert(testInfo.password == info.password)
            XCTAssert(testInfo.wishesToBeRemembered == info.wishesToBeRemembered)
            
            exp.fulfill()
            
        }, whenUserForgetsPassword: nil))
        
        
        outlets.signInButton?.sendActions(for: .touchUpInside)
        
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
