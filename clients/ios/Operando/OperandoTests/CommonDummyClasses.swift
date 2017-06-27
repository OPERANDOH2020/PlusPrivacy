//
//  CommonDummyClasses.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
@testable import Operando

class DummyWebViewTab: UIWebViewTab {
    
    var testCallbacks: UIWebViewTabCallbacks?
    var testModel: UIWebViewTabNewWebViewModel?
    
    override func commonInit() {
    }
    
    override func setupWith(model: UIWebViewTabNewWebViewModel, callbacks: UIWebViewTabCallbacks?) {
        self.testCallbacks = callbacks
        self.testModel = model
    }
    
    override func createDescriptionWithCompletionHandler(_ handler: ((WebTabDescription) -> Void)?) {
        self.testOnCreateDescription?(handler)
    }
    
    var testOnCreateDescription:((_ handler: ((WebTabDescription) -> Void)?) -> Void)?
}

class DummyWebTabsListView: UIWebTabsListView {
    override func commonInit() {
    }
    
    override func setupWith(webTabs: [WebTabDescription], callbacks: UIWebTabsViewCallbacks?) {
        self.testWebTabDescriptions = webTabs
        self.testCallbacks = callbacks
    }
    
    var testWebTabDescriptions: [WebTabDescription] = []
    var testCallbacks: UIWebTabsViewCallbacks?
}
