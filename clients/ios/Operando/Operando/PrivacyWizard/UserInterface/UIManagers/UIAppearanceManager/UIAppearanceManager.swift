//
//  UIAppearanceManager.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIAppearanceManager: NSObject {

    static func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        setLightStatusBar()
    }
    
    static func setLightStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
