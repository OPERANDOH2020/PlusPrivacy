/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Cătălin Pomîrleanu (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

import UIKit

public let SwarmClientErrorDomain = "operando.error.domain"

public enum SwarmClientErrorCode: Int {
    case invalidURLError            = 10001
    case internetConnectionError    = 10002
}

class SwarmClientErrorGenerator: NSObject {

    class func getInvalidURLError() -> NSError {
        return NSError(domain: SwarmClientErrorDomain, code: SwarmClientErrorCode.invalidURLError.rawValue, userInfo: nil)
    }
    
    class func getInternetConnectionError() -> NSError {
        return NSError(domain: SwarmClientErrorDomain, code: SwarmClientErrorCode.internetConnectionError.rawValue, userInfo: nil)
    }
}
