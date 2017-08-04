//
//  UIAddIdentityViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/4/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UIAddIdentityViewLogicTests: XCTestCase {
    
    func _ChangeAlias_SetsTFTextCorrectly(alias: String) {
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic: UIAddIdentityViewLogic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        

        logic.changeAlias(to: alias)
        XCTAssert(outlets.aliasTF!.text! == alias)
    }
    
    
    
    func test_OnPressClose_CallsCorrectCallback() {
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        
        let exp = self.expectation(description: "")
        logic.setupWith(domains: [], andCallbacks: UIAddIdentityViewCallbacks(whenPressedClose: {
            exp.fulfill()
        }, whenPressedSave: nil, whenPressedRefresh: nil));
        
        outlets.closeButtons?.first?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnPressRefresh_CallsCorrectCallback() {
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        
        let exp = self.expectation(description: "")
        logic.setupWith(domains: [], andCallbacks: UIAddIdentityViewCallbacks(whenPressedClose: {
            
        }, whenPressedSave: nil, whenPressedRefresh: {
            exp.fulfill()
        }));
        
        outlets.refreshBtn?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_OnSelectDomain_FilledAliasTF_Save_BuildsResultCorrectly() {
        _OnSelectDomain_FilledAliasTF_Save_BuildsResultCorrectly(alias: "azsdf", domains: [Domain(id: "1", name: "domm1")], domainIndex: 0)
        
        _OnSelectDomain_FilledAliasTF_Save_BuildsResultCorrectly(alias: "qwvzx",
                                                                 domains: [Domain(id: "1", name: "2"),
                                                                          Domain(id: "3", name: "four"),
                                                                          Domain(id: "4", name: "sadf")
                                                                                           ], domainIndex: 1)
        
        _OnSelectDomain_FilledAliasTF_Save_BuildsResultCorrectly(alias: "qwvzx",
                                                                 domains: [Domain(id: "1", name: "asd"),
                                                                           Domain(id: "3", name: "fiv"),
                                                                           Domain(id: "4", name: "sf")
            ], domainIndex: 2)
    }
    
    func _OnSelectDomain_FilledAliasTF_Save_BuildsResultCorrectly(alias: String, domains: [Domain], domainIndex: Int) {
        let exp = self.expectation(description: "")
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic: UIAddIdentityViewLogic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        
        logic.setupWith(domains: domains, andCallbacks: UIAddIdentityViewCallbacks(whenPressedClose: nil, whenPressedSave: { result in
            XCTAssert(result.domain.id == domains[domainIndex].id)
            XCTAssert(result.domain.name == domains[domainIndex].name)
            XCTAssert(result.email == alias)
            exp.fulfill()
        }, whenPressedRefresh: nil))
        
        outlets.aliasTF?.text = alias
        
        logic.textFieldDidBeginEditing(outlets.domainTF!)
        logic.tableView(outlets.domainsTableView!, didSelectRowAt: IndexPath(row: domainIndex, section: 0))
        outlets.saveBtn?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_OnFilledAliasTFNoDomainSelected_PresentsIncompleteFieldsError() {
        let exp = self.expectation(description: "")
        
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic: UIAddIdentityViewLogic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .init(dismissKeyboard: nil, presentAlertWithMessage: { message in
            XCTAssert(message == Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey))
            exp.fulfill()
        }))
        
        
        logic.setupWith(domains: [], andCallbacks: UIAddIdentityViewCallbacks(whenPressedClose: nil, whenPressedSave: nil , whenPressedRefresh: nil))
        
        outlets.aliasTF?.text = "someAliasasadsf";
        outlets.saveBtn?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_ChangeAlias_SetsTFTextCorrectly() {
        _ChangeAlias_SetsTFTextCorrectly(alias: "alias1")
        _ChangeAlias_SetsTFTextCorrectly(alias: "asdffq")
        _ChangeAlias_SetsTFTextCorrectly(alias: "randomString")
    }
    
    
    func test_OnSetupWithOnlyOneDomain_DomainTFIsPrefilled(){
        _OnSetupWithOnlyOneDomain_DomainTFIsPrefilled(domain: Domain(id: "1", name: "nameOne"))
        _OnSetupWithOnlyOneDomain_DomainTFIsPrefilled(domain: Domain(id: "2", name: "wadsfgdfg"))
    }
    
    func _OnSetupWithOnlyOneDomain_DomainTFIsPrefilled(domain: Domain) {
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic: UIAddIdentityViewLogic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        
        logic.setupWith(domains: [domain], andCallbacks: nil)
        
        XCTAssert(outlets.domainTF!.text! == domain.name)
    }
    
    func test_OnBeginEditingDomainTF_emptyOrMoreThanOneDomains_ListOfDomainsIsShown() {
        _OnBeginEditingDomainTF_TableViewIsShown(domains: [])
        _OnBeginEditingDomainTF_TableViewIsShown(domains: [Domain(id: "1", name: "nameOne"),
                                                           Domain(id: "2", name: "nameOne")])
    }
    
    func _OnBeginEditingDomainTF_TableViewIsShown(domains: [Domain]) {
        let outlets: UIAddIdentityViewOutlets = .allDefault
        let logic: UIAddIdentityViewLogic = UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: .allNil)
        
        logic.setupWith(domains: domains, andCallbacks: nil)
        
        logic.textFieldDidBeginEditing(outlets.domainTF!)
        XCTAssert(outlets.domainsTableView!.isHidden == false)
    }
    
}
