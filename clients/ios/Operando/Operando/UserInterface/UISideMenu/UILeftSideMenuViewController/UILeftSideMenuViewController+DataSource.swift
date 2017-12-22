//
//  UILeftSideMenuViewController+DataSource.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


extension UILeftSideMenuViewController {
    
    struct UILeftSideMenuVCObject {
        var categoryImageName: String
        var categoryName: String
        var action: (() -> Void)?
    }
    
    func getRealIdentity(completion: ((String, NSError?) -> Void)?) {
        let swarm = SwarmClientHelper()
        swarm.getRealIdentityWith { (identity, error) in

            print(identity)
//            completion((identity,error))
        }
    }

    func getMenuDataSource() -> [UILeftSideMenuVCObject] {
        
        var result = [UILeftSideMenuVCObject]()
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "dashboard", categoryName: Bundle.localizedStringFor(key: kDashboardLocalizableKey), action: self.callbacks?.whenChoosingHome))
        
//        result.append(UILeftSideMenuVCObject(categoryImageName: "identities-green", categoryName: Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingIdentitiesManagement))
//
//        result.append(UILeftSideMenuVCObject(categoryImageName: "deals-red", categoryName: Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingPrivacyForBenefits))
        
//        result.append(UILeftSideMenuVCObject(categoryImageName: "private_browsing-orange", categoryName: Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingPrivateBrowsing))
//        
//        result.append(UILeftSideMenuVCObject(categoryImageName: "notifications-light-green", categoryName: Bundle.localizedStringFor(key: kNotificationsLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingNotifications))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "settings", categoryName: Bundle.localizedStringFor(key: kSettingsLocalizableKey), action: self.callbacks?.whenChoosingSettings))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "osdk", categoryName: Bundle.localizedStringFor(key: kResearchOSDKLocalizableKey), action: self.callbacks?.whenChoosingMonitor))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "privacy_policy", categoryName: Bundle.localizedStringFor(key: kPrivacyPolicyLocalizableKey), action: self.callbacks?.whenChoosingPrivacyPolicy))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "ic_feedback", categoryName: Bundle.localizedStringFor(key: kFeedBackFormKey), action: self.callbacks?.whenChoosingFeedbackForm))
        
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "about", categoryName: Bundle.localizedStringFor(key: kAboutLocalizableKey), action: self.callbacks?.whenChoosingAbout))
        result.append(UILeftSideMenuVCObject(categoryImageName: "about", categoryName: Bundle.localizedStringFor(key: kAboutLocalizableKey), action: self.callbacks?.whenChoosingMyAccount))
        
        return result
    }
}
