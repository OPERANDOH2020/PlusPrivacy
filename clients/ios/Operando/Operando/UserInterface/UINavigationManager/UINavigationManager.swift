//
//  UINavigationManager.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

class UINavigationManager
{
    static let main = UIStoryboard(name: "Main", bundle: nil);
    static let utility = UIStoryboard(name: "UtilityControllers", bundle: nil)
    static let leftMenu = UIStoryboard(name: "LeftMenu", bundle: nil)
    static let cloak = UIStoryboard(name: "Cloak", bundle: nil)
    
    static var rootViewController : UIRootViewController{
        return main.instantiateViewController(withIdentifier: "UIRootViewController") as! UIRootViewController
    }
    
    static var sensorMonitoringViewController: UISensorMonitoringViewController{
        return main.instantiateViewController(withIdentifier: "UISensorMonitoringViewController") as! UISensorMonitoringViewController;
    }
    
    static var notificationsViewController: UINotificationsViewController{
        return main.instantiateViewController(withIdentifier: "UINotificationsViewController") as! UINotificationsViewController
    }
    

    static var identityManagementViewController : UIIdentityManagementViewController{
        return main.instantiateViewController(withIdentifier: "UIIdentityManagementViewController") as! UIIdentityManagementViewController
    }
    
    static var dashboardViewController: UIDashboardViewController{
        return main.instantiateViewController(withIdentifier: "UIDashboardViewController") as! UIDashboardViewController
    }
    
    
    static var privateBrowsingViewController: UIPrivateBrowsingViewController{
        return main.instantiateViewController(withIdentifier: "UIPrivateBrowsingViewController") as! UIPrivateBrowsingViewController
    }
    
    static var loginViewController: UISignInViewController{
        return main.instantiateViewController(withIdentifier: "UISignInViewController") as! UISignInViewController
    }
    
    
    static var registerViewController: UIRegistrationViewController{
        return main.instantiateViewController(withIdentifier: "UIRegistrationViewController") as! UIRegistrationViewController
    }
    
    
    static var addIdentityController: UIAddIdentityAlertViewController {
        return utility.instantiateViewController(withIdentifier: "UIAddIdentityAlertViewController") as! UIAddIdentityAlertViewController
    }
    
    static var pfbDealsController: UIPfbDealsViewController{
        return main.instantiateViewController(withIdentifier: "UIPfbDealsViewController") as! UIPfbDealsViewController
    }
    
    static var pfbDealDetailsAlertViewController: UIPfbDetailsAlertViewController {
        return utility.instantiateViewController(withIdentifier: "UIPfbDetailsAlertViewController") as! UIPfbDetailsAlertViewController
    }
    
    // MARK: - Left Menu Storyboard
    static var leftMenuViewController: UILeftSideMenuViewController {
        return leftMenu.instantiateViewController(withIdentifier: "UILeftSideMenuViewControllerStoryboardId") as! UILeftSideMenuViewController
    }
    
    static var accountViewController: UIAccountViewController {
        return leftMenu.instantiateViewController(withIdentifier: "UIAccountViewController") as! UIAccountViewController
    }
    
    
    
}
