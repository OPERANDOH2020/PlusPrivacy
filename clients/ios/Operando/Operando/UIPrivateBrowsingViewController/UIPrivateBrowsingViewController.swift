//
//  UIPrivateBrowsingViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

class UIPrivateBrowsingViewController: UIViewController, WKNavigationDelegate
{
    
    @IBOutlet weak var browsingNavigationBar: UIBrowsingNavigationBar!
    @IBOutlet weak var webViewHostView: UIView!
    var wkWebView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView = self.createWebViewInHostView(self.webViewHostView);
        self.wkWebView?.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.google.ro")!));
        self.browsingNavigationBar.setupWithCallbacks(self.callBacksForBrowsingBar(self.browsingNavigationBar));
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    
    
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
    {
        let detector = HTMLLoginInputDetector()
        detector.detectLoginInputsInWebView(webView) { (result) in
            if let detectionResult = result
            {
                print("login input id \(detectionResult.loginInputId), password input id = \(detectionResult.passwordInputId)")
            }
            else
            {
                print("No input items could be detected");
            }
        }
    }
    
    
    private func callBacksForBrowsingBar(browsingBar: UIBrowsingNavigationBar) -> UIBrowsingNavigationBarCallbacks?
    {
        weak var weakSelf = self;
        return UIBrowsingNavigationBarCallbacks(whenUserPressedBack: { 
            weakSelf?.wkWebView?.goBack()
            },
            whenUserPressedSearchWithString: { (searchString) in
                weakSelf?.goToAddressOrSearch(searchString)
        })
    }
    
    private func goToAddressOrSearch(string: String)
    {
        if let url = NSURL(string: "https://" + string) ?? NSURL(string: string)
        {
            self.wkWebView?.loadRequest(NSURLRequest(URL: url))
        }
        else
        {
            print("Must apply search for " + string)
        }
    }
    
    private func createWebViewInHostView(hostView: UIView) -> WKWebView
    {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.navigationDelegate = self
        UIView.constrainView(webView, inHostView: hostView)
        return webView
    }
}
