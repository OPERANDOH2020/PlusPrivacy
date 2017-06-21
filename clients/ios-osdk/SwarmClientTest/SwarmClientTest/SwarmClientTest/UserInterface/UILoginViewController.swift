/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Cătălin Pomîrleanu (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */

import UIKit

let UILoginViewControllerStoryboardId = "UILoginViewControllerStoryboardId"

class UILoginViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    // MARK: - @IBActions
    @IBAction func didTapLoginButton(sender: AnyObject) {
        print("Did tap for login with username: \(usernameLabel.text) and password: \(passwordLabel.text)")
        ApplicationCore.sharedInstance.login(usernameLabel.text ?? "", password: passwordLabel.text ?? "")
    }
    
    // MARK: - Notifications
    func didReceiveLoginNotification(sender: NSNotification) {
        print("Did receive login notification!")
    }
    
    // MARK: - Private Methods
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UILoginViewController.didReceiveLoginNotification(_:)), name: ACDidReceiveDataFromServerNotification, object: nil)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addObservers()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
