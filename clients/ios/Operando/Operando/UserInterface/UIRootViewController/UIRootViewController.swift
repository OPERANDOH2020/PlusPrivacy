//
//  UIRootViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIRootViewController: UIViewController
{
    
    @IBOutlet weak var blackAlphaView: UIView!
    @IBOutlet weak var mainScreensHostView: UIView!
    @IBOutlet weak var menuViewControllerHostLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuViewControllerHostView: UIView!
    var menuViewController: UIMenuTableViewController?
    
    private var mainNavController: UINavigationController?
    
    
    
    func beginDisplayingUI()
    {
        let _ = self.view;

        self.blackAlphaView.hidden = false;
        self.blackAlphaView.alpha = 0.0;
        
        self.mainNavController = self.loadAndSetupMainNavigationController();
        self.loadAndSetupMenuViewController();
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event);
        self.hideMenu();
    }
    
    @IBAction func didPressMenuButton(sender: AnyObject)
    {
        self.displayMenu();
    }

    
    func animateMenuSpaceConstraintTo(value: CGFloat)
    {
        self.menuViewControllerHostLeadingSpace.constant = value;
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { 
            self.view.layoutIfNeeded();
            }, completion: nil);
    }
    
    
    private func displayMenu()
    {
        self.menuViewController?.refreshViewWithUsername(OPConfigObject.sharedInstance.getCurrentUserIdentityIfAny()?.username)
        self.animateBlackViewAlphaTo(0.5)
        self.animateMenuSpaceConstraintTo(0);
    }
    
    private func hideMenu()
    {
        self.animateBlackViewAlphaTo(0.0);
        self.animateMenuSpaceConstraintTo(-self.view.frame.size.width * 1.2);
    }
    
    
    private func animateBlackViewAlphaTo(newAlpha: CGFloat)
    {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { 
            self.blackAlphaView.alpha = newAlpha;
            }, completion: nil);
    }
    
    private func loadAndSetupMenuViewController()
    {
        let menuVC = UINavigationManager.menuViewController;
        menuVC.actionsPerIndex = self.actionsForMenuController();
        self.addContentController(menuVC, constrainWithAutolayout: true, inOwnViewSubview: self.menuViewControllerHostView);
        self.menuViewController = menuVC
    }
    
    private func loadAndSetupMainNavigationController() -> UINavigationController
    {
        let navController = UINavigationManager.mainNavigationController;
        self.addContentController(navController, constrainWithAutolayout: true, inOwnViewSubview: self.mainScreensHostView);
        
        if let rootNavController = navController.viewControllers.first as? UIDashboardViewController
        {
            weak var weakSelf = self
            rootNavController.whenPrivateBrowsingButtonPressed = {
                weakSelf?.loadPrivateBrowsingAsMainViewController()
            }
        }
        
        return navController
    }
    
    
    private func setMainControllerTo(newController: UIViewController, navigationBarHidden : Bool = false)
    {
        UIView.performWithoutAnimation {
            self.mainNavController?.navigationBarHidden = navigationBarHidden
            self.mainNavController?.viewControllers = [newController];
        }
        self.hideMenu()
    }
    
    
    
    private func actionsForMenuController() -> [Int : VoidBlock]
    {
        weak var weakSelf = self;
        return [2: {weakSelf?.setMainControllerTo(UINavigationManager.snSettingsReaderViewController)},
                3: {weakSelf?.setMainControllerTo(UINavigationManager.dataLeakageViewController)},
                0: {weakSelf?.loadDashboardAsMainViewController()},
                8: {weakSelf?.setMainControllerTo(UINavigationManager.identityManagementViewController)},
                4: {weakSelf?.setMainControllerTo(UINavigationManager.notificationsViewController)},
                6: {weakSelf?.loadPrivateBrowsingAsMainViewController()},
                1: {weakSelf?.setMainControllerTo(UINavigationManager.externalConnectionsViewController)}
        ];
    }
    
    //MARK: - View controller load methods
    
    private func loadDashboardAsMainViewController()
    {
        let vc = UINavigationManager.dashboardViewController
        weak var weakSelf = self
        vc.whenPrivateBrowsingButtonPressed = {
            weakSelf?.loadPrivateBrowsingAsMainViewController()
        }
        
        self.setMainControllerTo(vc)
    }
    
    private func loadPrivateBrowsingAsMainViewController()
    {
        self.setMainControllerTo(UINavigationManager.privateBrowsingViewController, navigationBarHidden: true)
    }
}
