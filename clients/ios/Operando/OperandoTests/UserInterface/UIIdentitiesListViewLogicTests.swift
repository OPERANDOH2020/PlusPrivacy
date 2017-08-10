//
//  UIIdentitiesListViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando


class DummyIdentityCell: UIIdentityCell {
    
    var onSetupWithIdentityAndStyle: ((_ identity: String?, _ style: UIIdentityCellStyle) -> Void)?
    
    override func setupWithIdentity(identity: String?, style: UIIdentityCellStyle) {
        self.onSetupWithIdentityAndStyle?(identity, style)
    }
}

class DummyIdentitiesTableView: UITableView {
    var returnedIndexPath: IndexPath?
    var returnedCell: DummyIdentityCell?
    
    var onInsertRows: ((_ indexes: [IndexPath]) -> Void)?
    var onRemoveRows: ((_ rows: [IndexPath]) -> Void)?
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return self.returnedCell
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return self.returnedCell ?? DummyIdentityCell()
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        self.onInsertRows?(indexPaths)
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        self.onRemoveRows?(indexPaths)
    }
    
    override func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return self.returnedIndexPath
    }
}

class UIIdentitiesListViewLogicTests: XCTestCase {
    
    func test_OnSetup_SwapsDefaultIdentityWithFirst(){
        _OnSetup_SwapsDefaultIdentityWithFirst(identitiesList: ["one", "two", "three"], index: Int(arc4random() % UInt32(3)))
        _OnSetup_SwapsDefaultIdentityWithFirst(identitiesList: ["alpha", "beta", "gamma", "delta"], index: Int(arc4random() % UInt32(4)))
    }
    
    func _OnSetup_SwapsDefaultIdentityWithFirst(identitiesList: [String], index: Int) {
        
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        tableView.returnedCell = DummyIdentityCell()
        tableView.returnedCell?.onSetupWithIdentityAndStyle = { identity, style in
            XCTAssert(identity! == identitiesList[index])
            XCTAssert(style.displaysDefaultIdentityIcon)
            exp.fulfill()
        }
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: index, andCallbacks: nil)
        let _ = logic.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test_OnAppend_DisplaysNewItemAsLast(){
        _OnAppend_DisplaysNewItemAsLast(identitiesList: ["a", "b"], newItem: "c")
        _OnAppend_DisplaysNewItemAsLast(identitiesList: ["firstItem", "second", "fourth"], newItem: "third")
    }
    
    func _OnAppend_DisplaysNewItemAsLast(identitiesList: [String], newItem: String){
        
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let expInsertsNewRow = self.expectation(description: "")
        tableView.onInsertRows = { rows in
            XCTAssert(rows.first!.row == identitiesList.count)
            expInsertsNewRow.fulfill()
        }
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: nil, andCallbacks: nil)
        logic.appendAndDisplayNew(item: newItem)
        
        let expCellSetWithCorrectIdentity = self.expectation(description: "")
        tableView.returnedCell = DummyIdentityCell()
        tableView.returnedCell?.onSetupWithIdentityAndStyle = { identity, style in
            XCTAssert(identity! == newItem)
            XCTAssert(!style.displaysDefaultIdentityIcon)
            expCellSetWithCorrectIdentity.fulfill()
        }
        
        let _ = logic.tableView(tableView, cellForRowAt: IndexPath(row: identitiesList.count, section: 0))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test_OnRemoveItemAtIndex_UpdatesTableView(){
        _OnRemoveItemAtIndex_UpdatesTableView(identitiesList: ["a", "b", "c"], indexToRemove: 0)
        _OnRemoveItemAtIndex_UpdatesTableView(identitiesList: ["a", "b", "c"], indexToRemove: 1)
        _OnRemoveItemAtIndex_UpdatesTableView(identitiesList: ["a", "b", "c"], indexToRemove: 2)
    }
    
    func _OnRemoveItemAtIndex_UpdatesTableView(identitiesList: [String], indexToRemove: Int){
        
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let expRemovesRow = self.expectation(description: "")
        tableView.onRemoveRows = { rows in
            XCTAssert(rows.first!.row == indexToRemove)
            expRemovesRow.fulfill()
        }
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: nil, andCallbacks: nil)
        logic.deleteItemAt(index: indexToRemove)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
    func test_OnDisplayItemAsDefault_CellAppearsSelected(){
        _OnDisplayItemAsDefault_CellAppearsSelected(identitiesList: ["alpha", "to", "beta"], identity: "to")
        _OnDisplayItemAsDefault_CellAppearsSelected(identitiesList: ["to", "be", "or"], identity: "be")
        _OnDisplayItemAsDefault_CellAppearsSelected(identitiesList: ["not", "to", "bee"], identity: "not")
    }
    
    func _OnDisplayItemAsDefault_CellAppearsSelected(identitiesList: [String], identity: String){
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: nil, andCallbacks: nil)
        logic.displayAsDefault(identity: identity)
        
        let expCellSetWithCorrectIdentity = self.expectation(description: "")
        tableView.returnedCell = DummyIdentityCell()
        tableView.returnedCell?.onSetupWithIdentityAndStyle = { identity, style in
            XCTAssert(identity! == identity)
            XCTAssert(style.displaysDefaultIdentityIcon)
            expCellSetWithCorrectIdentity.fulfill()
        }
        
        let index = identitiesList.index(of: identity)!
        let _ = logic.tableView(tableView, cellForRowAt: IndexPath(row: index, section: 0))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnDeleteFromSwipe_NormalIdentity_CallsDeleteCallback(){
        let identities: [String] = ["ident1", "identity2", "ident4", "i5", "i6"]
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: nil, changeDefaultTo: nil, indexToDelete: Int(arc4random() % UInt32(identities.count)), swipeButtonIndex: 1)
        
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: nil, changeDefaultTo: nil, indexToDelete: Int(arc4random() % UInt32(identities.count)), swipeButtonIndex: 1)
        
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: nil, changeDefaultTo: nil, indexToDelete: Int(arc4random() % UInt32(identities.count)), swipeButtonIndex: 1)
        
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: nil, changeDefaultTo: nil, indexToDelete: Int(arc4random() % UInt32(identities.count)), swipeButtonIndex: 1)
    }
    
    
    func test_OnDeleteFromSwipe_DefaultIdentity_CallsDeleteCallback(){
        let identities: [String] = ["ident1", "identity2", "ident4", "i5", "i6"]
        
        let idx1 = Int(arc4random() % UInt32(identities.count))
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: Int(arc4random() % UInt32(identities.count)), changeDefaultTo: idx1, indexToDelete: idx1, swipeButtonIndex: 0)
        
        let idx2 = Int(arc4random() % UInt32(identities.count))
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: Int(arc4random() % UInt32(identities.count)),
            changeDefaultTo: idx2,
            indexToDelete: idx2, swipeButtonIndex: 0)
        
        
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: 0, changeDefaultTo: nil, indexToDelete: 0, swipeButtonIndex: 0)
        
        _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: identities, defaultIdentityIndex: 0, changeDefaultTo: nil, indexToDelete: 0, swipeButtonIndex: 0)
    }
    
    func _OnDeleteFromSwipe_CallsDeleteCallback(identitiesList: [String], defaultIdentityIndex: Int?, changeDefaultTo toNewDefault: Int?, indexToDelete: Int, swipeButtonIndex: Int){
        
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        
        
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: defaultIdentityIndex, andCallbacks: UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { (identity, index) in
            XCTAssert(index == indexToDelete)
            exp.fulfill()
            
        }, whenActivatedItem: nil))
        
        if let toNew = toNewDefault{
            logic.displayAsDefault(identity: logic.identitiesList[toNew])
        }
        
        tableView.returnedIndexPath = IndexPath(row: indexToDelete, section: 0)
        let cell: DummyIdentityCell = DummyIdentityCell()
        tableView.returnedCell = cell
        
        let buttons = logic.swipeTableCell(cell, swipeButtonsFor: .rightToLeft, swipeSettings: MGSwipeSettings(), expansionSettings: MGSwipeExpansionSettings())
        
        
        (buttons![swipeButtonIndex] as? MGSwipeButton)?.callback(cell)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(){
        _ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(identitiesList: ["ident1", "ident2", "ident3"], defaultIdentityIndex: 2, changeDefaultTo: nil)
        
        _ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(identitiesList: ["ident1", "ident2", "ident3"], defaultIdentityIndex: 0, changeDefaultTo: 1)
        
        _ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(identitiesList: ["ident1", "ident2", "ident3"], defaultIdentityIndex: 1, changeDefaultTo: 0)
        
        _ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(identitiesList: ["ident1", "ident2", "ident3"], defaultIdentityIndex: 0, changeDefaultTo: nil)
    }
    
    func _ForCurrentIdentityCell_OnlyDeleteButtonAppearsOnSwipe(identitiesList: [String], defaultIdentityIndex: Int, changeDefaultTo toNewDefault: Int?){
        
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        
        
        
        logic.setupWith(initialList: identitiesList, defaultIdentityIndex: defaultIdentityIndex, andCallbacks: UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { _, _ in
            exp.fulfill()
        }, whenActivatedItem: nil))
        
        if let toNew = toNewDefault{
            logic.displayAsDefault(identity: logic.identitiesList[toNew])
        }
        
        tableView.returnedIndexPath = IndexPath(row: (toNewDefault ?? 0), section: 0)
        let cell: DummyIdentityCell = DummyIdentityCell()
        tableView.returnedCell = cell
        
        let buttons = logic.swipeTableCell(cell, swipeButtonsFor: .rightToLeft, swipeSettings: MGSwipeSettings(), expansionSettings: MGSwipeExpansionSettings())
        
        
        (buttons![0] as? MGSwipeButton)?.callback(cell)
        self.waitForExpectations(timeout: 5.0, handler: nil)

        
    }
    func test_OnDefaultFromSwipe_CallsActivateCallback(){
        let identities: [String] = ["ident1", "ident2", "more", "tests", "need", "more"]
        
        _OnDefaultFromSwipe_CallsActivateCallback(identities: identities, indexToActivate: Int(arc4random() % UInt32(identities.count)))
        
        _OnDefaultFromSwipe_CallsActivateCallback(identities: identities, indexToActivate: Int(arc4random() % UInt32(identities.count)))
        
        _OnDefaultFromSwipe_CallsActivateCallback(identities: identities, indexToActivate: Int(arc4random() % UInt32(identities.count)))
    }
    
    func _OnDefaultFromSwipe_CallsActivateCallback(identities: [String], indexToActivate: Int){
        let tableView = DummyIdentitiesTableView()
        let outlets: UIIdentitiesListViewOutlets = UIIdentitiesListViewOutlets(tableView: tableView)
        let logic: UIIdentitiesListViewLogic = UIIdentitiesListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        
        
        
        logic.setupWith(initialList: identities, defaultIdentityIndex: nil, andCallbacks: UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: nil, whenActivatedItem: { item in
            XCTAssert(identities[indexToActivate] == item)
            exp.fulfill()
        }))

        
        tableView.returnedIndexPath = IndexPath(row: indexToActivate, section: 0)
        let cell: DummyIdentityCell = DummyIdentityCell()
        tableView.returnedCell = cell
        
        let buttons = logic.swipeTableCell(cell, swipeButtonsFor: .rightToLeft, swipeSettings: MGSwipeSettings(), expansionSettings: MGSwipeExpansionSettings())
        
        
        (buttons![0] as? MGSwipeButton)?.callback(cell)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
