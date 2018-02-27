//
//  PrivacyWizardFacebookCell.swift
//  Operando
//
//  Created by RomSoft on 2/6/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class PrivacyWizardFacebookCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithSetting(setting: AMRead){
        self.settingLabel.text = setting.name
    }
    
}
