//
//  UITableView+Utils.swift
//  Operando
//
//  Created by Cristi Sava on 26/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import Foundation

extension UITableView {
    
    func emptyMessage(message:String,vc: UIViewController) {
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: vc.view.bounds.size.width, height: vc.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
}
