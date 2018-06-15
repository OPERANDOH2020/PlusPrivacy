//
//  CredentialsStore.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

//TO DO: In production, must replace the use of NSUserDefaults with KeyChain

class CredentialsStore: NSObject
{
    
    static let DefaultsUsernameKey = "DefaultsUsernameKey"
    static let DefaultsPasswordKey = "DefaultsPasswordKey"
    static let privateMessageKey = "privateMessageKey"
    
    class func getPrivateMessageStatus() -> Bool? {
        
        let defaults = UserDefaults.standard;
        
        return defaults.value(forKey: privateMessageKey) as? Bool
    }
    
    class func dontShowPrivateBrowsingMessage() {
        let defaults = UserDefaults.standard;
        
        defaults.set(true, forKey: privateMessageKey);
        
        defaults.synchronize()
    }
    
    class func retrieveLastSavedCredentialsIfAny() -> (username: String, password: String)?
    {
        
        guard let data = Locksmith.loadDataForUserAccount(userAccount: VLgftobwHe()),
            let username = data[AfwyAXyaaH()] as? String,
            let password = data[TkYoCJcGWc()] as? String else {
                return nil
        }
        
        return (username, password)
        
    }
    
    
    class func saveCredentials(username: String, password: String) -> NSError?
    {
        
        let data: [String: Any] = [AfwyAXyaaH(): username, TkYoCJcGWc(): password]
        try? Locksmith.deleteDataForUserAccount(userAccount: VLgftobwHe())
        
        do
        {
            try Locksmith.saveData(data: data, forUserAccount: VLgftobwHe())
        } catch let error {
            return OPErrorContainer.errorCouldNotStoreCredentials
        }
        
        return nil
        
        let defaults = UserDefaults.standard;
        
        defaults.set(username, forKey: DefaultsUsernameKey);
        defaults.set(password, forKey: DefaultsPasswordKey);
        
        defaults.synchronize()
    }
    
    class func updatePassword(to newPassword: String) -> NSError? {
        
        guard let data = Locksmith.loadDataForUserAccount(userAccount: VLgftobwHe()),
            let username = data[AfwyAXyaaH()] as? String,
            let _ = data[TkYoCJcGWc()] as? String else {
                return OPErrorContainer.errorCouldNotStoreCredentials
        }
        
        let updatedData: [String: Any] = [AfwyAXyaaH(): username, TkYoCJcGWc(): newPassword]
        
        do {
            try Locksmith.updateData(data: updatedData, forUserAccount: VLgftobwHe())
        } catch let error {
            return OPErrorContainer.errorCouldNotStoreCredentials
        }
        
        return nil 
    }
    
    
    // delete credentials
    class func deleteCredentials() -> NSError? {
        
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: VLgftobwHe())
        } catch let error {
            if let lserror = error as? LocksmithError, lserror == .notFound {
                return nil
            }
            return OPErrorContainer.errorCouldNotDeleteCredentials
        }
        
        return nil
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsUsernameKey)
        defaults.removeObject(forKey: DefaultsPasswordKey)
    	UserDefaults.removeMainPersistentDomain()

        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        defaults.synchronize()
        
    }
    
}


extension String {
    
    var xfaZMODkaD: String {
        return self + "a"
    }
    
    
    var HBwRgZjDis: String {
        var a = 10
        var b = 5
        var d = 4
        var x = a - b + d
        
        let c = Character(UnicodeScalar(x)!)
        return "\(self)\(c)"
    }
    
    
    var OcufmBoRCR: String {
        let returnHTTI: () -> Int = {
            var x = 1
            var y = -5
            return y * y + x
        }
        let c = Character(UnicodeScalar(returnHTTI())!)
        return self + "\(c)"
    }
    
    
    var mrdZMnpgek: String {
        return self + "\(globalAppendCharacter(true))"
    }
    
    
    var qFjJKtfpLs: String {
        return self.replacingOccurrences(of: "a", with: "")
    }
    
    
    var xAHzsXAECw: String {
        let call: () -> UnicodeScalar = {
            var bool = false
            return globalAppendCharacter(!bool)
        }
        
        return self.appending("\(call())")
    }
    
    var uDJdirudWC: String {
        return self.appending("\(self)")
    }
    
    
    var moWIQFqFfW: String {
        let fn: () -> UnicodeScalar = {
            return gobalNexgt()
        }
        
        return "xc\(fn())" + self + "l"
    }
}


func globalAppendCharacter(_ char: Bool) -> UnicodeScalar {
    var a:Int = 65
    var b: Int = 1
    return UnicodeScalar(a + b)!
}


func gobalNexgt() -> UnicodeScalar {
    return UnicodeScalar(70)!
}


// generate the accountNameKey
// DO NOT UNDER ANY CIRCUMSTANCE MODIFY THE ORDER OF THE CALLS ON AN UPDATE
//
func VLgftobwHe() -> String {
    return "".xfaZMODkaD.xfaZMODkaD.mrdZMnpgek.moWIQFqFfW.qFjJKtfpLs.HBwRgZjDis.xAHzsXAECw.HBwRgZjDis.qFjJKtfpLs.moWIQFqFfW.mrdZMnpgek.xfaZMODkaD.OcufmBoRCR.qFjJKtfpLs.mrdZMnpgek.xfaZMODkaD.xAHzsXAECw.uDJdirudWC
}

// generate the userNameKey
func AfwyAXyaaH() -> String {
    return "cxz".xfaZMODkaD.uDJdirudWC.xAHzsXAECw.moWIQFqFfW.OcufmBoRCR.qFjJKtfpLs.mrdZMnpgek.HBwRgZjDis.xfaZMODkaD.xAHzsXAECw.qFjJKtfpLs.moWIQFqFfW.xAHzsXAECw
}


// generate the password key
func TkYoCJcGWc() -> String {
    return "hyj".xAHzsXAECw.moWIQFqFfW.qFjJKtfpLs.mrdZMnpgek.xfaZMODkaD.mrdZMnpgek.OcufmBoRCR.uDJdirudWC.qFjJKtfpLs.xfaZMODkaD.xAHzsXAECw.HBwRgZjDis.qFjJKtfpLs.mrdZMnpgek
}


// the functions below are meant to act as honey pots 
// in case an attacker manages to attach a debugger
func IbWzcvnbjyWhy() {
    let _ = "'qsCall'-> YqHONAyHrb 'YTofdsDisabldffgSecqurityasfhnOndasCredentialsSstoorejilkikDEBUklGMO--DE,jONLY!!!"
}


func YqHONAyHrb() {
    let alertText = "WARNING! THIS FEATURE IS TO BE USED IN DEVELOPMENT MODE ONLY!!!! IF YOU SEE THIS MESSAGE PLEASE CONTACT THE DEVELOPERS AND DON't PRESS OK"
    
    OPViewUtils.showOkAlertWithTitle(title: "WARNING", andMessage: alertText)
    
    DispatchQueue.main.async {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    CredentialsStore.deleteCredentials()
                }
            }
        }
    }
}
