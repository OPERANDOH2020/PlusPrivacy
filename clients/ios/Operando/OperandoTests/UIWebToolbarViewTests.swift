//
//  UIWebToolbarViewTests.swift
//  Operando
//
//  Created by Costin Andronache on 7/6/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UIWebToolbarViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_setsNumOfItemsCorrectly() {
        self.setsNumberOfItemsCorrectly(numOfItems: 0)
        self.setsNumberOfItemsCorrectly(numOfItems: 7)
        self.setsNumberOfItemsCorrectly(numOfItems: 4)
    }
    
    func test_OnForwardPress_callsCallback(){
        //prepare
        
        let e = self.expectation(description: "")
        let forward: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let outlets: UIWebToolbarViewOutlets = UIWebToolbarViewOutlets(numOfItemsLabel: nil, forwardButton: forward, backwardButton: nil, tabsButton: nil)
        
        let logic = UIWebToolbarViewLogic(outlets: outlets)
        logic.setupWith(callbacks: UIWebToolbarViewCallbacks(onBackPress: nil, onForwardPress: { e.fulfill()  }, onTabsPress: nil))
        
        //test
        forward.sendActions(for: .touchUpInside)
        
        //assert
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_OnBackPress_callsCallback(){
        //prepare
        
        let e = self.expectation(description: "")
        let backwards: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let outlets: UIWebToolbarViewOutlets = UIWebToolbarViewOutlets(numOfItemsLabel: nil, forwardButton: nil, backwardButton: backwards, tabsButton: nil)
        
        let logic = UIWebToolbarViewLogic(outlets: outlets)
        logic.setupWith(callbacks: UIWebToolbarViewCallbacks(onBackPress: { e.fulfill() }, onForwardPress: nil, onTabsPress: nil))
        
        //test
        backwards.sendActions(for: .touchUpInside)
        
        //assert
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_OnTabsPress_callsCallback(){
        //prepare
        
        let e = self.expectation(description: "")
        let tabsButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let outlets: UIWebToolbarViewOutlets = UIWebToolbarViewOutlets(numOfItemsLabel: nil, forwardButton: nil, backwardButton: nil, tabsButton: tabsButton)
        
        let logic = UIWebToolbarViewLogic(outlets: outlets)
        logic.setupWith(callbacks: UIWebToolbarViewCallbacks(onBackPress:nil, onForwardPress: nil, onTabsPress: { e.fulfill() }))
        
        //test
        tabsButton.sendActions(for: .touchUpInside)
        
        //assert
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func setsNumberOfItemsCorrectly(numOfItems: Int) {
        //prepare
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let outlets: UIWebToolbarViewOutlets = UIWebToolbarViewOutlets(numOfItemsLabel: label, forwardButton: nil, backwardButton: nil, tabsButton: nil)
        
        let logic = UIWebToolbarViewLogic(outlets: outlets)
        
        //test
        logic.changeNumberOfItems(to: numOfItems)
        
        //assert
        XCTAssert(label.text == "\(numOfItems)")
    }
    
}
