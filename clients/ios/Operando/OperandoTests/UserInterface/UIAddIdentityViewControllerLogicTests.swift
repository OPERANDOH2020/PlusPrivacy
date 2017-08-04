//
//  UIAddIdentityViewControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/4/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class DummyAddViewLogic: UIAddIdentityViewLogic {
    
    var onSetupWithDomains: ((_ domains: [Domain]) -> Void)?
    var onChangeAlias: ((_ alias: String) -> Void)?
    
    convenience init() {
        self.init(outlets: .allNil, logicCallbacks: UIAddIdentityViewLogicCallbacks.init(dismissKeyboard: nil, presentAlertWithMessage: nil))
    }
    
    override func setupWith(domains: [Domain], andCallbacks callbacks: UIAddIdentityViewCallbacks?) {
        onSetupWithDomains?(domains)
    }
    
    override func changeAlias(to newAlias: String) {
        onChangeAlias?(newAlias)
    }
}

class DummyIdentitiesRepository {
    
}

class UIAddIdentityViewControllerLogicTests: XCTestCase {
    
    func test_OnSetupWithRepository_FirstSetsDomains_ThenFillsWithGeneratedIdentity() {
        

        
        
    }
    
}
