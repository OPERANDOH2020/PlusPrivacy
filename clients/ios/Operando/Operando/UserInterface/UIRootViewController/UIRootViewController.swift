//
//  UIRootViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIRootViewControllerCallbacks
{
    let whenMenuButtonPressed: VoidBlock?
    let whenBackButtonPressed: VoidBlock?
    let WhenBackPressOnSettingsView: VoidBlock?
    let whenSettingsButtonPressed: VoidBlock?
}

enum UIRootLeftButtonType {
    case hamburger
    case back
}

class UIRootViewController: UIViewController
{
    
    @IBOutlet weak var topBarLabel: UILabel!
    @IBOutlet weak var mainScreensHostView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    fileprivate var currentlyShownViewController: UIViewController?
    fileprivate var callbacks: UIRootViewControllerCallbacks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    func setupWithCallbacks(_ callbacks: UIRootViewControllerCallbacks?)
    {
        self.callbacks = callbacks
    }
    
    @IBAction func didPressMenuButton(_ sender: UIButton?)
    {
        self.callbacks?.whenMenuButtonPressed?()
    }
    @IBAction func didPressBackButton(_ sender: Any)
    {
        
        if self.topBarLabel.text == "Settings" {
            self.callbacks?.WhenBackPressOnSettingsView?()
        }
        else {
            self.callbacks?.whenBackButtonPressed?()
        }
    }
    
    func showTopBar(hidden: Bool) {
        topBarView?.isHidden = hidden
    }
    
    func reset() {
        self.topBarView.backgroundColor = UIColor.operandoOrange
        self.topBarLabel.text = "PlusPrivacy"
        setupLeftButton(buttonType: .hamburger)
        self.settingsButton.isHidden = true
    }
    
    @IBAction func didPressSettingsButton(_ sender: Any) {
        self.callbacks?.whenSettingsButtonPressed?()
    }
    func setupLeftButton(buttonType: UIRootLeftButtonType) {
        
        if buttonType == .back {
            menuButton.isHidden = true
            backButton.isHidden = false
        }
        else {
            menuButton.isHidden = false
            backButton.isHidden = true
        }
    }
    
    func setupTabViewForSettings(){
        self.topBarLabel.text = "Settings"
        self.setupLeftButton(buttonType: .back)
        self.settingsButton.isHidden = true
    }
    
    func setupTabViewForNotification() {
        self.topBarView.backgroundColor = UIColor.notificationPink()
        self.topBarLabel.text = "Notifications"
    }
    
    func setupTabViewForFBQuestionnaire(){
        
        self.topBarLabel.text = "Facebook privacy settings"
        self.topBarView.backgroundColor = UIColor.fbPrivacyTopBar
    }
    
    func setupTabViewForLinkedinQuestionnaire(){
        
        self.topBarLabel.text = "Linkedin privacy settings"
        self.topBarView.backgroundColor = UIColor.lkPrivacyTopBar
    }
    
    func setupTabViewForTwitterQuestionnaire(){
        self.topBarLabel.text = "Twitter privacy settings"
        self.topBarView.backgroundColor = UIColor.twPrivacyTopBar
    }
    
    func setupTabViewForGoogleQuestionnaire(){
        self.topBarLabel.text = "Google privacy settings"
        self.topBarView.backgroundColor = UIColor.goPrivacyTopBar
    }
    
    func setupTabViewForSocialNetworks() {
        self.topBarView.backgroundColor = UIColor.operandoFBBlue
        self.topBarLabel.text = "Social Networks Settings"
    }
    
    func setupForConnectedAppList(){
        self.topBarLabel.text = "Connected Apps "
        
        self.setupByPrivacyScope()
        
        self.menuButton.isHidden = true
        self.backButton.isHidden = false
    }
    
    private func setupByPrivacyScope() {
        switch ACPrivacyWizard.shared.selectedScope {
        case .facebook:
            self.topBarView.backgroundColor = UIColor.fbPrivacyTopBar
            break
        case .linkedIn:
            self.topBarView.backgroundColor = UIColor.lkPrivacyTopBar
            break
        case .twitter:
            self.topBarView.backgroundColor = UIColor.twPrivacyTopBar
            break
        case .googleLogin:
            self.topBarView.backgroundColor = UIColor.goPrivacyTopBar
            break
        default:
            break
        }
    }
    
    func setupForPermissionsList(){
        self.topBarLabel.text = "Permissions List"
        self.menuButton.isHidden = true
        self.backButton.isHidden = false
        
        self.setupByPrivacyScope()
    }
    
    func setupTabViewForConnectedAppsDashboard() {
        self.topBarView.backgroundColor = UIColor.operandoFBBlue
        self.topBarLabel.text = "Connected Apps"
        self.settingsButton.isHidden = true
        self.menuButton.isHidden = false
        self.backButton.isHidden = true
    }
    
    func setupTabViewForSocialNetworksLogoutDashboard() {
        self.topBarView.backgroundColor = UIColor.operandoFBLightBlue
        self.topBarLabel.text = "Connected Social Networks"
        self.settingsButton.isHidden = true
    }
    
    func setupTabViewForSocialNetworksLogoutDashboardFromAppList() {
        
        self.topBarView.backgroundColor = UIColor.operandoFBLightBlue
        self.topBarLabel.text = "Social network accounts"
        self.settingsButton.isHidden = true
        self.menuButton.isHidden = true
        self.backButton.isHidden = false
    }
    
    func setupTabViewForIdentities() {
        self.topBarView.backgroundColor = UIColor.identitiesBlue()
        self.topBarLabel.text = "Identity Management"
    }
    
    func setupTabViewForPrivateBrowsing() {
        self.topBarLabel.text = "Private browsing"
        self.settingsButton.isHidden = false
    }
    
    func setMainControllerTo(newController: UIViewController)
    {
        let _ = self.view
        
        if let currentlyShownViewController = self.currentlyShownViewController
        {
            self.removeContentController(controller: currentlyShownViewController)
        }
        
        self.addContentController(controller: newController, constrainWithAutolayout: true, inOwnViewSubview: self.mainScreensHostView)
        
        self.currentlyShownViewController = newController
    }
}
