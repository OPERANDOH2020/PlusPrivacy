//
//  UISettingsView.swift
//  Operando
//
//  Created by Costin Andronache on 6/28/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit


struct UISettingsViewOutlets {
    let adblockEnabledSwitch: UISwitch?
    let clearWebsiteDataSwitch: UISwitch?
    let disableWebProtectionSwitch: UISwitch?
    
    static var allDefault: UISettingsViewOutlets {
        return UISettingsViewOutlets(adblockEnabledSwitch: .init(), clearWebsiteDataSwitch: .init(), disableWebProtectionSwitch: .init())
    }
    
    static let allNil: UISettingsViewOutlets = UISettingsViewOutlets(adblockEnabledSwitch: nil, clearWebsiteDataSwitch: nil, disableWebProtectionSwitch: nil)
}

class UISettingsViewLogic: NSObject {
    let outlets: UISettingsViewOutlets
    init(outlets: UISettingsViewOutlets) {
        self.outlets = outlets;
        super.init()
    }
    
    
    var currentSettings: UserSettingsModel {
        return UserSettingsModel(enableAdBlock: outlets.adblockEnabledSwitch?.isOn ?? false,
                                 clearWebsiteDataOnExit: outlets.clearWebsiteDataSwitch?.isOn ?? false,
                                 disableWebsiteProtection: outlets.disableWebProtectionSwitch?.isOn ?? false)
    }
    
    func setupWith(settings: UserSettingsModel){
        outlets.adblockEnabledSwitch?.isOn = settings.enableAdBlock
        outlets.clearWebsiteDataSwitch?.isOn = settings.clearWebsiteDataOnExit
        outlets.disableWebProtectionSwitch?.isOn = settings.disableWebsiteProtection
    }
}

class UISettingsView: RSNibDesignableView {
    @IBOutlet weak var adblockEnabledSwitch: UISwitch!
    @IBOutlet weak var clearWebsiteDataSwitch: UISwitch!
    @IBOutlet weak var disableWebProtectionSwitch: UISwitch!

    lazy var logic: UISettingsViewLogic = {
       return UISettingsViewLogic(outlets: UISettingsViewOutlets(adblockEnabledSwitch: self.adblockEnabledSwitch, clearWebsiteDataSwitch: self.clearWebsiteDataSwitch, disableWebProtectionSwitch: self.disableWebProtectionSwitch))
    }()
    

    
}
