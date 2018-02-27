//
//  ViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private var webView: WKWebView = WKWebView(frame: .zero)
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCustomBackBarButtonItem()
        
        UIView.constrainView(view: webView, inHostView: self.contentView)
        if #available(iOS 9.0, *) {
            self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alterUserAgentInDefaults()
        
        
        
        if let error = self.webView.loadWebViewToURL(urlString: "https://www.facebook.com") {
            print(error)
            return
        }
    }
    
    private func alterUserAgentInDefaults()
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12" as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultsUserAgent)
        UserDefaults.standard.synchronize()
    }
    
    func login() {
        let savedUsername = "this_is_an_email@mail.com"
        let savedPassword = "NotAllowed"
        
        let fillForm = String(format: "document.getElementById('email').value = '\(savedUsername)';document.getElementById('pass').value = '\(savedPassword)';")
        if webView.stringByEvaluatingJavaScriptFromString(script: fillForm) {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                _ = self.webView.stringByEvaluatingJavaScriptFromString(script: "document.forms[\"login_form\"].submit();")
            })
        }
    }
    
    // MARK: - Back Button Action
    func backBarButtonItemPressed(sender: AnyObject) {
        login()
    }
    
    // MARK: - Back Button
    func setCustomBackBarButtonItem() {
        let backButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0))
        //backButton.setImage(UIImage(named: "TS_iOS_navigation_icon_back_"), forState: .Normal)
        backButton.addTarget(self, action: #selector(ViewController.backBarButtonItemPressed(sender:)), for: .touchUpInside)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}
