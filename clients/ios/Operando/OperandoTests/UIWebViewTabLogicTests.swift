//
//  UIWebViewTabLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 7/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando
import WebKit


class DummyNavigationAction: WKNavigationAction {
    
    var overwrittenRequest: URLRequest?
    override var request: URLRequest {
        return self.overwrittenRequest!
    }
}

class DummyWebView: WKWebView {
    
    var navigation: WKNavigation?
    var overwrittenURL: URL?
    override var url: URL? {
        return self.overwrittenURL
    }
    
    var onLoadRequest: ((_ request: URLRequest) -> WKNavigation?)?
    override func load(_ request: URLRequest) -> WKNavigation? {
        return self.onLoadRequest?(request)
    }
}

class UIWebViewTabLogicTests: XCTestCase {
    
    func testNavigationModel(index: Int) -> UIWebViewTabNavigationModel  {
        return UIWebViewTabNavigationModel(urlList: [URL(string: "http://www.google.ro")!,
                                                     URL(string: "http://www.yahoo.com")!,
                                                     URL(string: "http://www.facebook.com")!,
                                                     URL(string: "http://www.tumblr.com")!], currentURLIndex: index)!
    }
    
    func _afterSetup_currentNavigationModelRemainsTheSame(_ navigationModel: UIWebViewTabNavigationModel){
        // prepare
        let logic = UIWebViewTabLogic(outlets: nil)
        let model = UIWebViewTabModel(navigationModel: navigationModel, webView: nil)
        
        //test
        logic.setupWith(model: model, callbacks: nil)
        
        //assert
        let currentNavigationModel = logic.currentNavigationModel!
        XCTAssert(currentNavigationModel == navigationModel)
    }
    
    func test_afterSetup_currentNavigationModelIsCorrect() {
        _afterSetup_currentNavigationModelRemainsTheSame(self.testNavigationModel(index: 1))
        _afterSetup_currentNavigationModelRemainsTheSame(self.testNavigationModel(index: 0))
        _afterSetup_currentNavigationModelRemainsTheSame(self.testNavigationModel(index: 3))
    }
    
    func _afterChangeNavigationModel_currentNavigationModelIsTheLatter(initialModel: UIWebViewTabNavigationModel,
                                                                     changedModel: UIWebViewTabNavigationModel){
        // prepare
        let logic = UIWebViewTabLogic(outlets: nil)
        let model = UIWebViewTabModel(navigationModel: initialModel, webView: nil)
        logic.setupWith(model: model, callbacks: nil)
        
        //test
        logic.changeNavigationModel(to: changedModel, callback: nil)
        
        //assert
        XCTAssert(logic.currentNavigationModel! == changedModel)
    }
    
    func test_afterChangeNavigationModel_currentNavigationModelIsTheSame(){
        _afterChangeNavigationModel_currentNavigationModelIsTheLatter(initialModel: self.testNavigationModel(index: 0), changedModel: self.testNavigationModel(index: 2))
        
        _afterChangeNavigationModel_currentNavigationModelIsTheLatter(initialModel: self.testNavigationModel(index: 1), changedModel: self.testNavigationModel(index: 3))
        
        _afterChangeNavigationModel_currentNavigationModelIsTheLatter(initialModel: self.testNavigationModel(index: 2), changedModel: self.testNavigationModel(index: 1))
    }
    
    func test_OnSetup_AppliesNavigationModelOnUI(){
        _OnSetup_AppliesNavigationModelOnUI(navigationModel: self.testNavigationModel(index: 1))
        _OnSetup_AppliesNavigationModelOnUI(navigationModel: self.testNavigationModel(index: 0))
        _OnSetup_AppliesNavigationModelOnUI(navigationModel: self.testNavigationModel(index: 3))
    }
    
    func _OnSetup_AppliesNavigationModelOnUI(navigationModel: UIWebViewTabNavigationModel){
        let expNavigatesWebViewToCurrentURL = self.expectation(description: "")
        
        let dummyWebView: DummyWebView = DummyWebView()
        dummyWebView.onLoadRequest = { request in
            XCTAssert(request.url! == navigationModel.urlList[navigationModel.currentURLIndex])
            expNavigatesWebViewToCurrentURL.fulfill()
            return nil
        }
        
        let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: nil, goButton: nil, addressTF: .init(), activityIndicator: nil, addressBarView: nil)
        
        let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
        logic.setupWith(model: UIWebViewTabModel(navigationModel: navigationModel, webView: dummyWebView), callbacks: nil)
        
        XCTAssert(outlets.addressTF!.text == navigationModel.urlList[navigationModel.currentURLIndex].absoluteString)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnChangeNavigationModel_AppliesNewNavigationModelToUI(){
        _OnChangeNavigationModel_AppliesNewNavigationModelToUI(from: self.testNavigationModel(index: 0), to: self.testNavigationModel(index: 1))
        
        _OnChangeNavigationModel_AppliesNewNavigationModelToUI(from: self.testNavigationModel(index: 3), to: self.testNavigationModel(index: 1))
        
        _OnChangeNavigationModel_AppliesNewNavigationModelToUI(from: self.testNavigationModel(index: 1), to: self.testNavigationModel(index: 2))
    }
    
    func _OnChangeNavigationModel_AppliesNewNavigationModelToUI(from fromModel: UIWebViewTabNavigationModel, to toNavigationModel: UIWebViewTabNavigationModel){
        
        let expNavigatesWebViewToCurrentURL = self.expectation(description: "")
        
        let dummyWebView: DummyWebView = DummyWebView()
        var ignoredFirstLoadRequest: Bool = false
        
        dummyWebView.onLoadRequest = { request in
            guard ignoredFirstLoadRequest else {
                ignoredFirstLoadRequest = true
                return nil
            }
            XCTAssert(request.url! == toNavigationModel.urlList[toNavigationModel.currentURLIndex])
            expNavigatesWebViewToCurrentURL.fulfill()
            return nil
        }
        
        let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: nil, goButton: nil, addressTF: .init(), activityIndicator: nil, addressBarView: nil)
        
        let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
        logic.setupWith(model: UIWebViewTabModel(navigationModel: fromModel, webView: dummyWebView), callbacks: nil)
        
        logic.changeNavigationModel(to: toNavigationModel, callback: nil)
        XCTAssert(outlets.addressTF!.text == toNavigationModel.urlList[toNavigationModel.currentURLIndex].absoluteString)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)

    }
    
    func test_OnForward_ToNextURL_AppliesToUI() {
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 0), direction: 1, navigationBlock: {$0.goForward()})
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 1), direction: 1, navigationBlock: {$0.goForward()})
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 2), direction: 1, navigationBlock: {$0.goForward()})
    }
    
    func test_OnBack_ToPreviousURL_AppliesToUI() {
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 3), direction: -1, navigationBlock: {$0.goBack()})
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 1), direction: -1, navigationBlock: {$0.goBack()})
        _NavigateAndAssert(navigationModel: self.testNavigationModel(index: 2), direction: -1, navigationBlock: {$0.goBack()})
    }

    
    func _NavigateAndAssert(navigationModel: UIWebViewTabNavigationModel, direction: Int, navigationBlock: ((_ logic: UIWebViewTabLogic) -> Void)){
        let expNavigatesWebViewToCurrentURL = self.expectation(description: "")
        
        let dummyWebView: DummyWebView = DummyWebView()
        var ignoredFirstLoadRequest: Bool = false
        
        dummyWebView.onLoadRequest = { request in
            guard ignoredFirstLoadRequest else {
                ignoredFirstLoadRequest = true
                return nil
            }
            XCTAssert(request.url! == navigationModel.urlList[navigationModel.currentURLIndex + direction])
            expNavigatesWebViewToCurrentURL.fulfill()
            return nil
        }
        
        let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: nil, goButton: nil, addressTF: .init(), activityIndicator: nil, addressBarView: nil)
        
        let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
        logic.setupWith(model: UIWebViewTabModel(navigationModel: navigationModel, webView: dummyWebView), callbacks: nil)
        
        navigationBlock(logic)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnForward_NoNavigation_LeavesAsItIs(){
        _OnNoNavigationPossible_LeavesAsItIs(navigationModel: self.testNavigationModel(index: 3), navigationBlock: {$0.goForward()})
    }
    
    func test_OnBack_NoNavigation_LeavesAsItIs() {
        _OnNoNavigationPossible_LeavesAsItIs(navigationModel: self.testNavigationModel(index: 0), navigationBlock: {$0.goBack()})
    }
    
    func _OnNoNavigationPossible_LeavesAsItIs(navigationModel: UIWebViewTabNavigationModel, navigationBlock: ((_ logic: UIWebViewTabLogic) -> Void)){
        
            let dummyWebView: DummyWebView = DummyWebView()
            var ignoredFirstLoadRequest: Bool = false
            
            dummyWebView.onLoadRequest = { request in
                guard ignoredFirstLoadRequest else {
                    ignoredFirstLoadRequest = true
                    return nil
                }
                XCTFail()
                return nil
            }
            
            let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: nil, goButton: nil, addressTF: .init(), activityIndicator: nil, addressBarView: nil)
            
            let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
            logic.setupWith(model: UIWebViewTabModel(navigationModel: navigationModel, webView: dummyWebView), callbacks: nil)
            
            navigationBlock(logic)
        
        XCTAssert(outlets.addressTF!.text == navigationModel.urlList[navigationModel.currentURLIndex].absoluteString)
    }
    
    func test_onGo_NonAddressTextInTextField_CallsCallbackForURL() {
        _onGo_NonAddressTextInTextField_CallsCallbackForURL(text: "leURL")
        _onGo_NonAddressTextInTextField_CallsCallbackForURL(text: "gibberish")
    }
    
    func _onGo_NonAddressTextInTextField_CallsCallbackForURL(text: String){
        let exp = self.expectation(description: "")
        
        let outlets: UIWebViewTabLogicOutlets = .allDefault
        let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
        
        logic.setupWith(model: UIWebViewTabModel(navigationModel: nil, webView: nil), callbacks: UIWebViewTabCallbacks(urlForUserInput: { userInput in
            
            XCTAssert(userInput == text)
            exp.fulfill()
            
            return URL(string: "http://www.google.com")!
        }, whenPresentingAlertController: nil, whenCreatingExternalWebView: nil, whenUserOpensInNewTab: nil))
        
        outlets.addressTF?.text = text
        outlets.goButton?.sendActions(for: .touchUpInside)
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
    func test_onWebViewFinishingLoad_UpdatesTextfieldAndHistory() {
        _onWebViewFinishingLoad_UpdatesTextfieldAndHistory(navigationModel: self.testNavigationModel(index: 0), toURL: URL(string: "http://www.romsoft.eu")!)
        
        _onWebViewFinishingLoad_UpdatesTextfieldAndHistory(navigationModel: self.testNavigationModel(index: 0), toURL: URL(string: "http://www.operando.eu")!)

    }
    
    func _onWebViewFinishingLoad_UpdatesTextfieldAndHistory(navigationModel: UIWebViewTabNavigationModel,
                                                            toURL: URL) {
        
        let webView = DummyWebView()
        let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: nil, goButton: nil, addressTF: .init(), activityIndicator: nil, addressBarView: nil)
        
        let logic: UIWebViewTabLogic = UIWebViewTabLogic(outlets: outlets)
        
        logic.setupWith(model: UIWebViewTabModel(navigationModel: navigationModel, webView: webView), callbacks: nil)
        
        let dummyAction = DummyNavigationAction()
        dummyAction.overwrittenRequest = URLRequest(url: toURL)
        
        webView.overwrittenURL = toURL
        
        logic.webView(webView, decidePolicyFor: dummyAction) { _ in }
        
        logic.webView(webView, didFinish: nil)
        
        XCTAssert(outlets.addressTF!.text == toURL.absoluteString)
        XCTAssert(logic.currentNavigationModel!.currentURLIndex == logic.currentNavigationModel!.urlList.count - 1)
        XCTAssert(logic.currentNavigationModel!.urlList.last! == toURL)
    }
}
