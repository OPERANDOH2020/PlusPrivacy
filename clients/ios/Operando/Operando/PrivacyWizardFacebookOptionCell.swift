//
//  PrivacyWizardFacebookOptionCell.swift
//  Operando
//
//  Created by RomSoft on 2/6/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

protocol PrivacyWizardFacebookOptionCellDelegate {
    
    func selectedOption(setting: AMAvailableReadSetting)
}

enum SelectionType {
    case Selected
    case Unselected
    case Recommended
}

class PrivacyWizardFacebookOptionCell: UITableViewCell{
    
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    
    @IBOutlet weak var buttonImageView: UIImageView!
    private var setting: AMAvailableReadSetting?
    
    var delegate:PrivacyWizardFacebookOptionCellDelegate?
    
    var selectedImageType: SelectionType = SelectionType.Recommended {
        didSet {
            self.setupSelectedImage()
        }
    }
    
    func setupWithSetting(setting: AMAvailableReadSetting, recommended: String?){
       
        self.setting = setting
        self.optionName.textColor = UIColor.white
        self.optionName.text = setting.name
        selectedImageType = .Unselected
        
        if let recommendedString = recommended {
            if setting.name == recommendedString.replace(target: "_", withString: " ").capitalized {
                optionName.textColor = UIColor.operandoLightGreen
            }
            if setting.isSelected == true {
                self.selectedImageType = .Selected
            }
        }
    }
    
    private func setupSelectedImage(){
    
        switch self.selectedImageType {
        case .Recommended :
            self.buttonImageView.image = #imageLiteral(resourceName: "checkmark")
            break;
        case .Selected :
            self.buttonImageView.image = #imageLiteral(resourceName: "checkmarkDefault")
            break;
        case .Unselected:
            self.buttonImageView.image = nil
            break
        }
        
    }
    
    @IBAction func pressedButton(_ sender: Any) {
        
        if selectedImageType == .Selected {
            selectedImageType = .Unselected
        }
        else {
            selectedImageType = .Selected
            delegate?.selectedOption(setting: setting!)
            
        }
   
    }
}
