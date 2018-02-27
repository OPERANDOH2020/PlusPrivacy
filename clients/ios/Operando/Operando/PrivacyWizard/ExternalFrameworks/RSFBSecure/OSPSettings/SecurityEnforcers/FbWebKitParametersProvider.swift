//
//  FbWebKitParametersProvider.swift
//  Operando
//
//  Created by Costin Andronache on 8/17/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import WebKit

extension String
{
    var toPOSTDictionary: [String: String]
    {
        var result: [String: String] = [:];
        
        
        let keyValuePairs = self.components(separatedBy: "&")
        keyValuePairs.forEach { keyValuePairString in
            let nameAndValueArray = keyValuePairString.components(separatedBy: "=")
            if let name = nameAndValueArray.first, let value = nameAndValueArray.last
            {
                result[name] = value;
            }
        }
        
        return result
    }
}

class FbWebKitParametersProvider: NSObject, FacebookPostParametersProvider, WKNavigationDelegate, WKUIDelegate
{
    
    
    private let webView: WKWebView
    
    private var whenUserLogsIn: VoidBlock?
    private var whenWebViewHasPOSTRequest: ((_ postDataAsJSON: [String: String] ) -> Void)?
    
    init(loginDoneButton: UIButton, webView: WKWebView)
    {
        self.webView = webView
        super.init()
        loginDoneButton.addTarget(self, action: #selector(FbWebKitParametersProvider.userDidLogin(sender:)), for: .touchUpInside)
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    
    func getCurrentUserParametersWithCompletion(completion: ((_ error: NSError?, _ params: [String : String]) -> Void)?)
    {
        self.navigateWebViewToFacebook()
        RSCommonUtilities.showOKAlertWithMessage(message: "Please login on Facebook and when you're done, press the \'Finished Button\'")
        weak var weakSelf = self
        
        self.whenUserLogsIn =
        {
            weakSelf?.displayAllCookies()
            weakSelf?.whenWebViewHasPOSTRequest = { (postDataDict) in
                weakSelf?.whenWebViewHasPOSTRequest = nil
                weakSelf?.whenUserLogsIn = nil
                
                completion?(nil, postDataDict);
                
            }
        }
    }
    
    
    private func displayAllCookies()
    {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        for cookie in cookies
        {
            print(cookie.name + " -- " + cookie.value)
        }
        
    }
    
    private func loadHijackXHRScript()
    {
        guard let path = Bundle.main.path(forResource: "interceptPOST", ofType: "js"),
                  let jsString = try? String(contentsOfFile: path) else {return}
        
        self.webView.evaluateJavaScript(jsString) { result, error  in
            
            print(error);
        }
        
    }
    
    @objc private func userDidLogin(sender: AnyObject?)
    {
        self.whenUserLogsIn?()
    }
    
    
    func navigateWebViewToFacebook()
    {
        let url = NSURL(string: "https://www.facebook.com")
        let request = NSURLRequest(url: url! as URL)
        self.webView.load(request as URLRequest);
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadHijackXHRScript()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.loadHijackXHRScript()
    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    {
        if let jsonString = message.body as? String
        {
            print(jsonString);
        }
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        self.whenWebViewHasPOSTRequest?(message.toPOSTDictionary);
        completionHandler()
    }
    
}
