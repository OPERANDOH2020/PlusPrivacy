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

enum SocketIOEventsNames: String {
    case Message = "message"
    case Connect = "connect"
}

public class SwarmClient: NSObject {
    
    // MARK: - Properties
    private var socketIO: SocketIOClient?
    private var tenantId: String
    private var connectionURL: String
    private var didConnect: Bool
    private var emitsArray: [NSDictionary]
    
    public var delegate: SwarmClientProtocol?
    
    // MARK: - Lifecycle
    public init(connectionURL: String) {
        self.connectionURL = connectionURL
        tenantId = ""
        didConnect = false
        emitsArray = []
    }
    
    // MARK: - Private Methods
    private func setupListeners(socketIO: SocketIOClient) {
        socketIO.on(SocketIOEventsNames.Message.rawValue) { (receivedData, emitterSocket) in
            self.delegate?.didReceiveData(receivedData)
        }
        
        socketIO.on(SocketIOEventsNames.Connect.rawValue) { (receivedData, emitterSocket) in
            self.handleSocketCreationEvent()
        }
    }
    
    private func handleSocketCreationEvent() {
        didConnect = true
        for swarmDictionary in self.emitsArray {
            emitSwarmMessage(swarmDictionary)
        }
    }
    
    private func createSocket() {
        didConnect = false
        if let url = NSURL(string: connectionURL) {
            initSocket(url)
        } else {
            delegate?.didFailedToCreateSocket(SwarmClientErrorGenerator.getInvalidURLError())
        }
    }
    
    private func initSocket(url: NSURL) {
        socketIO = SocketIOClient(socketURL: url)
        setupListeners(socketIO!)
        socketIO!.connect()
    }
    
    private func emitSwarmMessage(swarmDictionary: NSDictionary) {
        socketIO?.emit(SocketIOEventsNames.Message.rawValue, swarmDictionary)
    }
    
    // MARK: - Public Methods
    public func startSwarm(swarmName: String, phase: String, ctor: String, arguments: [AnyObject]) {
        let swarmDictionary = Swarm.getSwarmDictionary(tenantId, swarmName: swarmName, phase: phase, ctor: ctor, arguments: arguments)
        if didConnect {
            emitSwarmMessage(swarmDictionary)
        } else {
            emitsArray.append(swarmDictionary)
            createSocket()
        }
    }
}