//
//  UILeftSideMenuViewController.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let UILeftSideMenuViewControllerStoryboardId = "UILeftSideMenuViewControllerStoryboardId"

struct UILeftSideMenuViewControllerCallbacks {
    let dashboardCallbacks: UIDashBoardViewControllerCallbacks?
    let whenChoosingHome: VoidBlock?
    let whenChoosingMonitor: VoidBlock?
    let whenChoosingSettings: VoidBlock?
    let whenChoosingPrivacyPolicy: VoidBlock?
    let whenChoosingAbout: VoidBlock?
    let logoutCallback: VoidBlock?
}

class UILeftSideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var callbacks: UILeftSideMenuViewControllerCallbacks?
    var dataSource: [UILeftSideMenuVCObject]? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.reloadData()
        }
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoView: UIImageView!
    
    // MARK: - @IBActions
    @IBAction func didTapProfileButton(_ sender: AnyObject) {
//        self.sideMenuViewController?.contentViewController = UIViewControllerFactory.profileNavigationViewController
        self.sideMenuViewController?.hideMenuViewController()
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        self.callbacks?.logoutCallback?()
    }
    // MARK: - Private Methods
    private func setupControls() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControls()
        dataSource = getMenuDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logoView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Table View Data Source
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UILeftSideMenuTableViewCellIdentifier, for: indexPath) as! UILeftSideMenuTableViewCell
        
        guard let dataSource = dataSource else { return cell }
        
        let indexOfNotificationsCell = 4
        let numOfNotificationsRequest: NumOfNotificationsRequestCallback? = indexPath.row ==  indexOfNotificationsCell ? self.callbacks?.dashboardCallbacks?.numOfNotificationsRequestCallback : nil
        cell.setup(withObject: UILeftSideMenuTVCellObject(categoryImageName: dataSource[indexPath.row].categoryImageName, title: dataSource[indexPath.row].categoryName, numOfNotificationsRequestCallbackIfAny: numOfNotificationsRequest))
        
        return cell
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dataSource = dataSource else { return }
        dataSource[indexPath.row].action?()
    }
}
