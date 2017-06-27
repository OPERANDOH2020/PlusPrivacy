//
//  UILabel+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 17/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

extension UILabel {

    static func heightForView(text: String, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}
