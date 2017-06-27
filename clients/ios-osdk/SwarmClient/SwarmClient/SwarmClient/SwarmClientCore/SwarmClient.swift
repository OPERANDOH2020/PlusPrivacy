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
    case message = "message"
    case connect = "connect"
    case disconnect = "disconnect"
    case error = "error"
}

open class SwarmClient: NSObject {
    
    // MARK: - Properties
    fileprivate var socketIO: SocketIOClient?
    fileprivate var tenantId: String
    fileprivate var connectionURL: String
    fileprivate var didConnect: Bool
    fileprivate var emitsArray: [NSDictionary]
    
    private var onReconnectIfAny: (() -> Void)?
    private var onDisconnect: ((_ data: [Any]) -> Void)?
    private var onErrorWithReason: ((_ reason: String) -> Void)?
    
    open var delegate: SwarmClientProtocol?
    
    // MARK: - Lifecycle
    public init(connectionURL: String) {
        self.connectionURL = connectionURL
        tenantId = "ios"
        didConnect = false
        emitsArray = []
        super.init()
        
        weak var weakSel = self
        self.onDisconnect = { data in
            weakSel?.delegate?.socketDidDisconnect(data)
        }
        
        self.onErrorWithReason = { reason in
            weakSel?.delegate?.didFailOperationWith(reason: reason)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func setupListeners(_ socketIO: SocketIOClient) {
        socketIO.on(SocketIOEventsNames.message.rawValue) { (receivedData, emitterSocket) in
            self.delegate?.didReceiveData(receivedData)
        }
        
        socketIO.on(SocketIOEventsNames.connect.rawValue) { (receivedData, emitterSocket) in
            self.handleSocketCreationEvent()
        }
        
        socketIO.on(SocketIOEventsNames.disconnect.rawValue) { (data, emitterSocket) in
            self.onDisconnect?(data)
        }
        
        socketIO.on(SocketIOEventsNames.error.rawValue) { (data, emitter) in
            let reason = (data.first as? String) ?? "Unknown socket error"
            self.onErrorWithReason?(reason)
            
            
        }
    }
    
    fileprivate func handleSocketCreationEvent()
    {
        didConnect = true
        for swarmDictionary in self.emitsArray {
            emitSwarmMessage(swarmDictionary)
        }
        
        self.onReconnectIfAny?()
    }
    
    fileprivate func createSocket() {
        didConnect = false
        if !NetworkReachability.hasInternetConnection() {
            delegate?.didFailedToCreateSocket(SwarmClientErrorGenerator.getInternetConnectionError())
        } else if let url = URL(string: connectionURL) {
            initSocket(url)
        } else {
            delegate?.didFailedToCreateSocket(SwarmClientErrorGenerator.getInvalidURLError())
        }
    }
    
    fileprivate func initSocket(_ url: URL) {
        socketIO = SocketIOClient(socketURL: url)
        setupListeners(socketIO!)
        socketIO!.connect()
        print("Swarm client did init a new socket!")
    }
    
    fileprivate func emitSwarmMessage(_ swarmDictionary: NSDictionary) {
        socketIO?.emit(SocketIOEventsNames.message.rawValue, swarmDictionary)
    }
    
    // MARK: - Public Methods
    
    public func startSwarm(_ swarmName: String, phase: String, ctor: String, arguments: [AnyObject]) {
        let swarmDictionary = Swarm.getSwarmDictionary(tenantId, swarmName: swarmName, phase: phase, ctor: ctor, arguments: arguments)
        if didConnect {
            emitSwarmMessage(swarmDictionary)
        } else {
            
            print("asked to start swarm \(swarmName) with ctor \(ctor) but didConnect is false")
            emitsArray.append(swarmDictionary)
            createSocket()
        }
    }
    
    public func disconnectAndReconnectWith(completion: ((_ errorMessage: String?) -> Void)? ) {
        self.didConnect = false
        
        let currentOnDisconnect = self.onDisconnect
        let currentOnFailWithReason = self.onErrorWithReason
        
        weak var weakSelf = self
        
        self.onDisconnect = { data in
            print("Swarm client did disconnect. Will re-create socket")
            weakSelf?.createSocket()
            weakSelf?.delegate?.socketDidDisconnect(data)
        }

        self.onErrorWithReason = { reason in
            completion?(reason)
        }
        
        self.onReconnectIfAny = {
            weakSelf?.onDisconnect = currentOnDisconnect
            weakSelf?.onErrorWithReason = currentOnFailWithReason
            print("Swarm client did reconnect")
            completion?(nil)
        }
        
        self.socketIO?.disconnect()
    }
    
    public func disconnect() {
        self.didConnect = false
        self.socketIO?.disconnect()
    }
}
