//
//  UIAccountViewControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class DummyChangePasswordViewLogic: UIChangePasswordViewLogic {
    
    var onSetupWithCallbacks: ((_ callbacks: UIChangePasswordViewCallbacks?) -> Void)?
    init() {
        super.init(outlets: .allDefault, logicCallbacks: nil)
    }
    
    override func setupWith(callbacks: UIChangePasswordViewCallbacks?) {
        self.onSetupWithCallbacks?(callbacks)
    }
}

class UIAccountViewControllerLogicTests: XCTestCase {
    
    func test_OnSignoutPress_CallsSignoutButton(){
        let outlets: UIAccountViewControllerOutlets = UIAccountViewControllerOutlets(signOutButton: .init(), changePasswordViewLogic: nil)
        let logic = UIAccountViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        let exp = self.expectation(description: "")
        logic.setupWith(callbacks: UIAccountViewControllerCallbacks(whenUserChoosesToLogout: {
            exp.fulfill()
        }, whenUserChangesPassword: nil));
        
        outlets.signOutButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnChangePasswordFromPasswordViewLogic_CallsChangePasswordCallback(){
        _OnChangePasswordFromPasswordViewLogic_CallsChangePasswordCallback(oldPassword: "someOldPassword", newPassword: "someNewPassword")
        
        _OnChangePasswordFromPasswordViewLogic_CallsChangePasswordCallback(oldPassword: "blablaOld", newPassword: "blaBlaNew")
    }
    
    func _OnChangePasswordFromPasswordViewLogic_CallsChangePasswordCallback(oldPassword: String, newPassword: String) {
        let dummyChangePasswordViewLogic = DummyChangePasswordViewLogic()
        dummyChangePasswordViewLogic.onSetupWithCallbacks = { cb in
            cb?.whenConfirmedToChange?(oldPassword, newPassword)
        }
        
        let exp = self.expectation(description: "")
        
        let outlets: UIAccountViewControllerOutlets = UIAccountViewControllerOutlets(signOutButton: nil, changePasswordViewLogic: dummyChangePasswordViewLogic)
        let logic = UIAccountViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        logic.setupWith(callbacks: UIAccountViewControllerCallbacks(whenUserChoosesToLogout: nil, whenUserChangesPassword: { (recOld, recNew, completion) in
            XCTAssert(recOld == oldPassword)
            XCTAssert(recNew == newPassword)
            exp.fulfill()
        }))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
