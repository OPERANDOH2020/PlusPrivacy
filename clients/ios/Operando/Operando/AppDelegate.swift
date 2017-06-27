//
//  AppDelegate.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PPApiHooksCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        OPConfigObject.sharedInstance.applicationDidStartInWindow(window: window)
        self.window = window
        window.makeKeyAndVisible()
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return OPConfigObject.sharedInstance.open(url: url)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return OPConfigObject.sharedInstance.open(url: url)
    }
}

