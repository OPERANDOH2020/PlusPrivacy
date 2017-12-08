//
//  UINotificationsListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


struct UINotificationsListViewCallbacks {
    let whenDismissingNotificationAtIndex: ((_ notification: OPNotification, _ index: Int) -> Void)?
    let whenActingUponNotification: NotificationActionCallback?
}

struct UINotificationsListViewOutlets {
    let noNotificationsLabel: UILabel?
    let tableView: UITableView?
    
    static var allDefault: UINotificationsListViewOutlets {
        return UINotificationsListViewOutlets(noNotificationsLabel: .init(), tableView: .init())
    }
    
    static let allNil: UINotificationsListViewOutlets = UINotificationsListViewOutlets(noNotificationsLabel: nil, tableView: nil)
}

class UINotificationsListViewLogic: NSObject, UITableViewDelegate, UITableViewDataSource, UINotificationExpandedCellProtocol {
    
    private var notifications: [OPNotification] = []
    private var callbacks: UINotificationsListViewCallbacks?
    
    private var selectedIndexPath: IndexPath?
    
    let outlets: UINotificationsListViewOutlets
    init(outlets: UINotificationsListViewOutlets) {
        self.outlets = outlets;
        super.init()
        self.commonInit()
    }
    
    private func commonInit() {
        self.setupTableView(tableView: self.outlets.tableView)
        
        self.outlets.noNotificationsLabel?.text = Bundle.localizedStringFor(key: kNoNotificationsLocalizableKey)
        self.outlets.noNotificationsLabel?.isHidden = true
    }
    
    private func setupTableView(tableView: UITableView?){
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 44
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        let nib = UINib(nibName: UINotificationCell.identifierNibName, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: UINotificationCell.identifierNibName)
        
        let nib2 = UINib(nibName: UINotificationExpandedCell.identifierNibName, bundle: nil)
        tableView?.register(nib2, forCellReuseIdentifier: UINotificationExpandedCell.identifierNibName)
        
    }
    
    func setupWith(initialListOfNotifications: [OPNotification], callbacks: UINotificationsListViewCallbacks?){
        self.notifications = initialListOfNotifications
        self.callbacks = callbacks
        self.outlets.tableView?.reloadData()
        self.outlets.noNotificationsLabel?.isHidden = self.notifications.count > 0
    }
    
    
    func deleteNotification(at index: Int){
        guard index >= 0 && index < self.notifications.count else {
            return
        }
        
        self.notifications.remove(at: index)
        self.outlets.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        
        self.outlets.noNotificationsLabel?.isHidden = self.notifications.count > 0
    }
    
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notification = self.notifications[indexPath.row]
        
        if let selectedIndex = self.selectedIndexPath,
            selectedIndexPath == indexPath {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UINotificationExpandedCell.identifierNibName, for: indexPath) as! UINotificationExpandedCell
            
            cell.delegate = self
            cell.setupWithTitle(notification: notification)
            
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UINotificationCell.identifierNibName, for: indexPath) as! UINotificationCell
            
            cell.setupWithTitle(title: notification.title, date: notification.date)
            
            return cell
        }
        
        
        
//        let notification = self.notifications[indexPath.row]
        
//        weak var weakSelf = self
//
//
//        let button = MGSwipeButton(title: "", icon: UIImage(named: "dismiss"), backgroundColor: .operandoRedDismiss, insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) { swipeCell -> Bool in
//            swipeCell?.hideSwipe(animated: true, completion: { _ in
//                guard let maybeChangedIndexPath = weakSelf?.outlets.tableView?.indexPath(for: swipeCell!) else {
//                    return
//                }
//                weakSelf?.callbacks?.whenDismissingNotificationAtIndex?(notification, maybeChangedIndexPath.row)
//            })
//
//            return true
//
//        }
        
//        cell.rightButtons = [button!]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedIndexPath == indexPath {
            return
        }
        
        
        self.selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if selectedIndexPath == indexPath {
//            return 185 + calculateHeightOfText(indexPath: indexPath)
//        }
//
//        return 70
//    }
    
    private func calculateHeightOfText(indexPath: IndexPath) -> CGFloat {
        
        let notification = self.notifications[indexPath.row]
        let apprxCharsPerLine: CGFloat = 48
        let textHeight: CGFloat = (CGFloat(notification.description.characters.count) / apprxCharsPerLine) * 12
        
        return textHeight
    }
    
    // MARK: - UINotificationExpandedCellProtocol
    
    func takeAction(notification: OPNotification, cell: UINotificationExpandedCell) {
         weak var weakSelf = self
        
        if let action = notification.actions.first?.actionKey {
            weakSelf?.callbacks?.whenActingUponNotification?(action,notification)
        }
    }
    
    func dismissAction(notification: OPNotification, cell: UINotificationExpandedCell) {
        
        weak var weakSelf = self
        
        guard let maybeChangedIndexPath = weakSelf?.outlets.tableView?.indexPath(for: cell) else {
            return
        }
      weakSelf?.callbacks?.whenDismissingNotificationAtIndex?(notification, maybeChangedIndexPath.row)
    }
    
}

class UINotificationsListView: RSNibDesignableView {

    @IBOutlet weak var noNotificationsLabel: UILabel?
    @IBOutlet weak var tableView: UITableView!
    private(set) lazy var logic: UINotificationsListViewLogic = {
       let outlets = UINotificationsListViewOutlets(noNotificationsLabel: self.noNotificationsLabel, tableView: self.tableView)
        return UINotificationsListViewLogic(outlets: outlets)
    }()
    
}
