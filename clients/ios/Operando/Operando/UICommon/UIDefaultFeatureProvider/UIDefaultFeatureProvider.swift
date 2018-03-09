//
//  UIDefaultFeatureProvider.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/7/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum UIRestrictedFeatureType {
    case identityManagement
    case notifications
}

final class UIDefaultFeatureProvider: NSObject {

    static func shouldRestrictAccessToFeature() -> Bool {
        return !userIsLoggedIn()
    }
    
    static func userIsLoggedIn() -> Bool {
        return UserDefaults.boolForKey(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
