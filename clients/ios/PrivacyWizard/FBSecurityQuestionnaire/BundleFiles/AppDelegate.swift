//
//  AppDelegate.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupFlowController()
        UIAppearanceManager.setupAppearance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Private Methods
    private func setupFlowController() {
        let flowConfiguration = UIFlowConfiguration(window: window, navigationController: nil, parent: nil)
        let mainFlow = UIMainFlowController(configuration: flowConfiguration)
        mainFlow.start()
    }
}

