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
    
    @IBOutlet weak var googleLogoutButton: UIButton!
    @IBOutlet weak var twitterLogoutButton: UIButton!
    @IBOutlet weak var linkedinLogoutButton: UIButton!
    @IBOutlet weak var fbLogoutButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        
        self.checkFB()
        self.checkGo()
        self.checkLK()
        self.checkTw()
    }
    
    func checkFB() {
        WKWebsiteDataStore.default().fbCookiesExists { (exists) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.fbLogoutButton.isHidden = !exists!
                ProgressHUD.dismiss()
            })
        }
    }
    
    func checkLK(){
        
        WKWebsiteDataStore.default().lkCookiesExists { (exists) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.linkedinLogoutButton.isHidden = !exists!
                ProgressHUD.dismiss()
            })
        }
        
    }
    
    func checkGo(){
        WKWebsiteDataStore.default().goCookiesExists { (exists) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.googleLogoutButton.isHidden = !exists!
                ProgressHUD.dismiss()
            })
        }
    }
    
    func checkTw(){
        WKWebsiteDataStore.default().twCookiesExists { (exists) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.twitterLogoutButton.isHidden = !exists!
                ProgressHUD.dismiss()
            })
        }
        
    }
    
    @IBAction func pressedFBLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromFacebook {
            self.checkFB()
        }
    }
    
    @IBAction func pressedLinkedinLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromLinkedin{
            self.checkLK()
        }
    }
    
    @IBAction func pressedTwitterLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromTwitter{
            self.checkTw()
        }
    }
    
    @IBAction func pressedGoogleLogout(_ sender: Any) {
        ProgressHUD.show()
        WKWebsiteDataStore.default().deleteCookiesFromGoogle{
            self.checkGo()
        }
    }
}
