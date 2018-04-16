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
    let whenChoosingFeedbackForm: VoidBlock?
    let logoutCallback: VoidBlock?
    let whenChoosingMyAccount: VoidBlock?
    let whenChoosingAppList: VoidBlock?
}

class UILeftSideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate {
    
    // MARK: - Properties
    var callbacks: UILeftSideMenuViewControllerCallbacks?
    var dataSource: [UILeftSideMenuVCObject]? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.reloadData()
        }
    }
    
    var userInfoRepo: UserInfoRepository?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameSubtitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var signingLabel: UILabel!
    @IBOutlet weak var signingButton: UIButton!
    
    // MARK: - @IBActions
    @IBAction func didTapProfileButton(_ sender: AnyObject) {
//        self.sideMenuViewController?.contentViewController = UIViewControllerFactory.profileNavigationViewController
//        self.sideMenuViewController?.hideMenuViewController()
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        self.callbacks?.logoutCallback?()
    }
    
    // MARK: - Public Methods
    func refreshMenu() {
        dataSource = getMenuDataSource()
        tableView.reloadData()
        signingLabel.text = self.signingTitle()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        signingLabel.text = self.signingTitle()
    }
    
    func setupWith(userInfoRepo: UserInfoRepository?) {
        self.userInfoRepo = userInfoRepo
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControls()
        dataSource = getMenuDataSource()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sideMenuController()?.sideMenu?.delegate = self
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
       
        cell.setup(withObject: UILeftSideMenuTVCellObject(categoryImageName: dataSource[indexPath.row].categoryImageName, title: dataSource[indexPath.row].categoryName, numOfNotificationsRequestCallbackIfAny: nil))
        
        return cell
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let dataSource = dataSource else { return }
        dataSource[indexPath.row].action?()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.nameLabel.text = CredentialsStore.retrieveLastSavedCredentialsIfAny()?.username
        if String.isNullEmptyOrSpace(nameLabel.text) {
            nameSubtitleLabel.text = ""
        } else {
            nameSubtitleLabel.text = Bundle.localizedStringFor(key: "kYourRealIdentityLocalizableKey")
        }
    }
    
    func sideMenuWillClose() {
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        
        return true
    }
    
    func sideMenuDidClose() {

    }
    
    func sideMenuDidOpen() {

    }
}
