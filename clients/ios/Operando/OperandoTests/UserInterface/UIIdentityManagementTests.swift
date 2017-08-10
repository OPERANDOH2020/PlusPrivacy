//
//  UIIdentityManagementTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class DummyRealIdentityView: UIRealIdentityView {
    
    var onSetupWithIdentityState: ((_ identity: String, _ state: UIRealIdentityViewDisplayState) -> Void)?
    var onChangeDisplayStateAnimated: ((_ state: UIRealIdentityViewDisplayState, _ animated: Bool) -> Void)?
    
    override func commonInit() {
        
    }
    
    override func setupWith(identity: String, state: UIRealIdentityViewDisplayState) {
        self.onSetupWithIdentityState?(identity, state)
    }
    
    override func changeDisplay(to state: UIRealIdentityViewDisplayState, animated: Bool) {
        self.onChangeDisplayStateAnimated?(state, animated)
    }
    
}


class DummyIdentitiesListViewLogic: UIIdentitiesListViewLogic {
    
    var onSetup: ((_ initialList: [String], _ defaultIndex: Int?, _ callbacks: UIIdentitiesListCallbacks?) -> Void)?
    
    var onDisplayAsDefault: ((_ identity: String) -> Void)?
    var onDelete: ((_ index: Int) -> Void)?
    var onAppendAndDisplay: ((_ item: String) -> Void)?
    
    override func setupWith(initialList: [String], defaultIdentityIndex: Int?, andCallbacks callbacks: UIIdentitiesListCallbacks?) {
        self.onSetup?(initialList, defaultIdentityIndex, callbacks)
    }
    
    override func displayAsDefault(identity: String) {
        self.onDisplayAsDefault?(identity)
    }
    
    override func deleteItemAt(index: Int) {
        self.onDelete?(index)
    }
    
    override func appendAndDisplayNew(item: String) {
        self.onAppendAndDisplay?(item)
    }
    
    init() {
        super.init(outlets: .init(tableView: nil))
    }
    
}

class UIIdentityManagementViewControllerLogicTests: XCTestCase {
    
    func test_OnSetup_RetrievsAndDisplaysRealIdentity() {
        _OnSetup_RetrievsAndDisplaysRealIdentity(realIdentity: "FirstRealIdentty")
        _OnSetup_RetrievsAndDisplaysRealIdentity(realIdentity: "TestRealIDentty")
    }
    
    func _OnSetup_RetrievsAndDisplaysRealIdentity(realIdentity: String) {
        let exp = self.expectation(description: "")
        let dummyRealView: DummyRealIdentityView = DummyRealIdentityView()
        dummyRealView.onSetupWithIdentityState = { identity, state in
            XCTAssert(realIdentity == identity)
            exp.fulfill()
        }
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: nil, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: nil, realIdentityView: dummyRealView)
        
        let logic: UIIdentityManagementViewControllerLogic  = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        let dummyRepository = DummySynchronousIdentitiesRepository()
        dummyRepository.realIdentity = realIdentity
        
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test_OnSetup_RetrievesAndDisplaysCurrentIdentitiesInList(){
        _OnSetup_RetrievesAndDisplaysCurrentIdentitiesInList(identities: ["first", "a", "bcde", "g"], defaultIdentityIndex: 1)
        
        _OnSetup_RetrievesAndDisplaysCurrentIdentitiesInList(identities: ["xxasdxf", "sdfgdf", "testAmother", "g"], defaultIdentityIndex: nil)
    }
    
    
    func _OnSetup_RetrievesAndDisplaysCurrentIdentitiesInList(identities: [String], defaultIdentityIndex: Int?){
        let exp = self.expectation(description: "")
        let dummyListLogic: DummyIdentitiesListViewLogic = DummyIdentitiesListViewLogic()
        dummyListLogic.onSetup = { identitiesSetup, index, _ in
            XCTAssert(identities == identitiesSetup)
            XCTAssert(defaultIdentityIndex == index)
            exp.fulfill()
        }
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: dummyListLogic, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: nil, realIdentityView: nil)
        
        let dummyRepository: DummySynchronousIdentitiesRepository = DummySynchronousIdentitiesRepository()
        let logic: UIIdentityManagementViewControllerLogic = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        dummyRepository.identitiesList = identities
        dummyRepository.indexOfDefaultIdentity = defaultIdentityIndex
        
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test__OnSetup_DisplaysNumberOfLeftIdentitiesToAdd_InLabel(){
        
        _OnSetup_DisplaysNumberOfLeftIdentitiesToAdd_InLabel(identities: Array<String>(repeating: "aString", count: Int(arc4random() % UInt32(20)) + 1))
        
        _OnSetup_DisplaysNumberOfLeftIdentitiesToAdd_InLabel(identities: Array<String>(repeating: "identity", count: Int(arc4random() % UInt32(20)) + 1))
        
        _OnSetup_DisplaysNumberOfLeftIdentitiesToAdd_InLabel(identities: Array<String>(repeating: "another", count: Int(arc4random() % UInt32(20)) + 1))
    }
    
    func _OnSetup_DisplaysNumberOfLeftIdentitiesToAdd_InLabel(identities: [String]){
   
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: nil, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: .init(), realIdentityView: nil)
        
        let dummyRepository: DummySynchronousIdentitiesRepository = DummySynchronousIdentitiesRepository()
        let logic: UIIdentityManagementViewControllerLogic = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        dummyRepository.identitiesList = identities
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        XCTAssert((outlets.numberOfIdentitiesLeftLabel!.text!.contains("\(kMaxNumOfIdentities - identities.count)")))

    }
    
    func test_OnDeleteIdentity_DisplaysConfirmationPanel(){
        _OnDeleteIdentity_DisplaysConfirmationPanel(identities: ["ident1", "ident2", "ident3"], indexToRemove: 0)
        
        _OnDeleteIdentity_DisplaysConfirmationPanel(identities: ["ident1", "ident2", "ident3"], indexToRemove: 1)
        
        _OnDeleteIdentity_DisplaysConfirmationPanel(identities: ["ident1", "ident2", "ident3"], indexToRemove: 2)
    }
    
    func _OnDeleteIdentity_DisplaysConfirmationPanel(identities: [String], indexToRemove: Int){
        let exp = self.expectation(description: "")
        let dummyListViewLogic = DummyIdentitiesListViewLogic()
        dummyListViewLogic.onSetup = { _, _, callbacks in
            callbacks?.whenPressedToDeleteItemAtIndex?(identities[indexToRemove], indexToRemove)
        }
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: dummyListViewLogic, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: nil, realIdentityView: nil)
        
        let logic: UIIdentityManagementViewControllerLogic = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: UIIdentityManagementViewControllerLogicCallbacks(displayStatusPopupWithMessage: nil, dismissStatusPopup: nil, displayConfirmationPanel: { (title, message, callback) in
            XCTAssert(title == identities[indexToRemove])
            exp.fulfill()
        }, displayError: nil))
        
        let dummyRepository = DummySynchronousIdentitiesRepository()
        dummyRepository.identitiesList = identities
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnConfirmDeleteIdentity_CallsRepositoryToDelete_DeletesFromListAndUpdatesLabel(){
        let identities: [String] = ["first", "second", "third", "fourth", "fiofth"]
        _OnConfirmDeleteIdentity_CallsRepositoryToDelete_DeletesFromListAndUpdatesLabel(identitie: identities, indexToRemove: 0, nextDefaultIdentity: "second")
        
        _OnConfirmDeleteIdentity_CallsRepositoryToDelete_DeletesFromListAndUpdatesLabel(identitie: identities, indexToRemove: 2, nextDefaultIdentity: "fourth")
        
        
        _OnConfirmDeleteIdentity_CallsRepositoryToDelete_DeletesFromListAndUpdatesLabel(identitie: identities, indexToRemove: 3, nextDefaultIdentity: "first")
    }
    
    func _OnConfirmDeleteIdentity_CallsRepositoryToDelete_DeletesFromListAndUpdatesLabel(identitie: [String], indexToRemove: Int, nextDefaultIdentity: String){
        
        let expDeletesFromList = self.expectation(description: "")
        let dummyListViewLogic = DummyIdentitiesListViewLogic()
        
        var didCallRepositoryToRemove: Bool = false
        var didDisplayConfirmationPanel: Bool = false
        dummyListViewLogic.onDelete = { index in
            XCTAssert(indexToRemove == index)
            XCTAssert(didCallRepositoryToRemove && didDisplayConfirmationPanel)
            expDeletesFromList.fulfill()
        }
        
        dummyListViewLogic.onSetup = { _, _, callbacks in
            callbacks?.whenPressedToDeleteItemAtIndex?(identitie[indexToRemove], indexToRemove)
        }
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: dummyListViewLogic, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: .init(), realIdentityView: nil)
        
        let logic: UIIdentityManagementViewControllerLogic = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: UIIdentityManagementViewControllerLogicCallbacks(displayStatusPopupWithMessage: nil, dismissStatusPopup: nil, displayConfirmationPanel: { (_, _, confirmation) in
            didDisplayConfirmationPanel = true
            confirmation?()
        }, displayError: nil))
        
        let dummyRepository = DummySynchronousIdentitiesRepository()
        dummyRepository.identitiesList = identitie;
        
        let expCallsRepository = self.expectation(description: "")
        dummyRepository.onRemove = { identity, completion in
            XCTAssert(identity == identitie[indexToRemove])
            didCallRepositoryToRemove = true
            completion?(nextDefaultIdentity, nil)
            expCallsRepository.fulfill()
        }
        
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssert(outlets.numberOfIdentitiesLeftLabel!.text!.contains("\(kMaxNumOfIdentities - identitie.count + 1)"))
    }
    
    func _OnAddIdentity_FetchesIdentity_CallsRepository_InsertsInListAndUpdatesLabel(identities: [String], newIdentity: String){
        var didCallRepository: Bool = false
        let expFetchesIdentity = self.expectation(description: "")
        
        let dummyViewLogic: DummyIdentitiesListViewLogic = DummyIdentitiesListViewLogic()
        let expInsertsInList = self.expectation(description: "")
        dummyViewLogic.onAppendAndDisplay = { identity in
            XCTAssert(didCallRepository)
            XCTAssert(newIdentity == identity)
            expInsertsInList.fulfill()
        }
        
        let outlets: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: dummyViewLogic, addNewIdentityButton: .init(), numberOfIdentitiesLeftLabel: .init(), realIdentityView: nil)
        
        let logic: UIIdentityManagementViewControllerLogic = UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: nil)
        
        let dummyRepository = DummySynchronousIdentitiesRepository()
        dummyRepository.identitiesList = identities
        dummyRepository.onAddIdentity = { identity in
            XCTAssert(identity == newIdentity)
            didCallRepository = true
            dummyRepository.errorForAddIdentity = nil
        }
        
        logic.setupWith(identitiesRepository: dummyRepository, callbacks: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
}
