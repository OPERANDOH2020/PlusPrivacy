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
    case RecommendedSelected
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
        
        if let recommendedString = recommended,
            setting.name == recommendedString.replace(target: "_", withString: " ").capitalized {
            
            if setting.isSelected == true {
                self.selectedImageType = .RecommendedSelected
            }
            else {
                self.selectedImageType = .Recommended
            }
            
        }
        else if setting.isSelected == true {
            self.selectedImageType = .Selected
        }
        
    }
    
    
    private func setupSelectedImage(){
        
        switch self.selectedImageType {
        case .Recommended :
            self.buttonImageView.image = #imageLiteral(resourceName: "recommended")
            break;
        case .Selected :
            self.buttonImageView.image = #imageLiteral(resourceName: "not_recommended_selected")
            break;
        case .Unselected:
            self.buttonImageView.image = #imageLiteral(resourceName: "not_selected")
            break
        case .RecommendedSelected:
            self.buttonImageView.image = #imageLiteral(resourceName: "recommended_selected")
            break
        }
    }
    
    @IBAction func pressedButton(_ sender: Any) {
        
        if selectedImageType == .Unselected{
            selectedImageType = .Selected
              delegate?.selectedOption(setting: setting!)
        }
        else if selectedImageType == .Recommended {
            delegate?.selectedOption(setting: setting!)
        }
        
    }
}
