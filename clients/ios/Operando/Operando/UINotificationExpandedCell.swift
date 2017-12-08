//
//  UINotificationExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 12/7/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

protocol UINotificationExpandedCellProtocol {
    func takeAction(notification: OPNotification, cell: UINotificationExpandedCell)
    func dismissAction(notification: OPNotification, cell: UINotificationExpandedCell)
}

class UINotificationExpandedCell: UITableViewCell {

    @IBOutlet weak var cellNotificationTitle: UILabel!
    @IBOutlet weak var cellNotificationDate: UILabel!
    @IBOutlet weak var cellNotificationDescription: UILabel!
    
    static let identifierNibName = "UINotificationExpandedCell"

    var notification: OPNotification?
    var delegate:UINotificationExpandedCellProtocol?
    
    // MARK: - IBActions
    
    @IBAction func pressedTakeAction(_ sender: Any) {
        
        guard let notification = notification else {
            return
        }
        
        delegate?.takeAction(notification: notification, cell: self)
    
    }
    @IBAction func pressedDismissAction(_ sender: Any) {
        
        guard let notification = notification else {
            return
        }
        
        delegate?.dismissAction(notification: notification, cell: self)
    }
    
    // MARK: - Utility Functions
    
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
