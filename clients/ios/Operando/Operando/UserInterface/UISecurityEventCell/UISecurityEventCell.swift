//
//  UISecurityEventCell.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit



class UISecurityEventCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var securityEventTypeView: UISecurityEventTypeView!
    
    static let idenitiferNibName = "UISecurityEventCell";
    
    func setupWithSecurityEvent(securityEvent: SecurityEventProtocol)
    {
        self.titleLabel?.text = securityEvent.title
        self.securityEventTypeView.displaySecurityEventType(securityEvent.securityEventTag);
    }
}
