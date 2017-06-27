//
//  UILeftSideMenuViewController+DataSource.swift
//  Operando
//
//  Created by Cătălin Pomîrleanu on 20/10/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kDashboardLocalizableKey = "kDashboardLocalizableKey"


extension UILeftSideMenuViewController {
    
    struct UILeftSideMenuVCObject {
        var categoryImageName: String
        var categoryName: String
        var action: (() -> Void)?
    }

    func getMenuDataSource() -> [UILeftSideMenuVCObject] {
        
        var result = [UILeftSideMenuVCObject]()
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "home-blue", categoryName: Bundle.localizedStringFor(key: kDashboardLocalizableKey), action: self.callbacks?.whenChoosingHome))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "identities-green", categoryName: Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingIdentitiesManagement))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "deals-red", categoryName: Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingPrivacyForBenefits))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "private_browsing-orange", categoryName: Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingPrivateBrowsing))
        
        result.append(UILeftSideMenuVCObject(categoryImageName: "notifications-light-green", categoryName: Bundle.localizedStringFor(key: kNotificationsLocalizableKey), action: self.callbacks?.dashboardCallbacks?.whenChoosingNotifications))
        
//        result.append(UILeftSideMenuVCObject(categoryImageName: "notifications-light-green", categoryName: "Monitor", action: self.callbacks?.whenChoosingMonitor))
        
        
        return result
    }
}
