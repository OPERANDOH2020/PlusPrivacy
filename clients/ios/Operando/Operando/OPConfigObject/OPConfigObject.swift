//
//  OPConfigObject.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class OPConfigObject: NSObject
{
    static let sharedInstance = OPConfigObject()
    
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private let cdRepository = CoreDataRepository()
    private let backgroundScanner = BackgroundConnectionsScanner()
    
    
    func getCurrentUserIdentityIfAny() -> UserIdentityModel?
    {
        return self.currentUserIdentity
    }
    
    func getCurrentConnectionReportsProvider() -> ConnectionReportsProvider?
    {
        return self.cdRepository
    }
    
    func applicationDidStartInWindow(window: UIWindow)
    {
        let rootController = UINavigationManager.rootViewController;
        window.rootViewController = rootController
        
        self.backgroundScanner.beginScanningProcessWithSource(self.cdRepository);

        if let (username, password) = CredentialsStore.retrieveLastSavedCredentialsIfAny()
        {
            weak var weakSelf = self
            self.swarmClientHelper.loginWithUsername(username, password: password, withCompletion: { (error, data) in
                defer
                {
                    rootController.beginDisplayingUI()
                }
                
                guard error == nil else {return}
                weakSelf?.currentUserIdentity = UserIdentityModel(username: username, password: password)
            })
        }
        else
        {
            rootController.beginDisplayingUI()
        }
    }
    
    
    func loginUserWithInfo(loginInfo: LoginInfo, withCompletion completion: ((error: NSError?, identity: UserIdentityModel?) -> Void))
    {
        weak var weakSelf = self
        self.swarmClientHelper.loginWithUsername(loginInfo.username, password: loginInfo.password) { (error, data) in
            guard error == nil else
            {
                completion(error: error, identity: nil)
                return;
            }
            
            if loginInfo.wishesToBeRemembered
            {
                CredentialsStore.saveCredentials(loginInfo.username, password: loginInfo.password)
            }
            
            weakSelf?.currentUserIdentity = UserIdentityModel(username: loginInfo.username, password: loginInfo.password);
            completion(error: nil, identity: weakSelf?.currentUserIdentity)
            
        }
    }
}
