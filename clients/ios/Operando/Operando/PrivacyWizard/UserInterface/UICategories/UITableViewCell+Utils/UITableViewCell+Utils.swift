//
//  UITableViewCell+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 06/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let CustomSeparatorViewHeight : CGFloat = 0.1
let CustomSeparatorViewTag = 943472

extension UITableViewCell {
    
    func addCustomSeparatorView(color: UIColor = UIColor.black) {
        removeCustomSeparatorView()
        
        let separatorView = UIView(frame: CGRect(x: 0.0, y: contentView.frame.height - CustomSeparatorViewHeight, width: contentView.frame.width, height: CustomSeparatorViewHeight))
        separatorView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        separatorView.backgroundColor = color
        contentView.addSubview(separatorView)
    }
    
    func removeCustomSeparatorView() {
        contentView.viewWithTag(CustomSeparatorViewTag)?.removeFromSuperview()
    }
}
