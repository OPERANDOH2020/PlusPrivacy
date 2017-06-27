//
//  WebViewTabManagementPoolTests.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class WebViewTabManagementPoolTests: XCTestCase {

    
    func testWithNoWebTabsReturnsNil() {
        let pool = WebViewTabManagementPool()
        assert(pool.oldestWebViewTab == nil)
        
    }
    
    func testWithOneAddedReturnsOldestCorrectly() {
        let pool = WebViewTabManagementPool()
        let first = DummyWebViewTab()
        pool.addNew(webViewTab: first)
        
        assert(pool.oldestWebViewTab == first)
    }
    
    func testWith2AddedAndMarkedReturnsOldestCorrectly() {
        let pool = WebViewTabManagementPool()
        let first = DummyWebViewTab()
        let second = DummyWebViewTab()
        
        pool.addNew(webViewTab: first)
        pool.addNew(webViewTab: second)
        
        pool.markWebViewTab(first)
        
        assert(pool.oldestWebViewTab == second)
    }
    
    func testWith3ReturnsOldestCorrectly() {
        let pool = WebViewTabManagementPool()
        let first = DummyWebViewTab()
        let second = DummyWebViewTab()
        let third = DummyWebViewTab()
        
        pool.addNew(webViewTab: first)
        pool.addNew(webViewTab: second)
        pool.addNew(webViewTab: third)
        
        pool.markWebViewTab(first)
        pool.markWebViewTab(third)
        
        assert(pool.oldestWebViewTab == second)
    }
}
