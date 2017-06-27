//
//  NotificationsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol NotificationsRepository {
    func getAllNotifications(in completion: ((_ notifications: [OPNotification], _ error: NSError?) -> Void)?)
    func dismiss(notification: OPNotification, withCompletion completion: CallbackWithError?)
}

class DummyNotificationsRepo: NotificationsRepository{
    
    var notifications: [OPNotification] = []
    
    
    init() {
        self.notifications = DummyNotificationsRepo.createNotifications()
    }
    
    
    func getAllNotifications(in completion: (([OPNotification], NSError?) -> Void)?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            completion?(self.notifications, nil)
        }
    }
    
    func dismiss(notification: OPNotification, withCompletion completion: CallbackWithError?) {
        
        if let index = self.notifications.index(where: { notif -> Bool in
            return notif.id == notification.id
        }) {
            self.notifications.remove(at: index)
        }
        
        completion?(nil)
    }
    
    
    
    private func dummyNotificationDictionary(at i: Int) -> [String: Any] {
        var result: [String: Any] = [:]
        
        let actionsDicts : [[String: String]] = (i%2 == 0) ? [
         ["title": "Action title \(i)",
          "key": "key\(i)"],
         ["title": "Action title 2 \(i)",
            "key": "key\(i)"]] : []
        
        result = ["notificationId": "\(i)",
            "title": "notification \(i)",
            "description": "Description\(i) ".repeated(times: 10 % (i+1)),
            "dismissed": false,
            "actions": actionsDicts]
        
        return result
    }
    
    
    
    
    /*
     guard let id = notificationsSwarmReplyDict["notificationId"] as? String,
     let title = notificationsSwarmReplyDict["title"] as? String,
     let description = notificationsSwarmReplyDict["description"] as? String,
     let dismissed = notificationsSwarmReplyDict["dismissed"] as? Bool
     else {
     return nil
     }
     
     self.id = id
     self.title = title
     self.description = description
     self.dismissed = dismissed
     let actionsAsDicts = notificationsSwarmReplyDict["actions"] as? [[String: String]] ?? []

     
     
     */
    
    
    private static func createNotifications() -> [OPNotification] {
        
        let identityMangementNotif: OPNotification = OPNotification(notificationsSwarmReplyDict: ["notificationId": "1",
                                                                                                  "title": "Identity management",
                                                                                                  "description": "Did you know that you can create up to 20 alternate identities in order to protect your privacy?",
                                                                                                  "dismissed": false,
                                                                                                  "actions": [["title": "Add a new identity", "key": NotificationAction.identitiesMangament.rawValue]]])!
        
        
        let pfbDealsNotif: OPNotification = OPNotification(notificationsSwarmReplyDict: ["notificationId": "2",
                                                                                         "title": "Privacy for benefits",
                                                                                         "description": "Privacy deals enable you to trade some of your privacy for some valuable benefits. Check it out!",
                                                                                          "dismissed": false,
                                                                                         "actions": [["title": "Go to privacy deals",
                                                                                                      "key": NotificationAction.privacyForBenefits.rawValue]]])!
        
        let privateBrowsingNotif: OPNotification = OPNotification(notificationsSwarmReplyDict: ["notificationId": "3",
                                                                                                "title": "Private browsing",
                                                                                                "description": "With Private Browsing you can safely browse the web without having your location known. It's simple!",
                                                                                                "dismissed" : false,
                                                                                                "actions": [["title": "Go to Private Browsing", "key": NotificationAction.privateBrowsing.rawValue]]])!
        
        
        return [identityMangementNotif, pfbDealsNotif, privateBrowsingNotif]
    }
}

extension String {
    func repeated(times: Int) -> String {
        guard times > 0 else {
            return self 
        }
        var result = self
        
        for _ in 1...times {
            result.append(self)
        }
        
        return result
    }
}
