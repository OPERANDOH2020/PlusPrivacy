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

struct UserSettingsModel {
    let enableAdBlock: Bool
    
    
    
    func writeTo(defaults: UserDefaults){
        defaults.set(self.enableAdBlock, forKey: "enableAdBlock")
    }
    
    static func createFrom(defaults: UserDefaults) -> UserSettingsModel? {
        guard let enabledAdBlockBool = defaults.object(forKey: "enableAdBlock") as? Bool else {
            return nil
        }
        
        return UserSettingsModel(enableAdBlock: enabledAdBlockBool)
    }
    
    static let defaultSettings: UserSettingsModel = UserSettingsModel(enableAdBlock: true)
}
