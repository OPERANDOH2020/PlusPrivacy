//
//  WebTabsControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class DummyWebTabsListView: UIWebTabsListView {
    
    var outletsForLogic: UIWebTabsListViewOutlets?
    var _logic: UIWebTabsListViewLogic?
    
    override func commonInit() {
    }
    
   override var logic: UIWebTabsListViewLogic {
        get {
            if _logic == nil {
                _logic = DummyWebTabsListViewLogic(outlets: self.outletsForLogic ?? .allNil)
            }
            
            return _logic!;
        }
    set {
    }
    }
}

class WebTabsControllerLogicTests: XCTestCase {
    
    var logic: WebTabsControllerLogic?
    
    func testOnInitCreatesFirstTab() {
        let expectation = self.expectation(description: "On init the logic should create its first tab and ask for a view for it")
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil, addNewWebViewTabCallback: { () -> UIWebViewTab in
            expectation.fulfill()
            return UIWebViewTab(frame: .zero)
        }, presentAlertController: nil)
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsListView: DummyWebTabsListView(), webToolbarViewLogic: nil, webPool: WebViewTabManagementPool(), maxNumberOfReusableWebViews: 1)
        
        let _: WebTabsControllerLogic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test_beforeDisplayingWebTabsList_savesDescriptionOfCurrentTab(){
        
        //prepare
        let expectation = self.expectation(description: "")
        let webTab = DummyWebViewTab()
        webTab.testLogic.testOnCreateDescription = { _ in
            expectation.fulfill()
        }
        
        let dummyWebToolbarLogic = DummyWebToolbarLogic(outlets: nil)
        
        let callbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil, addNewWebViewTabCallback: {
            return webTab
        }, presentAlertController: nil)
        
        let model = WebTabsControllerLogicModel(webTabsListView: DummyWebTabsListView(), webToolbarViewLogic: dummyWebToolbarLogic, webPool: WebViewTabManagementPool(), maxNumberOfReusableWebViews: 1)
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        //test
        dummyWebToolbarLogic.callbacks?.onTabsPress?()
        
        //assert
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_afterSavingDescriptionOfCurrentTab_callsApropriateCallbackToDisplayWebTabsList() {
        
        //prepare
        let expectation = self.expectation(description: "When a tab calls to view the list of other tabs, the logic should call the appropriate callback provided")
        
        let webTab = DummyWebViewTab()
        webTab.testLogic.testOnCreateDescription = { handler in
            let desc = WebTabDescription(name: "", screenshot: nil, favIconURL: nil)
            handler?(desc)
        }
        
        let dummyToolbarLogic = DummyWebToolbarLogic(outlets: nil)
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: { _, _, _ in
            expectation.fulfill()
        }, addNewWebViewTabCallback: { () -> UIWebViewTab in
            return webTab
        }, presentAlertController: nil)
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsListView: DummyWebTabsListView(), webToolbarViewLogic: dummyToolbarLogic, webPool: WebViewTabManagementPool(), maxNumberOfReusableWebViews: 1)
        
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        //test
        dummyToolbarLogic.callbacks?.onTabsPress?()
        
        //assert
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_whenUserOpensLinkInNewTab_savesCurrentTabDescription(){
        
        // prepare 
        let expectation = self.expectation(description: "")
        let webTab = DummyWebViewTab()
        webTab.testLogic.testOnCreateDescription = { handler in
            expectation.fulfill()
        }
        
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil, addNewWebViewTabCallback: {webTab}, presentAlertController: nil)
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsListView: DummyWebTabsListView(), webToolbarViewLogic: nil, webPool: WebViewTabManagementPool(), maxNumberOfReusableWebViews: 1)
        
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        //test
        webTab.testLogic.testCallbacks?.whenUserOpensInNewTab?(URL(string: "http://www.google.ro")!)
        
        //assert
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
