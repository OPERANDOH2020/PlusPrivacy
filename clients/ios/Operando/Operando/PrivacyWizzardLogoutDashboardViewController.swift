//
//  PrivacyWizzardLogoutDashboardViewController.swift
//  Operando
//
//  Created by Cristi Sava on 17/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit
import WebKit

class PrivacyWizzardLogoutDashboardViewController: UIViewController {
    
    @IBAction func pressedFBLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromFacebook {
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func pressedLinkedinLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromLinkedin{
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func pressedTwitterLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromTwitter{
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func pressedGoogleLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromGoogle{
            ProgressHUD.dismiss()
        }
    }
}
