//
//  UIFlowController.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PPCloak


typealias NotificationActionCallback = (_ action: NotificationAction, _ notification: OPNotification) -> Void
typealias ForgotPasswordCallback = ((_ email: String) -> Void)
typealias NumberOfNotificationsCompletion = (_ num: Int) -> Void
typealias NumOfNotificationsRequestCallback = (_ callback: NumberOfNotificationsCompletion?) -> Void

struct Dependencies{
    let identityManagementRepo: IdentitiesManagementRepository?
    let privacyForBenefitsRepo: PrivacyForBenefitsRepository?
    let userInfoRepo: UserInfoRepository?
    let notificationsRepository: NotificationsRepository?
    let accountCallbacks: AccountCallbacks?
    let userSettingsCallbacks: UserSettingsModelCallbacks?
    let whenTakingActionForNotification: NotificationActionCallback?
    let whenRequestingNumOfNotifications: NumOfNotificationsRequestCallback?
    let feedbackFormRepo: OPFeedbackFormProtocol?
    let myAccountRepo: UsersRepository?
    let privacyWizzard:PrivacyWizardRepository?
}

struct AccountCallbacks {
    let loginCallback: LoginCallback?
    let logoutCallback: VoidBlock?
    let registerCallback: RegistrationCallback?
    let forgotPasswordCallback: ForgotPasswordCallback?
    let passwordChangeCallback: PasswordChangeCallback?
}

class UIOPFlowController
{
    let dependencies: Dependencies
    let rootController: UIRootViewController
    
    let sharedBrowserController: UIPrivateBrowsingViewController = UIViewControllerFactory.privateBrowsingViewController
    private var sideMenu: ENSideMenuNavigationController?
    
    init(dependencies: Dependencies)
    {
        self.dependencies = dependencies
        self.rootController = UIViewControllerFactory.rootViewController
        
        weak var weakSelf = self
        let rootControllerCallbacks = UIRootViewControllerCallbacks(
            whenMenuButtonPressed: {
                weakSelf?.sideMenu?.toggleSideMenuView()},
            whenBackButtonPressed: {
                
                if self.rootController.topBarLabel.text == "Facebook privacy settings" {
                    weakSelf?.displayPrivacyWizardDashboard()
                }
                else {
                    weakSelf?.displayDashboard()
                    self.rootController.reset()
                }
                
        }, WhenBackPressOnSettingsView: {
            weakSelf?.displayPrivateBrowsing()
            self.rootController.reset()
            self.rootController.setupTabViewForPrivateBrowsing()
        }, whenSettingsButtonPressed: {
            weakSelf?.displaySettingsViewController()
        })
        
        self.rootController.setupWithCallbacks(rootControllerCallbacks)
    }
    
    func displayLoginHierarchy()
    {
        let loginVC = UIViewControllerFactory.loginViewController
        let registrationViewController = UIViewControllerFactory.registerViewController
        weak var weakLoginVC = loginVC
        
        let loginViewControllerCallbacks = UISignInViewControllerCallbacks(whenUserWantsToLogin:
            self.dependencies.accountCallbacks?.loginCallback,whenUserForgotPassword: self.dependencies.accountCallbacks?.forgotPasswordCallback)
        {
            weakLoginVC?.navigationController?.pushViewController(registrationViewController, animated: true)
        }
        
        let registerViewControllerCallbacks = UIRegistrationViewControllerCallbacks(whenUserRegisters: self.dependencies.accountCallbacks?.registerCallback) {
            weakLoginVC?.navigationController?.popViewController(animated: true)
        }
        
        loginVC.logic.setupWithCallbacks(loginViewControllerCallbacks)
        registrationViewController.setupWith(callbacks: registerViewControllerCallbacks)
        
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.isNavigationBarHidden = true
        self.rootController.setMainControllerTo(newController: navigationController)
        self.rootController.showTopBar(hidden: true)
        self.sideMenu?.sideMenu?.hideSideMenu()
    }
    
    private func createRegisterViewController() -> UIRegistrationViewController {
        return UIViewControllerFactory.registerViewController
    }
    
    func displayDashboard(){
        let dashBoardVC = UIViewControllerFactory.dashboardViewController
        self.rootController.showTopBar(hidden: false)
        weak var weakSelf = self
        
        let dashboardCallbacks = UIDashBoardViewControllerCallbacks(
            
            whenChoosingIdentitiesManagement: {
                self.rootController.setupLeftButton(buttonType: .back)
                if UIDefaultFeatureProvider.shouldRestrictAccessToFeature() {
                    weakSelf?.displayAuthenticationRequired(forFeature: .identityManagement)
                } else {
                    weakSelf?.displayIdentitiesManagement()
                }
        },whenChoosingPrivacyForBenefits: {
            
            self.rootController.setupLeftButton(buttonType: .back)
            weakSelf?.displayPrivacyWizardDashboard()
        },whenChoosingPrivateBrowsing: {
            self.rootController.setupLeftButton(buttonType: .back)
            weakSelf?.displayPrivateBrowsing()
        },
          whenChoosingNotifications: {
            self.rootController.setupLeftButton(buttonType: .back)
            if UIDefaultFeatureProvider.shouldRestrictAccessToFeature() {
                weakSelf?.displayAuthenticationRequired(forFeature: .notifications)
            } else {
                weakSelf?.displayNotifications()
            }
        },
          numOfNotificationsRequestCallback:
            self.dependencies.whenRequestingNumOfNotifications)
        
        dashBoardVC.setupWith(callbacks: dashboardCallbacks)
        self.rootController.setMainControllerTo(newController: dashBoardVC)
    }
    
    func displayPrivacyWizardDashboard() {

        let vc = UIViewControllerFactory.getPrivacyWizzardDashboardViewController()
       
        vc.setupWithCallback(callbacks: PrivacyWizzardDashboardCallbacks(pressedFacebook: {
            
            //go to Facebook Privacy settings
            
            self.displayQuestionnaire(wizzardType: .facebook)
            
        }, pressedLinkedin: {
            
            self.displayQuestionnaire(wizzardType: .linkedin)
        }, pressedTwitter: {
            self.displayQuestionnaire(wizzardType: .twitter)
        }))
            
        self.rootController.setupTabViewForPrivacyWizzard()
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayQuestionnaire (wizzardType: PrivacyWizzardType) {
        let vc = UIViewControllerFactory.getQuestionnarieViewController()
        
        vc.setup(with: dependencies.privacyWizzard!, callbacks: PrivacyWizzardSettingsCallbacks(pressedSubmit: { (_) in
            
            //go to privacy
            print("go to privacy")
            self.displaySetPrivacyVC()
            
        }, pressedRecommended: {
            
            print("pressedRecommended")
             self.displaySetPrivacyVC()
        }))
        
        vc.wizzardType = wizzardType
        
        switch wizzardType {
        case .facebook:
            self.rootController.setupTabViewForFBQuestionnaire()
            break
        case .linkedin:
            self.rootController.setupTabViewForLinkedinQuestionnaire()
            break
        case .twitter:
            self.rootController.setupTabViewForTwitterQuestionnaire()
        }
        
        self.rootController.setMainControllerTo(newController: vc)
        
    }
    
    func displaySetPrivacyVC(){
         let vc = UIViewControllerFactory.getUISetPrivacyViewController()
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayAuthenticationRequired(forFeature type: UIRestrictedFeatureType) {
        let vc = UIViewControllerFactory.notAvailableViewController
        
        switch type {
        case .identityManagement:
            self.rootController.setupTabViewForIdentities()
        case .notifications:
            self.rootController.setupTabViewForNotification()
        }
        
        weak var weakSelf = self
        vc.setupWithCallbacks(whenLoginRequired: {
            weakSelf?.displayLoginHierarchy()
        }, whenNewAccountRequired: {
            
        })
        
        
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayIdentitiesManagement(){
        let vc = UIViewControllerFactory.identityManagementViewController
        weak var weakSelf = self
        
        vc.logic.setupWith(identitiesRepository: dependencies.identityManagementRepo, callbacks: UIIdentityManagementCallbacks(obtainNewIdentityWithCompletion: { completion  in
            weakSelf?.displayAddIdentityControllerWith(identityGeneratedCallback: completion)
        }))
        
        self.rootController.setupTabViewForIdentities()
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayAddIdentityControllerWith(identityGeneratedCallback: CallbackWithString?){
        let identityVC = UIViewControllerFactory.addIdentityController
        
        weak var weakVC = identityVC
        weak var weakSelf = self
        
        identityVC.setupWith(identitiesRepository: weakSelf?.dependencies.identityManagementRepo, callbacks: UIAddIdentityViewControllerCallbacks(onExitWithIdentity: { aliasIfAny in
            if let alias = aliasIfAny {
                identityGeneratedCallback?(alias)
            }
            weakVC?.dismiss(animated: false, completion: nil)
        }))
        
        self.rootController.present(identityVC, animated: false, completion: nil)
    }
    
    func displayPfbDeals() {
        let vc = UIViewControllerFactory.pfbDealsController
        vc.setupWith(dealsRepository: dependencies.privacyForBenefitsRepo)
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayPrivateBrowsing() {
        self.rootController.setMainControllerTo(newController: self.sharedBrowserController)
        self.rootController.setupTabViewForPrivateBrowsing()
    }
    
    
    func displayNotifications() {
        let vc = UIViewControllerFactory.notificationsViewController
        
        vc.setup(with: self.dependencies.notificationsRepository, notificationCallback: self.dependencies.whenTakingActionForNotification)
        self.rootController.setupTabViewForNotification()
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displayPrivacyPolicyViewController(){
        let vc = UIViewControllerFactory.privacyPolicyController
        self.rootController.setMainControllerTo(newController: vc);
    }
    
    func displayFeedbackFormViewController(){
        
        let feedbackFormVC = UIViewControllerFactory.feedbackFormViewController
        feedbackFormVC.setup(with: OPFeedbackFormVCInteractor(feedbackForm: OPFeedbackForm(delegate: self.dependencies.feedbackFormRepo),
                                                              uiDelegate: feedbackFormVC, feedbackCallback: OPFeedbackFormVCCallbacks(whenSubmitEndedWithSuccess: {
                                                                
                                                                self.displayDashboard()
                                                                
                                                              })))
        self.rootController.setMainControllerTo(newController: feedbackFormVC);
    }
    
    func displayMyAccountController(){
        
        let myAccountVC = UIViewControllerFactory.myAccountViewController
        myAccountVC.setup(with: self.dependencies.myAccountRepo, callbacks: UIMyAccountViewControllerLogicCallbacks(userUpdatedPassword: {
            
            print("userUpdatedPassword")
            OPViewUtils.displayAlertWithMessage(message: "The password was successfully changed.", withTitle: "My Account", addCancelAction: false, withConfirmation: nil)
        }, userDeletedAccount: {
            print("userDeletedAccount")
            CredentialsStore.deleteCredentials()
            self.displayLoginHierarchy()
        }))
        self.rootController.setMainControllerTo(newController: myAccountVC);
    }
    
    func displayAboutViewController(){
        let vc = UIViewControllerFactory.aboutViewController
        self.rootController.setMainControllerTo(newController: vc)
    }
    
    func displaySettingsViewController() {
        guard let currentSettings = self.dependencies.userSettingsCallbacks?.retrieveCallback() else {
            return
        }
        let settingsVC = UIViewControllerFactory.settingsViewController
        settingsVC.setupWith(settingsModel: currentSettings, callback: self.dependencies.userSettingsCallbacks?.updateCallback)
        self.rootController.setupTabViewForSettings()
        self.rootController.setMainControllerTo(newController: settingsVC)
    }
    
    func setupBaseHierarchyInWindow(_ window: UIWindow){
        self.sideMenu = ENSideMenuNavigationController(menuViewController: createLeftSideMenuViewController(), contentViewController: self.rootController)
        self.sideMenu?.navigationBar.isHidden = true
        window.rootViewController = self.sideMenu
    }
    
    func hideSideMenu() {
        sideMenu?.hide()
    }
    
    func refreshSideMenu() {
        sideMenu?.reload()
    }
    
    private func createLeftSideMenuViewController() -> UILeftSideMenuViewController {
        let leftSideMenu = UIViewControllerFactory.leftMenuViewController
        leftSideMenu.callbacks = getLeftSideMenuCallbacks()
        leftSideMenu.setupWith(userInfoRepo: self.dependencies.userInfoRepo)
        return leftSideMenu
    }
    
    private func getLeftSideMenuCallbacks() -> UILeftSideMenuViewControllerCallbacks?
    {
        weak var weakSelf = self
        let dashboardCallbacks = UIDashBoardViewControllerCallbacks(whenChoosingIdentitiesManagement: {
            weakSelf?.displayIdentitiesManagement()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
            self.rootController.setupTabViewForIdentities()
        },whenChoosingPrivacyForBenefits: {
            weakSelf?.displayPfbDeals()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        },whenChoosingPrivateBrowsing: {
            weakSelf?.displayPrivateBrowsing()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
            self.rootController.setupTabViewForPrivateBrowsing()
        },
          whenChoosingNotifications: {
            weakSelf?.displayNotifications()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
            self.rootController.setupTabViewForNotification()
        },
          numOfNotificationsRequestCallback: self.dependencies.whenRequestingNumOfNotifications)
        
        return UILeftSideMenuViewControllerCallbacks(dashboardCallbacks: dashboardCallbacks, whenChoosingHome: { 
            weakSelf?.displayDashboard()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        }, whenChoosingMonitor: {
            
            UIView.transition(with: self.rootController.view, duration: 0.5, options: .transitionFlipFromTop, animations: {
                PPCloak.OPMonitor.displayFlow()
                self.rootController.reset()
            }, completion: { completed in
                // maybe do something here
            })
            
            
        }, whenChoosingSettings: {
            weakSelf?.displaySettingsViewController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        },
           whenChoosingPrivacyPolicy: {
            weakSelf?.displayPrivacyPolicyViewController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
            self.rootController.setupTabViewForPrivateBrowsing()
        }, whenChoosingAbout: {
            weakSelf?.displayAboutViewController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        }, whenChoosingFeedbackForm: {
            weakSelf?.displayFeedbackFormViewController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
            
        }, logoutCallback: {
            if UIDefaultFeatureProvider.userIsLoggedIn() {
                self.dependencies.accountCallbacks?.logoutCallback?()
                UICustomPopup.displayOkAlert(from: self.rootController, title: "Logout message", message: "Message in cause")
            } else {
                self.displayLoginHierarchy()
            }
            self.rootController.reset()
        }, whenChoosingMyAccount: {
            weakSelf?.displayMyAccountController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        })
        
    }
}



