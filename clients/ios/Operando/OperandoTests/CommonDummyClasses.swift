//
//  CommonDummyClasses.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
@testable import Operando


class DummyWebToolbarLogic: UIWebToolbarViewLogic {
    
    var callbacks: UIWebToolbarViewCallbacks?
    
    override func setupWith(callbacks: UIWebToolbarViewCallbacks?) {
        self.callbacks = callbacks;
    }
    
}

class DummyWebViewTabLogic: UIWebViewTabLogic {
    
    var testCallbacks: UIWebViewTabCallbacks?
    var testModel: UIWebViewTabModel?
    
    override func setupWith(model: UIWebViewTabModel, callbacks: UIWebViewTabCallbacks?) {
        self.testCallbacks = callbacks
        self.testModel = model
    }
    
    override func createDescriptionWithCompletionHandler(_ handler: ((WebTabDescription) -> Void)?) {
        self.testOnCreateDescription?(handler)
    }
    
    var testOnCreateDescription:((_ handler: ((WebTabDescription) -> Void)?) -> Void)?
}


class DummyWebViewTab: UIWebViewTab {
    
    var testLogic: DummyWebViewTabLogic = DummyWebViewTabLogic(outlets: nil)
    override var logic: UIWebViewTabLogic {
        return testLogic
    }

    override func commonInit() {
    }
    
}



class DummyWebTabsListViewLogic: UIWebTabsListViewLogic {
    
    override func setupWith(webTabs: [WebTabDescription], callbacks: UIWebTabsListViewCallbacks?) {
        self.testWebTabDescriptions = webTabs
        self.testCallbacks = callbacks
    }
    
    var testWebTabDescriptions: [WebTabDescription] = []
    var testCallbacks: UIWebTabsListViewCallbacks?
}
