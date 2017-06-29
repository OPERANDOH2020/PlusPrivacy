//
//  UISettingsView.swift
//  Operando
//
//  Created by Costin Andronache on 6/28/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class UISettingsView: RSNibDesignableView {
    @IBOutlet weak var adblockEnabledSwitch: UISwitch!
    @IBOutlet weak var clearWebsiteDataSwitch: UISwitch!
    @IBOutlet weak var disableWebProtectionSwitch: UISwitch!

    
    
    var currentSettings: UserSettingsModel {
        return UserSettingsModel(enableAdBlock: self.adblockEnabledSwitch.isOn,
                                 clearWebsiteDataOnExit: self.clearWebsiteDataSwitch.isOn,
                                 disableWebsiteProtection: self.disableWebProtectionSwitch.isOn)
    }
    
    func setupWith(settings: UserSettingsModel){
        self.adblockEnabledSwitch.isOn = settings.enableAdBlock
        self.clearWebsiteDataSwitch.isOn = settings.clearWebsiteDataOnExit
        self.disableWebProtectionSwitch.isOn = settings.disableWebsiteProtection
    }
    
}
