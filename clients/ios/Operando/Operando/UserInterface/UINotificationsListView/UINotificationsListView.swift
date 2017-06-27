//
//  UINotificationsListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kDismissLocalizableKey = "kDismissLocalizableKey"
let kNoNotificationsLocalizableKey = "kNoNotificationsLocalizableKey"

struct UINotificationsListViewCallbacks {
    let whenDismissingNotificationAtIndex: ((_ notification: OPNotification, _ index: Int) -> Void)?
    let whenActingUponNotification: NotificationActionCallback?
}

class UINotificationsListView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate {

    

    
    private var notifications: [OPNotification] = []
    private var callbacks: UINotificationsListViewCallbacks?
    
    @IBOutlet weak var noNotificationsLabel: UILabel?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
        self.setupTableView(tableView: self.tableView)
        
        self.noNotificationsLabel?.text = Bundle.localizedStringFor(key: kNoNotificationsLocalizableKey)
        self.noNotificationsLabel?.isHidden = true 
    }
    
    private func setupTableView(tableView: UITableView?){
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 44
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        let nib = UINib(nibName: UINotificationCell.identifierNibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: UINotificationCell.identifierNibName)
        
    }
    
    
    
    func setupWith(initialListOfNotifications: [OPNotification], callbacks: UINotificationsListViewCallbacks?){
        self.notifications = initialListOfNotifications
        self.callbacks = callbacks
        self.tableView.reloadData()
        self.noNotificationsLabel?.isHidden = self.notifications.count > 0
    }
    
    
    func deleteNotification(at index: Int){
        guard index >= 0 && index < self.notifications.count else {
            return
        }
        
        self.notifications.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        self.noNotificationsLabel?.isHidden = self.notifications.count > 0
    }
    
    
    //MARK: TableView 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UINotificationCell.identifierNibName, for: indexPath) as! UINotificationCell
        
        let notification = self.notifications[indexPath.row]
        
        cell.setupWith(notification: notification, andCallback: self.callbacks?.whenActingUponNotification)
        
        weak var weakSelf = self
        
        
        let button = MGSwipeButton(title: "", icon: UIImage(named: "dismiss"), backgroundColor: .operandoRedDismiss, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) { swipeCell -> Bool in
            swipeCell?.hideSwipe(animated: true, completion: { _ in
                guard let maybeChangedIndexPath = weakSelf?.tableView?.indexPath(for: swipeCell!) else {
                    return
                }
                weakSelf?.callbacks?.whenDismissingNotificationAtIndex?(notification, maybeChangedIndexPath.row)
            })
            
            return true

        }

        cell.rightButtons = [button!]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if let cell = tableView.cellForRow(at: indexPath) as? UINotificationCell {
            cell.showSwipe(.rightToLeft, animated: true)
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let notification = self.notifications[indexPath.row]
        var height: CGFloat = 44
        if notification.actions.count > 0 {
            height += 44
        }
        
        let apprxCharsPerLine: CGFloat = 48
        let textHeight: CGFloat = (CGFloat(notification.description.characters.count) / apprxCharsPerLine) * 12
        
        return height + textHeight
    }
    
    
}
