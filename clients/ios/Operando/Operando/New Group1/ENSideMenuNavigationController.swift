//
//  RootNavigationViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class ENSideMenuNavigationController: UINavigationController, ENSideMenuProtocol {

    var sideMenu : ENSideMenu?
    var sideMenuAnimationType : ENSideMenuAnimation = .default

    private var menuContentViewController: UILeftSideMenuViewController?
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    public init( menuViewController: UILeftSideMenuViewController, contentViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)

        if (contentViewController != nil) {
            self.viewControllers = [contentViewController!]
        }
        menuContentViewController = menuViewController
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menuViewController, menuPosition:.left)
        sideMenu?.menuWidth = UIScreen.main.bounds.width + 5
        view.bringSubview(toFront: navigationBar)
        
        if let vc = self.sideMenu?.menuViewController as? UILeftSideMenuViewController {
            sideMenu?.delegate = vc
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    open func setContentViewController(_ contentViewController: UIViewController) {
        self.sideMenu?.toggleMenu()
        switch sideMenuAnimationType {
        case .none:
            self.viewControllers = [contentViewController]
            break
        default:
            contentViewController.navigationItem.hidesBackButton = true
            self.setViewControllers([contentViewController], animated: true)
            break
        }
    }
    
    func hide() {
        sideMenu?.hideSideMenu()
    }
    
    func reload() {
        menuContentViewController?.refreshMenu()
    }
}
