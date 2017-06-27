//
//  UINotificationsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationsViewController: UIViewController {

    
    private var notificationsRepository: NotificationsRepository?
    
    @IBOutlet weak var notificationsListView: UINotificationsListView!
    
    
    
    func setup(with notificationsRepository: NotificationsRepository?, notificationCallback: NotificationActionCallback?){
        let _ = self.view
        self.notificationsRepository = notificationsRepository
        
        notificationsRepository?.getAllNotifications(in: { notifications, error  in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.notificationsListView.setupWith(initialListOfNotifications: notifications, callbacks: self.callbacksFor(notificationsView: self.notificationsListView, including: notificationCallback))
            
        })
        
    }
    
    
    
    private func callbacksFor(notificationsView: UINotificationsListView?, including notificationCallback: NotificationActionCallback?) -> UINotificationsListViewCallbacks? {
        
        weak var weakSelf = self
        weak var weakNotificationsView = notificationsView
        
        return UINotificationsListViewCallbacks(whenDismissingNotificationAtIndex: { notification, index in
            
            weakSelf?.notificationsRepository?.dismiss(notification: notification, withCompletion: { error in
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                weakNotificationsView?.deleteNotification(at: index)
                
            })
            
        }, whenActingUponNotification: notificationCallback)
        
    }

}
