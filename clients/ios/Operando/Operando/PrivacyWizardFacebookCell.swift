//
//  PrivacyWizardFacebookCell.swift
//  Operando
//
//  Created by RomSoft on 2/6/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class PrivacyWizardFacebookCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var securedImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupWithSetting(setting: AMPrivacySetting, isRecommendedSelected: Bool){
        self.settingLabel.text = setting.read?.name
        securedImageView.isHidden = true
        
        securedImageView.isHidden = !isRecommendedSelected
        setupMainViewBackgroundColor()
      
    }
    
    
   private func setupMainViewBackgroundColor() {
        switch ACPrivacyWizard.shared.selectedScope {
        case .facebook:
            mainView.backgroundColor = UIColor.fbPrivacyTopBar
            break
        case .linkedIn:
            mainView.backgroundColor = UIColor.lkPrivacyTopBar
            break
        case .twitter:
            mainView.backgroundColor = UIColor.twPrivacyTopBar
            break
        case .googleLogin:
            mainView.backgroundColor = UIColor.goPrivacyTopBar
            break
        default:
            break
        }
    }
    
}
