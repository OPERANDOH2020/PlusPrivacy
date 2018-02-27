//
//  UINavigationItem+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 06/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

extension UINavigationItem {

    func addCustomBackButton(target: Any?, selector: Selector, tintColor color: UIColor = .white, imageName: String = "back_button") {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35, height: 30)
        button.setImage(UIImage(named: imageName)?.maskWithColor(color: color), for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        self.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
}
