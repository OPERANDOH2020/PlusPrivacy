//
//  UISNSettingsTableViewCell.swift
//  Operando
//
//  Created by Costin Andronache on 8/12/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISNSettingsTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupWithSNSettingsDict(snSettings: NSDictionary)
    {
        let firstKey = snSettings.allKeys.first
        let firstValue = snSettings.objectForKey(firstKey ?? "")
        
        self.titleLabel.text = firstKey as? String ?? "N/A"
        self.valueLabel.text = firstValue as? String ?? "N/A"
    }
    
    static var identifierNibName: String
    {
        return "UISNSettingsTableViewCell"
    }
}
