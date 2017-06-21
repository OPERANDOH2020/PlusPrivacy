//
//  LocalJSSettingsProviderTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class LocalJSSettingsProviderTests: XCTestCase {
    
    func test_RetrievesAndDecodesFileCorrectly()
    {
        let expectation = self.expectationWithDescription("Dictionary should not be nil")
        let provider = LocalJSSettingsProvider()
        provider.getCurrentOSPSettingsWithCompletion { (settingsDict, error) in
            
            if let settingsDict = settingsDict
            {
                expectation.fulfill()
            }
            
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
