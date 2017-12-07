//
//  UINotificationCell.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationCell: UITableViewCell {

    static let identifierNibName = "UINotificationCell"
    
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!

    func setupWithTitle(title: String, date: Date?) {
        notificationTitleLabel.text = title
    }
}
