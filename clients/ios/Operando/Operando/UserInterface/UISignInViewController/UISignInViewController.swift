//
//  UISignInViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/26/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISignInViewController: UIViewController {

    @IBOutlet weak var loginView: UILoginView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginView.setupWithCallbacks(self.callbacksForLoginView(self.loginView));
    }
    
    
    private func callbacksForLoginView(loginView: UILoginView) -> UILoginViewCallbacks?
    {
        weak var weakSelf = self;
        
        return UILoginViewCallbacks(whenUserWantsToLogin: { (info) in
            weakSelf?.loginUserWithLoginInfo(info)
            }, whenUserForgetsPassword: { 
                OPViewUtils.showOkAlertWithTitle("", andMessage: "Will be available soon")
        })
    }
    
    private func loginUserWithLoginInfo(loginInfo: LoginInfo)
    {
        self.view.alpha = 0.8;
        
        OPConfigObject.sharedInstance.loginUserWithInfo(loginInfo) { (error, identity) in
            self.view.alpha = 1.0;
            
            if let err = error
            {
                OPViewUtils.showOkAlertWithTitle("Error", andMessage: err.localizedDescription);
            }
            else
            {
                self.navigationController?.popToRootViewControllerAnimated(true);
            }
        }
    }
}
