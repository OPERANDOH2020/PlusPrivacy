//
//  UINotificationsListViewLogic.swift
//  Operando
//
//  Created by Costin Andronache on 8/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class DummyNotificationCell: UINotificationCell {
    
    var onSetupWithNotificationAndAction: ((_ notification: OPNotification, _ cb: NotificationActionCallback?) -> Void)?
    
    override func setupWith(notification: OPNotification, andCallback callback: NotificationActionCallback?) {
        self.onSetupWithNotificationAndAction?(notification, callback)
    }
    
    override func hideSwipe(animated: Bool, completion: ((Bool) -> Void)!) {
        completion(true)
    }
}

class DummyTableView: UITableView {
    
    var onRemoveAtIndexes: ((_ indexes: [IndexPath]) -> Void)?
    var indexPathForCell: IndexPath?
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        self.onRemoveAtIndexes?(indexPaths)
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return DummyNotificationCell()
    }
    
    override func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return self.indexPathForCell
    }
}

class UINotificationsListViewLogicTests: XCTestCase {
    
    var testNotification: OPNotification {
        return OPNotification(notificationsSwarmReplyDict: ["notificationId": "1", "title": "title", "description": "description"])!
    }
    
    func test_OnInit_NoNotificationsLabelIsHidden() {
        let outlets: UINotificationsListViewOutlets = .allDefault
        outlets.noNotificationsLabel?.isHidden = false
        let _: UINotificationsListViewLogic = UINotificationsListViewLogic(outlets: outlets)
        XCTAssert(outlets.noNotificationsLabel!.isHidden)
    }
    
    func test_OnSetupWithNoNotifications_NoNotificationsLabelIsShown() {
        let outlets: UINotificationsListViewOutlets = .allDefault
        let logic: UINotificationsListViewLogic = UINotificationsListViewLogic(outlets: outlets)
        
        logic.setupWith(initialListOfNotifications: [], callbacks: nil)
        XCTAssert(!outlets.noNotificationsLabel!.isHidden)
    }
    
    func test_OnRemoveAtIndex_RemovesFromTableView(){
        let notification: OPNotification = self.testNotification
        
        let notifications: [OPNotification] = [notification, notification, notification, notification]
        
        _OnRemoveAtIndex_RemovesFromTableView(notifs: notifications, index: 0)
        _OnRemoveAtIndex_RemovesFromTableView(notifs: notifications, index: 2)
        _OnRemoveAtIndex_RemovesFromTableView(notifs: notifications, index: 1)
    }
    
    func _OnRemoveAtIndex_RemovesFromTableView(notifs: [OPNotification], index: Int) {
        let tv = DummyTableView()
        let outlets: UINotificationsListViewOutlets = UINotificationsListViewOutlets(noNotificationsLabel: nil, tableView: tv)
        let logic: UINotificationsListViewLogic = UINotificationsListViewLogic(outlets: outlets)
        
        let exp = self.expectation(description: "")
        
        tv.onRemoveAtIndexes = { indexes in
            XCTAssert(indexes.first!.row == index)
            exp.fulfill()
        }
        logic.setupWith(initialListOfNotifications: notifs, callbacks: nil)
        logic.deleteNotification(at: index)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_OnDeleteLastNotification_NoNotificationsLabelIsShown() {
        let outlets: UINotificationsListViewOutlets = .allDefault
        let logic: UINotificationsListViewLogic = UINotificationsListViewLogic(outlets: outlets)
        
        logic.setupWith(initialListOfNotifications: [self.testNotification], callbacks: nil)
        logic.deleteNotification(at: 0)
        
        XCTAssert(!outlets.noNotificationsLabel!.isHidden)
    }
    
    func test_OnNotificationDismiss_CallsDismissCallback(){
        _OnNotificationDismiss_CallsDismissCallback(notification: self.testNotification)
    }
    
    func _OnNotificationDismiss_CallsDismissCallback(notification: OPNotification) {
        let tv = DummyTableView()
        let outlets: UINotificationsListViewOutlets = UINotificationsListViewOutlets(noNotificationsLabel: nil, tableView: tv)
        
        let logic: UINotificationsListViewLogic = UINotificationsListViewLogic(outlets: outlets)
        let exp = self.expectation(description: "")
        
        logic.setupWith(initialListOfNotifications: [self.testNotification], callbacks: UINotificationsListViewCallbacks(whenDismissingNotificationAtIndex: { (dismissedNotif, index) in
            XCTAssert(dismissedNotif.id == notification.id)
            exp.fulfill()
        }, whenActingUponNotification: nil))
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = logic.tableView(outlets.tableView!, cellForRowAt: indexPath) as! DummyNotificationCell
        
        tv.indexPathForCell = indexPath
        (cell.rightButtons.first! as! MGSwipeButton).callback(cell)
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    
}
