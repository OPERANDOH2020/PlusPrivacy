//
//  UIWebTabsListViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando


class DummyWebTabCell: UIWebTabCollectionCell {
    
    var onSetupWithWebTabDescriptionCallbacks: ((_ wt: WebTabDescription, _ callbackOnClose: VoidBlock?) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    override func setupWith(webTabDescription: WebTabDescription, whenClosePressed: VoidBlock?) {
        self.onSetupWithWebTabDescriptionCallbacks?(webTabDescription, whenClosePressed)
    }
    
}

class DummyWebTabCollectionView: UICollectionView {
    
    var onRemoveItemsAtIndexes: ((_ items: [IndexPath]) -> Void)?
    let returnedCell: DummyWebTabCell = DummyWebTabCell()
    var indexPathForCell: IndexPath?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.returnedCell;
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        self.onRemoveItemsAtIndexes?(indexPaths)
    }
    
    override func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return self.indexPathForCell
    }
}

class UIWebTabsListViewLogicTests: XCTestCase {
    
    func test_whenInBusyState_ShowsIndicatorDisablesInteraction(){
        let outlets: UIWebTabsListViewOutlets = .allDefault
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        
        logic.inBusyState = true
        XCTAssert(!outlets.activityIndicator!.isHidden)
        XCTAssert(!outlets.containerView!.isUserInteractionEnabled)
    }
    
    func test_OnClose_CallsCloseCallback() {
        let outlets: UIWebTabsListViewOutlets = .allDefault
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        logic.setupWith(webTabs: [], callbacks: UIWebTabsListViewCallbacks(whenUserPressedClose: {
            exp.fulfill()
        }, whenUserAddsNewTab: nil, whenUserSelectedTabAtIndex: nil, whenUserDeletedTabAtIndex: nil))
        
        outlets.closeButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnAddNewTab_CallsAddTabCallback() {
        let outlets: UIWebTabsListViewOutlets = .allDefault
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        logic.setupWith(webTabs: [], callbacks: UIWebTabsListViewCallbacks(whenUserPressedClose: {
    
        }, whenUserAddsNewTab: {
            exp.fulfill()
        }, whenUserSelectedTabAtIndex: nil, whenUserDeletedTabAtIndex: nil))
        
        outlets.addButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnSelectTabAtIndex_CallsSelectCallback(){
        _OnSelectTabAtIndex_CallsSelectCallback(webTabDescriptions: [WebTabDescription(name: "pg1", screenshot: nil, favIconURL: nil),
                                                                     WebTabDescription(name: "pg2", screenshot: nil, favIconURL: nil)], index: 0)
        
        _OnSelectTabAtIndex_CallsSelectCallback(webTabDescriptions: [WebTabDescription(name: "pg1", screenshot: nil, favIconURL: nil),
                                                                     WebTabDescription(name: "pg2", screenshot: nil, favIconURL: nil)], index: 1)
    }
    
    func _OnSelectTabAtIndex_CallsSelectCallback(webTabDescriptions: [WebTabDescription], index: Int) {
        let outlets: UIWebTabsListViewOutlets = UIWebTabsListViewOutlets.allDefault
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        logic.setupWith(webTabs: webTabDescriptions, callbacks: UIWebTabsListViewCallbacks(whenUserPressedClose: nil, whenUserAddsNewTab: nil, whenUserSelectedTabAtIndex: { selectedIndex in
            XCTAssert(selectedIndex == index)
            exp.fulfill()
        }, whenUserDeletedTabAtIndex: nil))
        
        logic.collectionView(outlets.collectionView!, didSelectItemAt: IndexPath(item: index, section: 0))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_OnDeleteCellAtIndex_RemovesFromCollectionView_CallsCallback() {
        let webTabs: [WebTabDescription] = [
            WebTabDescription(name: "wt1", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "wt2", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "asdf", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "zquifigx", screenshot: nil, favIconURL: nil)];
        
        _OnDeleteCellAtIndex_RemovesFromCollectionView_CallsCallback(webTabDescriptions: webTabs, index: 0)
        
        _OnDeleteCellAtIndex_RemovesFromCollectionView_CallsCallback(webTabDescriptions: webTabs, index: 1)
        
        _OnDeleteCellAtIndex_RemovesFromCollectionView_CallsCallback(webTabDescriptions: webTabs, index: 3)
        
    }
    
    func test_setsUpCorrectlyCellWithWebTabDescription() {
        let webTabs: [WebTabDescription] = [
            WebTabDescription(name: "wt1", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "wt2", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "asdf", screenshot: nil, favIconURL: nil),
            WebTabDescription(name: "zquifigx", screenshot: nil, favIconURL: nil)];
        
        _setsUpCorrectlyCellWithWebTabDescription(webTabs: webTabs, index: 0)
        _setsUpCorrectlyCellWithWebTabDescription(webTabs: webTabs, index: 3)
        _setsUpCorrectlyCellWithWebTabDescription(webTabs: webTabs, index: 2)
    }
    
    func _setsUpCorrectlyCellWithWebTabDescription(webTabs: [WebTabDescription], index: Int){
        let exp = self.expectation(description: "")
        let dummyCV: DummyWebTabCollectionView = DummyWebTabCollectionView()
        let outlets: UIWebTabsListViewOutlets = UIWebTabsListViewOutlets(collectionView: dummyCV, activityIndicator: nil, addButton: nil, closeButton: nil, containerView: nil)
        
        dummyCV.returnedCell.onSetupWithWebTabDescriptionCallbacks = { (tab, closeCallback) in
            XCTAssert(tab == webTabs[index])
            exp.fulfill()
        }
        
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        logic.setupWith(webTabs: webTabs, callbacks: nil)
        
        let _ = logic.collectionView(dummyCV, cellForItemAt: IndexPath(item: index, section: 0))
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func _OnDeleteCellAtIndex_RemovesFromCollectionView_CallsCallback(webTabDescriptions: [WebTabDescription], index: Int){
        
        let expRemoveFromCollectionView = self.expectation(description: "")
        let expCallbackWithIndex = self.expectation(description: "")
        
        let dummyCV: DummyWebTabCollectionView = DummyWebTabCollectionView()
        let outlets: UIWebTabsListViewOutlets = UIWebTabsListViewOutlets(collectionView: dummyCV, activityIndicator: nil, addButton: nil, closeButton: nil, containerView: nil)
        
        dummyCV.returnedCell.onSetupWithWebTabDescriptionCallbacks = { tabs, close in
            DispatchQueue.main.async {
                close?()
            }
        }
        
        dummyCV.indexPathForCell = IndexPath(item: index, section: 0)
        
        dummyCV.onRemoveItemsAtIndexes = { indexes in
            XCTAssert(indexes.first!.item == index)
            expRemoveFromCollectionView.fulfill()
        }
        
        let logic: UIWebTabsListViewLogic = UIWebTabsListViewLogic(outlets: outlets)
        logic.setupWith(webTabs: webTabDescriptions, callbacks: UIWebTabsListViewCallbacks(whenUserPressedClose: nil, whenUserAddsNewTab: nil, whenUserSelectedTabAtIndex: nil, whenUserDeletedTabAtIndex: { deletedTabIndex in
            XCTAssert(deletedTabIndex == index)
            expCallbackWithIndex.fulfill()
            
            //it seems waitForExpectations
        }))
        
        let _ = logic.collectionView(dummyCV, cellForItemAt: IndexPath(item: index, section: 0))

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
