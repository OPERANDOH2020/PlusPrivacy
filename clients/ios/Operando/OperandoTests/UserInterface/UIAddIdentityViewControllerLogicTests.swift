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
    
    var onSetupWithDomainsCallbacks: ((_ domains: [Domain], _ callbacks: UIAddIdentityViewCallbacks?) -> Void)?
    var onChangeAlias: ((_ alias: String) -> Void)?
    
    convenience init() {
        self.init(outlets: .allNil, logicCallbacks: UIAddIdentityViewLogicCallbacks.init(dismissKeyboard: nil, presentAlertWithMessage: nil))
    }
    
    override func setupWith(domains: [Domain], andCallbacks callbacks: UIAddIdentityViewCallbacks?) {
        onSetupWithDomainsCallbacks?(domains, callbacks)
    }
    
    override func changeAlias(to newAlias: String) {
        onChangeAlias?(newAlias)
    }
}



class UIAddIdentityViewControllerLogicTests: XCTestCase {
    
    
    func test_OnSetupWithRepository_FirstSetsDomains_ThenFillsWithGeneratedAlias() {
        
        _OnSetupWithRepository_FirstSetsDomains_ThenFillsWithGeneratedAlias(domains: [Domain(id: "1", name: "dom1")], alias: "testAlias1")
        
        _OnSetupWithRepository_FirstSetsDomains_ThenFillsWithGeneratedAlias(domains: [Domain(id: "2", name: "dom1"), Domain(id: "4", name: "domain4")], alias: "someOtherxzxAlias")
    }
    
    func _OnSetupWithRepository_FirstSetsDomains_ThenFillsWithGeneratedAlias(domains: [Domain], alias: String) {
        let dummyAddViewLogic: DummyAddViewLogic = DummyAddViewLogic()
        let controllerLogic: UIAddIdentityViewControllerLogic = UIAddIdentityViewControllerLogic(identityViewLogic: dummyAddViewLogic, logicCallbacks: UIAddIdentityViewControllerLogicCallbacks.allNil)
        

        let dummyIdentitiesRepository: DummyIdentitiesRepository = DummyIdentitiesRepository()
        dummyIdentitiesRepository.domainsList = domains
        dummyIdentitiesRepository.generatedNewIdentity = alias;
        
        let expFirstSetsDomains = self.expectation(description: "")
        let expFillsWithGeneratedIdentity = self.expectation(description: "")
        
        var fulfilledSetDomains: Bool = false
        var fulfilledGeneratedIdentity: Bool = false
        
        dummyAddViewLogic.onSetupWithDomainsCallbacks = { domainsReceived, _  in
            XCTAssert(domainsReceived == domains)
            
            XCTAssert(!fulfilledSetDomains)
            XCTAssert(!fulfilledGeneratedIdentity)
            
            expFirstSetsDomains.fulfill()
            fulfilledSetDomains = true
            
        }
        
        dummyAddViewLogic.onChangeAlias = { aliasReceived in
            XCTAssert(aliasReceived == alias)
            
            XCTAssert(fulfilledSetDomains)
            XCTAssert(!fulfilledGeneratedIdentity)
            expFillsWithGeneratedIdentity.fulfill()
            fulfilledGeneratedIdentity = true

        }
        
        controllerLogic.setupWith(identitiesRepository: dummyIdentitiesRepository, callbacks: nil)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_OnRefreshCallback_FillsWithGeneratedAlias() {
        _OnRefreshCallback_FillsWithGeneratedAlias(alias: "testFirstAlias")
        _OnRefreshCallback_FillsWithGeneratedAlias(alias: "asqwdsfds")
    }
    
    func _OnRefreshCallback_FillsWithGeneratedAlias(alias: String) {
        let dummyIdentitiesRepository: DummyIdentitiesRepository = DummyIdentitiesRepository()
        dummyIdentitiesRepository.generatedNewIdentity = alias
        
        let exp = self.expectation(description: "")
        let dummyAddViewLogic: DummyAddViewLogic = DummyAddViewLogic()
        
        var skippedFirstAliasChangeDueToNotBeingTriggeredByRefresh: Bool = false
        
        dummyAddViewLogic.onChangeAlias = { receivedAlias in
            XCTAssert(receivedAlias == alias)
            if !skippedFirstAliasChangeDueToNotBeingTriggeredByRefresh {
                skippedFirstAliasChangeDueToNotBeingTriggeredByRefresh = true
                return
            }
            
            exp.fulfill()
        }
        
        dummyAddViewLogic.onSetupWithDomainsCallbacks = { _, callbacks in
            callbacks?.whenPressedRefresh?()
        }
        
        let controllerLogic: UIAddIdentityViewControllerLogic = UIAddIdentityViewControllerLogic(identityViewLogic: dummyAddViewLogic, logicCallbacks: .allNil)
        
        controllerLogic.setupWith(identitiesRepository: dummyIdentitiesRepository, callbacks: nil)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnCloseFromAddImageView_ExistsWithNoIdentity() {
        let exp = self.expectation(description: "")
        
        let dummyAddIdentityViewLogic = DummyAddViewLogic()
        dummyAddIdentityViewLogic.onSetupWithDomainsCallbacks = { _, callbacks in
            DispatchQueue.main.async {
                callbacks?.whenPressedClose?()
            }
        }
        
        let controllerLogic: UIAddIdentityViewControllerLogic = UIAddIdentityViewControllerLogic(identityViewLogic: dummyAddIdentityViewLogic, logicCallbacks: .allNil)
        
        controllerLogic.setupWith(identitiesRepository: DummyIdentitiesRepository(), callbacks: UIAddIdentityViewControllerCallbacks(onExitWithIdentity: { identity in
            XCTAssertNil(identity)
            exp.fulfill()
        }))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnSave_AddIdentityWithNoError_ExitsCorrectly() {
        _OnSave_AddIdentityWithNoError_ExitsCorrectly(result: UIAddIdentityViewResult(email: "asdfxc", domain: Domain(id: "1", name: "dom1")))
        
        _OnSave_AddIdentityWithNoError_ExitsCorrectly(result: UIAddIdentityViewResult(email: "ziquigysx", domain: Domain(id: "8", name: "doman8")))
    }
    
    func _OnSave_AddIdentityWithNoError_ExitsCorrectly(result: UIAddIdentityViewResult) {
        let expAddIdentityIntoRepository = self.expectation(description: "")
        let expExitWithIdentity = self.expectation(description: "")
        
        let dummyAddViewLogic: DummyAddViewLogic = DummyAddViewLogic()
        dummyAddViewLogic.onSetupWithDomainsCallbacks = { _, callbacks in
            DispatchQueue.main.async {
                callbacks?.whenPressedSave?(result)
            }
        }
        
        let dummyIdentitiesRepository: DummyIdentitiesRepository = DummyIdentitiesRepository()
        dummyIdentitiesRepository.onAddIdentity = { identity in
            XCTAssert(identity == result.asFinalIdentity)
            expAddIdentityIntoRepository.fulfill()
        }
        
        let logic: UIAddIdentityViewControllerLogic = UIAddIdentityViewControllerLogic(identityViewLogic: dummyAddViewLogic, logicCallbacks: .allNil)
        
        logic.setupWith(identitiesRepository: dummyIdentitiesRepository, callbacks: UIAddIdentityViewControllerCallbacks(onExitWithIdentity: { identity in
            XCTAssert(identity == result.asFinalIdentity)
            expExitWithIdentity.fulfill()
        }))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnSave_AddIdentityWithError_PrintsErrorAlert() {
        let exp = self.expectation(description: "")
        
        let dummyRepository: DummyIdentitiesRepository = DummyIdentitiesRepository()
        dummyRepository.errorForAddIdentity = OPErrorContainer.errorInvalidServerResponse
        
        let dummyAddViewLogic: DummyAddViewLogic = DummyAddViewLogic()
        dummyAddViewLogic.onSetupWithDomainsCallbacks = { _, callbacks in
            callbacks?.whenPressedSave?(UIAddIdentityViewResult(email: "", domain: Domain(id: "", name: "")))
        }
        
        let controllerLogic = UIAddIdentityViewControllerLogic(identityViewLogic: dummyAddViewLogic, logicCallbacks: .init(displayStatusPopupWithMessage: nil, displayAlertWithMessage: nil, dismissStatusPopup: nil, presentError: { error in
            XCTAssert(error == dummyRepository.errorForAddIdentity!)
            exp.fulfill()
        }))
        
        controllerLogic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
