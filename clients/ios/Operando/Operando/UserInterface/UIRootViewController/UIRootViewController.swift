//
//  UIRootViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIRootViewControllerCallbacks
{
    let whenMenuButtonPressed: VoidBlock?
}

class UIRootViewController: UIViewController
{
    
    @IBOutlet weak var mainScreensHostView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    fileprivate var currentlyShownViewController: UIViewController?
    fileprivate var callbacks: UIRootViewControllerCallbacks?
    
    
    func setupWithCallbacks(_ callbacks: UIRootViewControllerCallbacks?)
    {
        self.callbacks = callbacks
    }
    
    @IBAction func didPressMenuButton(_ sender: UIButton?)
    {
        self.callbacks?.whenMenuButtonPressed?()
    }
    
    func showTopBar(hidden: Bool) {
        topBarView?.isHidden = hidden
    }
    
    func setMainControllerTo(newController: UIViewController)
    {
        let _ = self.view
        
        if let currentlyShownViewController = self.currentlyShownViewController
        {
            self.removeContentController(controller: currentlyShownViewController)
        }
        
        self.addContentController(controller: newController, constrainWithAutolayout: true, inOwnViewSubview: self.mainScreensHostView)
        
        self.currentlyShownViewController = newController
    }
}
