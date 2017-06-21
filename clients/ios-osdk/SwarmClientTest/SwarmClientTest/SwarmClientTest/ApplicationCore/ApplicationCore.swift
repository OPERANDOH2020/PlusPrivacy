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
import SwarmClient

let ACDidReceiveDataFromServerNotification = "ACDidReceiveDataFromServerNotification"
let ACFailedToCreateSocketNotification = "ACFailedToCreateSocketNotification"

class ApplicationCore: NSObject, SwarmClientProtocol {
    
    // MARK: - Properties
    private let swarmClient: SwarmClient
    
    // MARK: - Public Methods
    func login(username: String, password: String) {
        swarmClient.startSwarm("login.js", phase: "start", ctor: "userLogin", arguments: [username, password])
    }
    
    // MARK: - Shared Instance
    class var sharedInstance: ApplicationCore {
        struct Singleton {
            static let instance = ApplicationCore()
        }
        return Singleton.instance
    }
    
    private override init() {
        swarmClient = SwarmClient(connectionURL: WSServerPath)
        super.init()
        swarmClient.delegate = self
    }
    
    // MARK: - Swarm Client Protocol Methods
    func didFailedToCreateSocket(error: NSError) {
        NSNotificationCenter.defaultCenter().postNotificationName(ACFailedToCreateSocketNotification, object: nil)
    }
    
    func didReceiveData(data: [AnyObject]) {
        NSNotificationCenter.defaultCenter().postNotificationName(ACDidReceiveDataFromServerNotification, object: data)
    }
}
