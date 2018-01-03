//
//  UIIdentityCell.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


struct UIIdentityCellStyle {
    let backgroundColor: UIColor?
    let textColor: UIColor?
    let displaysDisclosureIcon: Bool
    let displaysDefaultIdentityIcon: Bool
    
    
    static let normal = UIIdentityCellStyle(backgroundColor: UIColor.operandoYellow,
                                            textColor: UIColor.black,
                                            displaysDisclosureIcon: true,
                                            displaysDefaultIdentityIcon: false)
    
    static let selected = UIIdentityCellStyle(backgroundColor: UIColor.operandoDarkYellow,
                                              textColor: UIColor.operandoLightBrown,
                                              displaysDisclosureIcon: false,
                                              displaysDefaultIdentityIcon: true)
}

class UIIdentityCell: MGSwipeTableCell {
    
    static let identifierNibName = "UIIdentityCell"
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
        
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var topSeparator: UIView!
    
    @IBOutlet weak var rightSeparator: UIView!
    @IBOutlet weak var leftSeparator: UIView!
    
    func setupWithIdentity(identity: String?, style: UIIdentityCellStyle) {
        
        if style.displaysDefaultIdentityIcon == true {
            self.checkmarkImageView.image = #imageLiteral(resourceName: "default_enabled")
            topSeparator.isHidden = false
            bottomSeparator.isHidden = false
            rightSeparator.isHidden = false
            leftSeparator.isHidden = false
        }
        else {
            self.checkmarkImageView.image = #imageLiteral(resourceName: "default_disabled")
            topSeparator.isHidden = true
            bottomSeparator.isHidden = true
            rightSeparator.isHidden = true
            leftSeparator.isHidden = true
        }
        
//        self.checkmarkImageView.isHidden = !style.displaysDefaultIdentityIcon
//        self.disclosureImageView.isHidden = !style.displaysDisclosureIcon
        
//        self.contentView.backgroundColor = style.backgroundColor
//        self.textLabel?.textColor = style.textColor
        
        self.identityLabel.text = identity
        
    }
    
    
    //Mark:
    
}
