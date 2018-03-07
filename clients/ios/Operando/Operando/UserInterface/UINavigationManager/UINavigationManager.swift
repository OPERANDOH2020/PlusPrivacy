//
//  UIViewControllerFactory.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerFactory
{
    static let privacyWizardSB = UIStoryboard(name: "PrivacyWizard", bundle: nil);
    static let main = UIStoryboard(name: "Main", bundle: nil);
    static let utility = UIStoryboard(name: "UtilityControllers", bundle: nil)
    static let leftMenu = UIStoryboard(name: "LeftMenu", bundle: nil)
    static let cloak = UIStoryboard(name: "Cloak", bundle: nil)
    
    
    fileprivate static func getViewController(_ storyboardName: String, bundle: Bundle?, controllerStoryboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: controllerStoryboardId)
        return viewController
    }
    
    // MARK: - Public Methods
    static func getMainScreenViewController() -> UIMainViewController {
        return privacyWizardSB.instantiateViewController(withIdentifier: UIMainVCStoryboardId) as! UIMainViewController
    }
    
    static func getUISetPrivacyViewController() -> UISetPrivacyViewController {
        return main.instantiateViewController(withIdentifier: UISetPrivacyVCStoryboardId) as! UISetPrivacyViewController
    }
    
    static func getPrivacyWizzardDashboardViewController() -> PrivacyWizzardDashboardViewController {
        return PrivacyWizzardDashboardViewController(nibName: "PrivacyWizzardDashboardViewController", bundle: nil)
    }
    
    static func getFBQuestionnarieViewController() -> PrivacyWizzardFacebookSettingsViewController {
        return PrivacyWizzardFacebookSettingsViewController(nibName: "PrivacyWizzardFacebookSettingsViewController", bundle: nil)
    }
    
    static func getQuestionnaireTableViewController() -> UIQuestionnaireTableViewController {
         return privacyWizardSB.instantiateViewController(withIdentifier:  UIQuestionnaireTVCStoryboardId) as! UIQuestionnaireTableViewController
    }
    
    static func getPrivacySettingViewController() -> UIPrivacySettingViewController {
         return privacyWizardSB.instantiateViewController(withIdentifier:  UIPrivacySettingVCStoryboardId) as! UIPrivacySettingViewController
    }
    
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
    
    static var feedbackFormViewController: OPFeedbackFormViewController {
        return OPFeedbackFormViewController(nibName: "OPFeedbackFormViewController", bundle: nil)
    }
    
    // MARK: - Left Menu Storyboard
    static var leftMenuViewController: UILeftSideMenuViewController {
        return leftMenu.instantiateViewController(withIdentifier: "UILeftSideMenuViewControllerStoryboardId") as! UILeftSideMenuViewController
    }
    
    static var myAccountViewController: UIMyAccountViewController {
        return main.instantiateViewController(withIdentifier: "UIMyAccountViewController") as! UIMyAccountViewController
    }
    
    static var accountViewController: UIAccountViewController {
        return leftMenu.instantiateViewController(withIdentifier: "UIAccountViewController") as! UIAccountViewController
    }
    
    static var privacyPolicyController: UIPrivacyPolicyViewController {
        return utility.instantiateViewController(withIdentifier: "UIPrivacyPolicyViewController") as! UIPrivacyPolicyViewController
    }
    
    static var aboutViewController: UIViewController {
        return utility.instantiateViewController(withIdentifier: "AboutViewController")
    }
    
    static var settingsViewController: UIUserSettingsViewController {
        return utility.instantiateViewController(withIdentifier: "UIUserSettingsViewController") as! UIUserSettingsViewController
    }
    
    static var notAvailableViewController: UINotAvailableViewController {
        return utility.instantiateViewController(withIdentifier: "UINotAvailableViewControllerStoryBoardId") as! UINotAvailableViewController
    }
}
