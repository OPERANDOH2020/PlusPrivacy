//
//  UIUserSettingsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/27/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit



class UIUserSettingsViewController: UIViewController {
    
    private var callback: UserSettingsModelUpdateCallback?
    
    @IBOutlet weak var settingsView: UISettingsView!
    
    
    func setupWith(settingsModel: UserSettingsModel, callback: UserSettingsModelUpdateCallback?){
        _ = self.view
        
        self.callback = callback
        self.settingsView.setupWith(settings: settingsModel)
        
    }
    
    
    @IBAction func didPressApply(_ sender: Any) {
        self.callback?(self.settingsView.currentSettings)
        RSCommonUtilities.showOKAlertWithMessage(message: "Done")
    }
    
}
