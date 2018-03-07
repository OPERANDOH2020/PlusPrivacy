//
//  UserDefaults+Utils.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/7/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
    case isLoggedIn                     = "isLoggedIn"
}

extension UserDefaults {
    
    // MARK: - Settters
    static func setObject(value: AnyObject, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setSyncronizedObject(_ value: Any, forKey key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func setSynchronizedString(value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setSynchronizedBool(value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setSynchronizedFloat(value: Float, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setSynchronizedInt(value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeSynchronizedValueWithKey(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeMainPersistentDomain() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        if let domainName = bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domainName)
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - Getters
    static func objectForKey(forKey key: String) -> Any? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        let decodedObject = NSKeyedUnarchiver.unarchiveObject(with: data)
        return decodedObject
    }
    
    static func stringForKey(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func boolForKey(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func floatForKey(forKey key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    static func intForKey(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
}
