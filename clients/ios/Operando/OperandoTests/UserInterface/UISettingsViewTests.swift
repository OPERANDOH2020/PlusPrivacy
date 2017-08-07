//
//  UISettingsViewTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UISettingsViewTests: XCTestCase {
    
    
    func test_DisplaysSettingsCorrectly() {
        _DisplaysSettingsCorrectly(settings: UserSettingsModel(enableAdBlock: true, clearWebsiteDataOnExit: false, disableWebsiteProtection: false))
        
        _DisplaysSettingsCorrectly(settings: UserSettingsModel(enableAdBlock: false, clearWebsiteDataOnExit: true, disableWebsiteProtection: false))
    }
    
    func _DisplaysSettingsCorrectly(settings: UserSettingsModel) {
        let outlets: UISettingsViewOutlets = .allDefault
        let logic: UISettingsViewLogic = UISettingsViewLogic(outlets: outlets)
        
        logic.setupWith(settings: settings)
        
        XCTAssert(outlets.adblockEnabledSwitch!.isOn == settings.enableAdBlock)
        XCTAssert(outlets.clearWebsiteDataSwitch!.isOn == settings.clearWebsiteDataOnExit)
        XCTAssert(outlets.disableWebProtectionSwitch!.isOn == settings.disableWebsiteProtection)
    }
    
    func _BuildsSettingsCorrectly(settings: UserSettingsModel) {
        let outlets: UISettingsViewOutlets = .allDefault
        let logic: UISettingsViewLogic = UISettingsViewLogic(outlets: outlets)
        
        outlets.adblockEnabledSwitch?.isOn = settings.enableAdBlock
        outlets.clearWebsiteDataSwitch?.isOn = settings.clearWebsiteDataOnExit
        outlets.disableWebProtectionSwitch?.isOn = settings.disableWebsiteProtection
        
        let currentSettings = logic.currentSettings
        XCTAssert(currentSettings == settings)
    }
    
    func test_BuildsSettingsCorrectly(){
        _BuildsSettingsCorrectly(settings: UserSettingsModel(enableAdBlock: false, clearWebsiteDataOnExit: true, disableWebsiteProtection: false))
        _BuildsSettingsCorrectly(settings: UserSettingsModel(enableAdBlock: true, clearWebsiteDataOnExit: false, disableWebsiteProtection: true))
    }
    
}
