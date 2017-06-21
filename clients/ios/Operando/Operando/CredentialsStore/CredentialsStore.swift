//
//  CredentialsStore.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

//TO DO: In production, must replace the use of NSUserDefaults with KeyChain
//NSUserDefaults will be used for the purposes of the demo

class CredentialsStore: NSObject
{
    
    static let DefaultsUsernameKey = "DefaultsUsernameKey"
    static let DefaultsPasswordKey = "DefaultsPasswordKey"
    
    class func retrieveLastSavedCredentialsIfAny() -> (username: String, password: String)?
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        
        if let username = defaults.objectForKey(DefaultsUsernameKey) as? String,
               password = defaults.objectForKey(DefaultsPasswordKey) as? String
        {
            return (username, password);
        }
        
        return nil;
    }
    
    
    class func saveCredentials(username: String, password: String)
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        
        defaults.setObject(username, forKey: DefaultsUsernameKey);
        defaults.setObject(password, forKey: DefaultsPasswordKey);
        
        defaults.synchronize()
    }
}
