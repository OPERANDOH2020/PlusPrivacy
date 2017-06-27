//
//  UIUserSettingsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/27/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

typealias UserSettingsModelUpdateCallback = (_ settingsModel: UserSettingsModel) -> Void

class UIUserSettingsViewController: UITableViewController {
    
    private var callback: UserSettingsModelUpdateCallback?
    
    func setupWith(settingsModel: UserSettingsModel, callback: UserSettingsModelUpdateCallback?){
        self.callback = callback
        
        
    }
    
    
    
}
