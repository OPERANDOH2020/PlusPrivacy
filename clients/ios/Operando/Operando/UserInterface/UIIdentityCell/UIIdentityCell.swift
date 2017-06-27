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
        
    func setupWithIdentity(identity: String?, style: UIIdentityCellStyle)
    {
        self.checkmarkImageView.isHidden = !style.displaysDefaultIdentityIcon
        self.disclosureImageView.isHidden = !style.displaysDisclosureIcon
        
        self.contentView.backgroundColor = style.backgroundColor
        self.textLabel?.textColor = style.textColor
        
        self.identityLabel.text = identity
        
    }
    
    
    //Mark:
    
}
