//
//  ACSwarmClientHelper.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit
import SwarmClient

class ACSwarmClientHelper: NSObject, SwarmClientProtocol {
    
    // MARK: - Properties
    static let ServerURL = "https://plusprivacy.com:8080";
    private let swarmClient = SwarmClient(connectionURL: ACSwarmClientHelper.ServerURL);
    private let workingQueue: DispatchQueue = DispatchQueue.main
    internal let swarmClientActions = ACSwarmCallbackContainer()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        self.swarmClient.delegate = self
    }
    
    // MARK: - Public Methods
    func closeConnection() {
        swarmClient.disconnect()
    }
    
    func logout(completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        setCallbacks(withCompletionHandler: completionHandler)
        self.swarmClient.startSwarm(ACSwarmName.login.rawValue, phase: ACSwarmPhase.start.rawValue, ctor: ACLoginConstructor.userLogout.rawValue, arguments: [])
    }
    
    func loginWithUsername(username: String, password: String, completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        setCallbacks(withCompletionHandler: completionHandler)
        
        swarmClient.startSwarm(ACSwarmName.login.rawValue, phase: ACSwarmPhase.start.rawValue, ctor: ACLoginConstructor.userLogin.rawValue, arguments: [username as AnyObject, password as AnyObject])
    }

    func getOSPSettings(completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        setCallbacks(withCompletionHandler: completionHandler)
        
        self.swarmClient.startSwarm(ACSwarmName.privacyWizard.rawValue, phase: ACSwarmPhase.start.rawValue, ctor: ACPrivacyWizardConstructor.getOSPSettings.rawValue, arguments: [])
    }
    
    func getOSPSettingsRecommendedParameters(completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        setCallbacks(withCompletionHandler: completionHandler)
        
        self.swarmClient.startSwarm(ACSwarmName.privacyWizard.rawValue, phase: ACSwarmPhase.start.rawValue, ctor: ACPrivacyWizardConstructor.fetchRecommenderParams.rawValue, arguments: [])
    }
    
    private func setCallbacks(withCompletionHandler completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        workingQueue.async {
            
            self.swarmClientActions.whenError = { error in
                completionHandler(error, nil)
            }
            
            self.swarmClientActions.whenReceivedData = { data in
                completionHandler(nil, data)
            }
        }
    }
    
    internal func removeCallbacksForSwarmCalls() {
        swarmClientActions.whenReceivedData = nil
        swarmClientActions.whenError = nil
    }
}
