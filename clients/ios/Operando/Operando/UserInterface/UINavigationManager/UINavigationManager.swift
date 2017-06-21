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
    
    static var rootViewController : UIRootViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIRootViewController") as! UIRootViewController
        }
    }
    
    static var menuViewController : UIMenuTableViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIMenuTableViewController") as! UIMenuTableViewController
        }
    }
    
    static var mainNavigationController : UINavigationController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController;
        }
    }
    
    static var sensorMonitoringViewController: UISensorMonitoringViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UISensorMonitoringViewController") as! UISensorMonitoringViewController;
        }
    }
    
    static var notificationsViewController: UINotificationsViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UINotificationsViewController") as!
            UINotificationsViewController
        }
    }
    
    static var dataLeakageViewController: UIDataLeakageProtectionViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIDataLeakageProtectionViewController") as! UIDataLeakageProtectionViewController
        }
    }
    
    static var identityManagementViewController : UIIdentityManagementViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIIdentityManagementViewController") as! UIIdentityManagementViewController
        }
    }
    
    static var dashboardViewController: UIDashboardViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIDashboardViewController") as! UIDashboardViewController
        }
    }
    
    
    static var privateBrowsingViewController: UIPrivateBrowsingViewController
    {
        get
        {
            return main.instantiateViewControllerWithIdentifier("UIPrivateBrowsingViewController") as! UIPrivateBrowsingViewController
        }
    }
    
    static var externalConnectionsViewController: UIExternalConnectionsViewController
    {
        return main.instantiateViewControllerWithIdentifier("UIExternalConnectionsViewController") as! UIExternalConnectionsViewController
    }
    
    static var securityEventsViewController: UISecurityEventsViewController
    {
        return main.instantiateViewControllerWithIdentifier("UISecurityEventsViewController") as! UISecurityEventsViewController
    }
    
    static var securityEventDetailsViewController: UISecurityEventDetailsViewController
    {
        return main.instantiateViewControllerWithIdentifier("UISecurityEventDetailsViewController") as! UISecurityEventDetailsViewController
    }
    
    
    static var snSettingsReaderViewController: UISNSettingsReaderViewController
    {
        return main.instantiateViewControllerWithIdentifier("UISNSettingsReaderViewController") as! UISNSettingsReaderViewController
    }
    
}