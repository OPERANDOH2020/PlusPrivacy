//
//  WebTabsControllerLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class WebTabsControllerLogicTests: XCTestCase {
    
    var logic: WebTabsControllerLogic?
    
    func testOnInitCreatesFirstTab() {
        let expectation = self.expectation(description: "On init the logic should create it's first tab and ask for a view for it")
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil, addNewWebViewTabCallback: { () -> UIWebViewTab in
            expectation.fulfill()
            return UIWebViewTab(frame: .zero)
        }, presentAlertController: nil)
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsView: DummyWebTabsListView(), maxNumberOfReusableWebViews: 1, webPool: WebViewTabManagementPool())
        
        let _: WebTabsControllerLogic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test_beforeDisplayingWebTabsList_savesDescriptionOfCurrentTab(){
        let expectation = self.expectation(description: "")
        let webTab = DummyWebViewTab()
        webTab.testOnCreateDescription = { handler in
            expectation.fulfill()
        }
        
        let callbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: nil, addNewWebViewTabCallback: {
            return webTab
        }, presentAlertController: nil)
        
        let model = WebTabsControllerLogicModel(webTabsView: DummyWebTabsListView(), maxNumberOfReusableWebViews: 1, webPool: WebViewTabManagementPool())
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        webTab.testCallbacks?.whenUserChoosesToViewTabs?()
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_afterSavingDescriptionOfCurrentTab_callsApropriateCallbackToDisplayWebTabsList() {
        
        let expectation = self.expectation(description: "When a tab calls to view the list of other tabs, the logic should call the appropriate callback provided")
        
        let webTab = DummyWebViewTab()
        webTab.testOnCreateDescription = { handler in
            let desc = WebTabDescription(name: "", screenshot: nil, favIconURL: nil)
            handler?(desc)
        }
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: nil, hideWebTabsView: nil, showWebTabsViewOnTop: { _, _, _ in
            expectation.fulfill()
        }, addNewWebViewTabCallback: { () -> UIWebViewTab in
            return webTab
        }, presentAlertController: nil)
        
        let model: WebTabsControllerLogicModel = WebTabsControllerLogicModel(webTabsView: DummyWebTabsListView(), maxNumberOfReusableWebViews: 1, webPool: WebViewTabManagementPool())
        
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        webTab.testCallbacks?.whenUserChoosesToViewTabs?()
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_whenUserOpensLinkInNewTab_savesCurrentTabDescription(){
        let expectation = self.expectation(description: "")
        let webTab = DummyWebViewTab()
        webTab.testOnCreateDescription = { handler in
            expectation.fulfill()
        }
        
    }
    
}
