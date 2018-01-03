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
}

struct AccountCallbacks {
    let loginCallback: LoginCallback?
    let logoutCallback: VoidBlock?
    let registerCallback: RegistrationCallback?
    let forgotPasswordCallback: ForgotPasswordCallback?
    let passwordChangeCallback: PasswordChangeCallback?
}

class UIFlowController
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
                weakSelf?.displayDashboard()
                self.rootController.reset()
        }, WhenBackPressOnSettingsView: {
            weakSelf?.displayPrivateBrowsing()
            self.rootController.reset()
            self.rootController.setupTabViewForPrivateBrowsing()
        }, whenSettingsButtonPressed: {
            weakSelf?.displaySettingsViewController()
//            self.rootController.reset()
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
                weakSelf?.displayIdentitiesManagement()
        },whenChoosingPrivacyForBenefits: {
            
            self.rootController.setupLeftButton(buttonType: .back)
            weakSelf?.displayPfbDeals()
        },whenChoosingPrivateBrowsing: {
            self.rootController.setupLeftButton(buttonType: .back)
            weakSelf?.displayPrivateBrowsing()
        },
          whenChoosingNotifications: {
            self.rootController.setupLeftButton(buttonType: .back)
            weakSelf?.displayNotifications()
        },
          numOfNotificationsRequestCallback:
            self.dependencies.whenRequestingNumOfNotifications)
        
        dashBoardVC.setupWith(callbacks: dashboardCallbacks)
        self.rootController.setMainControllerTo(newController: dashBoardVC)
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
        
        //        let sideMenuEN = ENSideMenuNavigationController(menuViewController: createLeftSideMenuViewController(), contentViewController: self.rootController)
        //        sideMenu.configure(configuration: SSASideMenu.MenuViewEffect(fade: true, scale: true, scaleBackground: false, parallaxEnabled: true, bouncesHorizontally: false, statusBarStyle: SSASideMenu.SSAStatusBarStyle.Black))
        
        self.sideMenu = ENSideMenuNavigationController(menuViewController: createLeftSideMenuViewController(), contentViewController: self.rootController)
        self.sideMenu?.navigationBar.isHidden = true
        window.rootViewController = self.sideMenu
        //        self.sideMenu = sideMenu
        //        sideMenu.delegate = self
    }
    
    //    private func createRightMenuViewController() -> UIAccountViewController {
    //
    //        let accountController = UIViewControllerFactory.accountViewController
    //        accountController.logic.setupWith(callbacks:UIAccountViewControllerCallbacks(
    //        whenUserChoosesToLogout: self.dependencies.accountCallbacks?.logoutCallback,
    //        whenUserChangesPassword: self.dependencies.accountCallbacks?.passwordChangeCallback,
    //        whenFeedbackFormAccessed: {
    //            let feedbackFormVC = UIViewControllerFactory.feedbackFormViewController
    //            feedbackFormVC.setup(with: OPFeedbackFormVCInteractor(feedbackForm: OPFeedbackForm(delegate: self.dependencies.feedbackFormRepo),
    //                                                                  uiDelegate: feedbackFormVC as? OPFeedbackFormVCProtocol))
    //            self.rootController.setMainControllerTo(newController: feedbackFormVC)
    //            self.sideMenu?.sideMenu?.hideSideMenu()
    //        }))
    //
    //        return accountController
    //    }
    
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
            self.dependencies.accountCallbacks?.logoutCallback?()
            self.rootController.reset()
        }, whenChoosingMyAccount: {
            weakSelf?.displayMyAccountController()
            weakSelf?.sideMenu?.sideMenu?.hideSideMenu()
            self.rootController.reset()
        })
        
    }
    
    
    //    func sideMenuWillShowMenuViewController(sideMenu: SSASideMenu, menuViewController: UIViewController) {
    //        if let leftMenuVC = menuViewController as? UILeftSideMenuViewController {
    //            leftMenuVC.prepareToAppear()
    //        }
    //    }
}



