//
//  UIDashboardViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIDashboardViewController: UIViewController
{

    var whenPrivateBrowsingButtonPressed: (() -> ())?
    
    @IBOutlet weak var registerOrLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showOrHideAuthenticationButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.showOrHideAuthenticationButton()
    }
    
    @IBAction func didPressPrivateBrowsing(sender: AnyObject)
    {
        self.whenPrivateBrowsingButtonPressed?()
    }
    
    
    private func showOrHideAuthenticationButton()
    {
        self.registerOrLoginButton.hidden = false
        if let _ = OPConfigObject.sharedInstance.getCurrentUserIdentityIfAny()
        {
           self.registerOrLoginButton.hidden = true
        }
    }
}
