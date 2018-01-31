//
//  UIPrivacyPolicyViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/27/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit

let url = URL(string: "https://plusprivacy.com/privacy-policy/")!

class UIPrivacyPolicyViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView = WKWebView(frame: self.view.bounds)
        self.webView?.navigationDelegate = self
        self.view.addSubview(self.webView!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView?.frame = self.view.bounds;
        self.webView?.load(URLRequest(url: url))

    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        ProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.dismiss()
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.dismiss()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
