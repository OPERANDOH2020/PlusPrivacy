//
//  UISNSettingsReaderViewController.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

class UISNSettingsReaderViewController: UIViewController {

    var webView: WKWebView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var beginNewReadingButton: UIButton!
    @IBOutlet weak var webViewHost: UIView!
    
    var whenLoginButtonsIsPressed: VoidBlock?
    
    let ospSettingsManager = OSPSettingsManager()
    
    
    @IBOutlet weak var snSettingsView: UISNSettingsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.alpha = 0;
        self.webView = WKWebView()
        UIView.constrainView(view: self.webView, inHostView: self.webViewHost)
        self.view.bringSubview(toFront: self.loginButton)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func didPressBeginNewReading(sender: AnyObject)
    {
        self.beginNewReadingButton.alpha = 0;
        self.loginButton.alpha = 1.0;
        
        self.enforceFBSecurityV2()
    }
    
    func startANewReading()
    {
        self.beginNewReadingButton.alpha = 0.0;
        self.loginButton.alpha = 1.0;
        self.webViewHost.alpha = 1.0
        self.snSettingsView.alpha = 0.0;
        
        self.beginNewReadingWithCompletion { (results, error) in
            
            self.loginButton.alpha = 0.0;
            self.beginNewReadingButton.alpha = 1.0;
            self.webViewHost.alpha = 0.0
            
            if let results = results
            {
                self.snSettingsView.alpha = 1.0;
                self.snSettingsView.reloadWithItems(items: results)
            }
        }
        
    }
    
    @IBAction func didPressLoginButton(sender: AnyObject)
    {
        self.whenLoginButtonsIsPressed?()
    }
    
    @IBAction func didPressToEnforceFacebook(sender: AnyObject)
    {
        self.enforceFBSecurityV2()
    }
    
    
    func enforceFBSecurityV2()
    {
        self.alterUserAgentInDefaults()
        let fbEnforcer = FbWebKitSecurityEnforcer(webView: self.webView)
        fbEnforcer.enforceWithCallToLogin(callToLoginWithCompletion: { (callWhenLoginIsDone) in
            
            RSCommonUtilities.showOKAlertWithMessage(message: "Please login and press 'Login Finished'");
            self.whenLoginButtonsIsPressed = {
                callWhenLoginIsDone?()
            }
            
            }, whenDisplayingMessage: { message in
                RSCommonUtilities.showOKAlertWithMessage(message: message);
            })
                { (error) in
                print(error);
                print(fbEnforcer.self)
        }
    }
    
    func enforceFacebookSecurity()
    {
        
        
    }
    
    func beginNewReadingWithCompletion(completion: ((_ results: [SettingsReadResult]?, _ error: NSError?) -> Void)?)
    {

    }
    
    
    
    private func alterUserAgentInDefaults()
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12" as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultsUserAgent)
        UserDefaults.standard.synchronize()
    }
    
    private func clearUserAgentFromDefaults()
    {
        UserDefaults.standard.removeObject(forKey: "UserAgent");
        UserDefaults.standard.synchronize();
    }
}
