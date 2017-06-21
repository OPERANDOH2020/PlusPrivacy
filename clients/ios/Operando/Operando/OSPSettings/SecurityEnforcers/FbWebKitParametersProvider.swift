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
        
        let keyValuePairs = self.componentsSeparatedByString("&");
        keyValuePairs.forEach { keyValuePairString in
            let nameAndValueArray = keyValuePairString.componentsSeparatedByString("=")
            if let name = nameAndValueArray.first, value = nameAndValueArray.last
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
    private var whenWebViewHasPOSTRequest: ((postDataAsJSON: [String: String] ) -> Void)?
    
    init(loginDoneButton: UIButton, webView: WKWebView)
    {
        self.webView = webView
        super.init()
        loginDoneButton.addTarget(self, action: #selector(FbWebKitParametersProvider.userDidLogin(_:)), forControlEvents: .TouchUpInside)
        webView.navigationDelegate = self
        webView.UIDelegate = self
    }
    
    
    func getCurrentUserParametersWithCompletion(completion: ((error: NSError?, params: [String : String]) -> Void)?)
    {
        self.navigateWebViewToFacebook()
        RSCommonUtilities.showOKAlertWithMessage("Please login on Facebook and when you're done, press the \'Finished Button\'")
        weak var weakSelf = self
        
        self.whenUserLogsIn =
        {
            weakSelf?.displayAllCookies()
            weakSelf?.whenWebViewHasPOSTRequest = { (postDataDict) in
                weakSelf?.whenWebViewHasPOSTRequest = nil
                weakSelf?.whenUserLogsIn = nil
                
                completion?(error: nil, params: postDataDict);
                
            }
        }
    }
    
    
    private func displayAllCookies()
    {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies ?? []
        for cookie in cookies
        {
            print(cookie.name + " -- " + cookie.value)
        }
        
    }
    
    private func loadHijackXHRScript()
    {
        guard let path = NSBundle.mainBundle().pathForResource("interceptPOST", ofType: "js"),
                  jsString = try? String(contentsOfFile: path) else {return}
        
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
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request);
    }
//    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.loadHijackXHRScript()
    }
    
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        self.loadHijackXHRScript()
    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    {
        if let jsonString = message.body as? String
        {
            print(jsonString);
        }
    }
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
        self.whenWebViewHasPOSTRequest?(postDataAsJSON: message.toPOSTDictionary);
        
        completionHandler()
    }
    
}