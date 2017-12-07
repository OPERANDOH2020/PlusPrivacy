//
//  UINotificationExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 12/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class UINotificationExpandedCell: UITableViewCell {

    @IBOutlet weak var cellNotificationTitle: UILabel!
    @IBOutlet weak var cellNotificationDate: UILabel!
    @IBOutlet weak var cellNotificationDescription: UILabel!
    
    static let identifierNibName = "UINotificationExpandedCell"

    var notification: OPNotification?
    
    @IBAction func pressedTakeAction(_ sender: Any) {
    
    }
    @IBAction func pressedDismissAction(_ sender: Any) {
        
    }
    
    func setupWithTitle(notification: OPNotification) {
        
        self.notification = notification
        
        cellNotificationTitle.text = notification.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, d"
        if let date = notification.date {
            cellNotificationDate.text = dateFormatter.string(from: date)
        }
        
        cellNotificationDescription.text = notification.description
    }
}
