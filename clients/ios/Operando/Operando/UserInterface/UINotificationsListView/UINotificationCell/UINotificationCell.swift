//
//  UINotificationCell.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationCell: MGSwipeTableCell {

    static let identifierNibName = "UINotificationCell"
    
    @IBOutlet weak var firstActionButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstActionButton: UIButton!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var secondActionButton: UIButton!
    private var notification: OPNotification?
    private var callback: NotificationActionCallback?
    
    
    func setupWith(notification: OPNotification, andCallback callback: NotificationActionCallback?){
        self.callback = callback
        self.notificationTitleLabel.text = notification.title
        self.notificationTextLabel.text = notification.description
        
        self.notification = notification
        
        if let firstAction = notification.actions.first {
            self.firstActionButton.isHidden = false
            self.firstActionButton.setTitle(firstAction.title, for: .normal)
            self.firstActionButtonHeightConstraint.constant = 34
        }
        
        if notification.actions.count >= 2 {
            self.secondActionButton.isHidden = false
            self.secondActionButton.setTitle(notification.actions[1].title, for: .normal)
        }
        
    }
    
    
    @IBAction func didPressOnFirstAction(_ sender: AnyObject) {
        guard let notif = self.notification,
            let notifAction = notif.actions.first else {
                return
        }
        
        self.callback?(notifAction.actionKey, notif)
    }
    
    
    
    @IBAction func didPressSecondAction(_ sender: AnyObject) {
        guard let notif = self.notification,
            notif.actions.count > 1 else {
                return
        }
        
        let action = notif.actions[1]
        self.callback?(action.actionKey, notif)
        
    }
    
    
    override func awakeFromNib() {
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstActionButton.isHidden = true
        self.secondActionButton.isHidden = true
        self.firstActionButtonHeightConstraint.constant = 0
    }
    
}
