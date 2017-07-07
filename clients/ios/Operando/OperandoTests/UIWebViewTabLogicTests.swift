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

class UIWebViewTabLogicTests: XCTestCase {
    
    
    
    
    func testNavigationModel(index: Int) -> UIWebViewTabNavigationModel  {
        return UIWebViewTabNavigationModel(urlList: [URL(string: "http://www.google.ro")!,
                                                     URL(string: "http://www.yahoo.com")!,
                                                     URL(string: "http://www.facebook.com")!,
                                                     URL(string: "http://www.tumblr.com")!], currentURLIndex: index)!
    }
    
    func _afterSetup_currentNavigationModelIsCorrect(_ navigationModel: UIWebViewTabNavigationModel){
        // prepare
        let logic = UIWebViewTabLogic(outlets: nil)
        let model = UIWebViewTabNewWebViewModel(navigationModel: navigationModel, setupParameter: .processPool(WKProcessPool()))
        
        //test
        logic.setupWith(model: model, callbacks: nil)
        
        //assert
        let currentNavigationModel = logic.currentNavigationModel!
        self.assertNavigationModelsEqual(currentNavigationModel, navigationModel)
    }
    
    func test_afterSetup_currentNavigationModelIsCorrect() {
        _afterSetup_currentNavigationModelIsCorrect(self.testNavigationModel(index: 1))
        _afterSetup_currentNavigationModelIsCorrect(self.testNavigationModel(index: 0))
        _afterSetup_currentNavigationModelIsCorrect(self.testNavigationModel(index: 3))
    }
    
    func _afterChangeNavigationModel_currentNavigationModelIsTheSame(initialModel: UIWebViewTabNavigationModel,
                                                                     changedModel: UIWebViewTabNavigationModel){
        // prepare
        let logic = UIWebViewTabLogic(outlets: nil)
        let model = UIWebViewTabNewWebViewModel(navigationModel: initialModel, setupParameter: .processPool(WKProcessPool()))
        logic.setupWith(model: model, callbacks: nil)
        
        //test
        logic.changeNavigationModel(to: changedModel, callback: nil)
        
        //assert
        self.assertNavigationModelsEqual(changedModel, logic.currentNavigationModel!)
    }
    
    func test_afterChangeNavigationModel_currentNavigationModelIsTheSame(){
        _afterChangeNavigationModel_currentNavigationModelIsTheSame(initialModel: self.testNavigationModel(index: 0), changedModel: self.testNavigationModel(index: 2))
        
        _afterChangeNavigationModel_currentNavigationModelIsTheSame(initialModel: self.testNavigationModel(index: 1), changedModel: self.testNavigationModel(index: 3))
        
        _afterChangeNavigationModel_currentNavigationModelIsTheSame(initialModel: self.testNavigationModel(index: 2), changedModel: self.testNavigationModel(index: 1))
    }
    
    func assertNavigationModelsEqual(_ currentNavigationModel: UIWebViewTabNavigationModel,
                                     _ navigationModel: UIWebViewTabNavigationModel){
        
        XCTAssert(currentNavigationModel.urlList.count == navigationModel.urlList.count)
        XCTAssert(currentNavigationModel.currentURLIndex == navigationModel.currentURLIndex)
        XCTAssert(currentNavigationModel.urlList == navigationModel.urlList)
    }
}
