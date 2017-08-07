//
//  UIWebTabsListViewLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

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
    
    
    
}
