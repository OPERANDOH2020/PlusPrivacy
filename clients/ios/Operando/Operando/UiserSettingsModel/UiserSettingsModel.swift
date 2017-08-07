//
//  UiserSettingsModel.swift
//  Operando
//
//  Created by Costin Andronache on 6/27/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation

typealias UserSettingsModelUpdateCallback = (_ settingsModel: UserSettingsModel) -> Void
typealias UserSettingsModelRetrieveCallback = () -> UserSettingsModel

struct UserSettingsModelCallbacks {
    let retrieveCallback: UserSettingsModelRetrieveCallback
    let updateCallback: UserSettingsModelUpdateCallback
}

struct UserSettingsModel: Equatable {
    let enableAdBlock: Bool
    let clearWebsiteDataOnExit: Bool
    let disableWebsiteProtection: Bool
    
    
    func writeTo(defaults: UserDefaults){
        defaults.set(self.enableAdBlock, forKey: "enableAdBlock")
        defaults.set(self.clearWebsiteDataOnExit, forKey: "clearWebsiteDataOnExit")
        defaults.set(self.disableWebsiteProtection, forKey: "disableWebsiteProtection")
    }
    
    static func createFrom(defaults: UserDefaults) -> UserSettingsModel? {
        guard let enabledAdBlockBool = defaults.object(forKey: "enableAdBlock") as? Bool,
            let clearWebsiteDataOnExit = defaults.object(forKey: "clearWebsiteDataOnExit") as? Bool,
            let disableWebsiteProtection = defaults.object(forKey: "disableWebsiteProtection") as? Bool else {
            return nil
        }
        
        return UserSettingsModel(enableAdBlock: enabledAdBlockBool,
                                 clearWebsiteDataOnExit: clearWebsiteDataOnExit,
                                 disableWebsiteProtection:disableWebsiteProtection)
    }
    
    static let defaultSettings: UserSettingsModel = UserSettingsModel(enableAdBlock: true,
                                                                      clearWebsiteDataOnExit: true,
                                                                      disableWebsiteProtection: false)
}

func ==(lhs: UserSettingsModel, rhs: UserSettingsModel) -> Bool {
    return lhs.clearWebsiteDataOnExit == rhs.clearWebsiteDataOnExit &&
           lhs.disableWebsiteProtection == rhs.disableWebsiteProtection &&
           lhs.enableAdBlock == rhs.enableAdBlock
}
