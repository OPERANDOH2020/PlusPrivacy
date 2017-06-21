//
//  OperandoTests.swift
//  OperandoTests
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class OperandoTests: XCTestCase
{
    
    func testDictionaryToPostBody()
    {
        let dict: [String : String] = ["param1" : "value1",
                                       "param2" : "value2",
                                       "param3" : "value3"]
        
        
        let postBody = dict.postBodyString
        XCTAssert(postBody == "param1=value1&param2=value2&param3=value3")
    }
    
}
