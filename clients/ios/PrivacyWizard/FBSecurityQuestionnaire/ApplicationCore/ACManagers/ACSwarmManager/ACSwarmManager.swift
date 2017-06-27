//
//  ACSwarmManager.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class ACSwarmManager: NSObject {
    
    // MARK: - Properties
    private var swarmClientHelper: ACSwarmClientHelper
    
    // MARK: - Lifecycle
    private override init() {
        swarmClientHelper = ACSwarmClientHelper()
        
        super.init()
    }
    
    // MARK: - Shared Instance
    class var shared : ACSwarmManager {
        struct Singleton {
            static let instance = ACSwarmManager()
        }
        return Singleton.instance
    }
    
    // MARK: - Private Methods
    private func extractOSPSettings(error: NSError?, data: [Any]?) -> AMPrivacySettings? {
        if error != nil { return nil }
        guard let data = data, let dictionary = data.first as? [String: Any] else { return nil }
        
        return AMPrivacySettings(dictionary: dictionary)
    }
    
    private func extractRecommendedParameters(error: NSError?, data: [Any]?) -> AMRecommendedSettings? {
        if error != nil { return nil }
        guard let data = data, let dictionary = data.first as? [String: Any] else { return nil }
        
        return AMRecommendedSettings(dictionary: dictionary)
    }
    
    private func getConfiguration(forUser username: String, withPassword password: String, completionHandler: @escaping (NSError?, AMPrivacySettings?, AMRecommendedSettings?) -> Void) {
        loginWithUsername(username: username, password: password) {[weak self] (error, _) in
            guard let strongSelf = self else { completionHandler(error, nil, nil); return }
            if error == nil {
                strongSelf.getOSPSettings(completionHandler: {(error, settings) in
                    if error == nil {
                        strongSelf.getOSPSettingsRecommendedParameters(completionHandler: { (error, recSettings) in
                            strongSelf.closeServerConnection()
                            DispatchQueue.main.async {
                                completionHandler(error, settings, recSettings)
                            }
                        })
                    } else {
                        completionHandler(error, nil, nil)
                    }
                })
            } else {
                completionHandler(error, nil, nil)
            }
        }
    }
    
    // MARK: - Public Methods
    func retrieveConfiguration(forUser username: String, withPassword password: String, completionHandler: @escaping (NSError?, AMPrivacySettings?, AMRecommendedSettings?) -> Void) {
        getConfiguration(forUser: username, withPassword: password) { [weak self] (error, privacySettings, recommendedSettings) in
            DispatchQueue.main.async {
                completionHandler(error, privacySettings, recommendedSettings)
            }
            guard let strongSelf = self else { return }
            strongSelf.closeServerConnection()
        }
    }
    
    func loginWithUsername(username: String, password: String, completionHandler: @escaping (NSError?, [Any]?) -> Void) {
        swarmClientHelper.loginWithUsername(username: username, password: password) { (error, data) in
            completionHandler(error, nil)
        }
    }
    
    func getOSPSettings(completionHandler: @escaping (NSError?, AMPrivacySettings?) -> Void) {
        swarmClientHelper.getOSPSettings { (error, data) in
            let privacySettings = self.extractOSPSettings(error: error, data: data)
            completionHandler(error, privacySettings)
        }
    }
    
    func getOSPSettingsRecommendedParameters(completionHandler: @escaping (NSError?, AMRecommendedSettings?) -> Void) {
        swarmClientHelper.getOSPSettingsRecommendedParameters { (error, data) in
            let recommendedParameters = self.extractRecommendedParameters(error: error, data: data)
            completionHandler(error, recommendedParameters)
        }
    }
    
    func logout() {
        swarmClientHelper.logout { [weak self] (error, data) in
            guard let strongSelf = self else { return }
            strongSelf.closeServerConnection()
        }
    }
    
    func closeServerConnection() {
        swarmClientHelper.closeConnection()
    }
}
