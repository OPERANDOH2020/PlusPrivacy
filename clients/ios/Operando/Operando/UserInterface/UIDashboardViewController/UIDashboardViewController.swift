//
//  UIDashboardViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIDashBoardViewControllerCallbacks
{
    let whenChoosingIdentitiesManagement: VoidBlock?
    let whenChoosingPrivacyForBenefits: VoidBlock?
    let whenChoosingPrivateBrowsing: VoidBlock?
    let whenChoosingNotifications: VoidBlock?
    let numOfNotificationsRequestCallback: NumOfNotificationsRequestCallback?
}

let kIdentitiesManagementLocalizableKey = "kIdentitiesManagementLocalizableKey"
let kPrivacyForBenefitsLocalizableKey = "kPrivacyForBenefitsLocalizableKey"
let kPrivateBrowsingLocalizableKey = "kPrivateBrowsingLocalizableKey"
let kNotificationsLocalizableKey = "kNotificationsLocalizableKey"

class UIDashboardViewController: UIViewController
{
    
    @IBOutlet var identityManagementButton: UIDashboardButton?
    @IBOutlet var privacyForBenefitsButton: UIDashboardButton?
    @IBOutlet var privateBrowsingButton: UIDashboardButton?
    @IBOutlet var notificationsButton: UIDashboardButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.view.window != nil {
            self.notificationsButton?.updateNotificationsCountLabel()
        }
    }
    
    func setupWith(callbacks: UIDashBoardViewControllerCallbacks?)
    {
        let _ = self.view
    
        self.identityManagementButton?.setupWith(model: UIDashboardButtonModel(style: .identityManagementStyle, notificationsRequestCallbackIfAny: nil, onTap: callbacks?.whenChoosingIdentitiesManagement))
        
        self.privacyForBenefitsButton?.setupWith(model: UIDashboardButtonModel(style: .privacyForBenefitsStyle, notificationsRequestCallbackIfAny: nil, onTap: callbacks?.whenChoosingPrivacyForBenefits))
        
        self.privateBrowsingButton?.setupWith(model: UIDashboardButtonModel(style: .privateBrowsingStyle, notificationsRequestCallbackIfAny: nil, onTap: callbacks?.whenChoosingPrivateBrowsing))
        
        
        self.notificationsButton?.setupWith(model: UIDashboardButtonModel(style: .notificationsStyle, notificationsRequestCallbackIfAny: callbacks?.numOfNotificationsRequestCallback, onTap: callbacks?.whenChoosingNotifications))
        
    }
    
    

}
