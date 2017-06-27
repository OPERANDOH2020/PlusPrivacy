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

public protocol SwarmClientProtocol {
    
    func didFailedToCreateSocket(_ error: NSError)
    func didReceiveData(_ data: [Any])
    func didFailOperationWith(reason: String)
    func socketDidDisconnect(_ data: [Any])
}
