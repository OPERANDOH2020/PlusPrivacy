//
//  WebViewSettingsReader.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

extension NSError
{
    static func malformedURLError(url: String) -> NSError
    {
        return NSError(domain: "com.operando.operando", code: -8, userInfo: [NSLocalizedDescriptionKey : "Received a malformed url: \(url) \n Please send a screenshot to support for this issue"])
    }
}

let alertLoginMessage = "Please login with your own credentials on this site, and press the 'Done' button when you're finished"

class WebViewSettingsReader: NSObject, OSPSettingsReader, UIWebViewDelegate
{
    weak var webView: UIWebView?
    weak var button: UIButton?
    
    var whenLoginButtonIsPressed: VoidBlock?
    var whenWebViewFinishesLoad: VoidBlock?
    var whenWebViewLoadsWithError: ErrorCallback?
    
    
    init(loginFinishedButton: UIButton?, webView: UIWebView?)
    {
        self.webView = webView
        self.button = loginFinishedButton
        super.init()
        webView?.delegate = self
        
        button?.addTarget(self, action: #selector(WebViewSettingsReader.loginFinishedButtonDidPress(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    private func clearAllCallbacks()
    {
        self.whenWebViewFinishesLoad = nil
        self.whenWebViewLoadsWithError = nil
        self.whenLoginButtonIsPressed = nil
    }
    
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?)
    {
        if let error = self.loadWebViewToURL(site)
        {
            completion?(error: error)
            return
        }
        
        self.clearAllCallbacks()
        
        weak var weakSelf = self
        self.whenWebViewLoadsWithError = completion
        self.whenWebViewFinishesLoad = {
            
            weakSelf?.whenWebViewFinishesLoad = nil
            RSCommonUtilities.showOKAlertWithMessage(alertLoginMessage)
            weakSelf?.whenLoginButtonIsPressed =
            {
                weakSelf?.clearAllCallbacks()
                completion?(error: nil)
            }
            
        }
    }
    
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        self.clearAllCallbacks()
        weak var weakSelf = self
        
        if self.isCurrentPageOnWebViewAtAddress(address)
        {
            self.readSettingsBasedOnJsonString(settingsAsJsonString, completion: completion)
            return;
        }
        
        if let error = self.loadWebViewToURL(address)
        {
            completion?(readSettings: nil, error: error)
            return
        }
        
        self.whenWebViewFinishesLoad = {
            weakSelf?.whenWebViewFinishesLoad = nil
            weakSelf?.readSettingsBasedOnJsonString(settingsAsJsonString, completion: completion)
        }
        
        self.whenWebViewLoadsWithError = { error in
            weakSelf?.whenWebViewLoadsWithError = nil
            completion?(readSettings: nil, error: error)
        }
    }
    
    
    private func readSettingsBasedOnJsonString(settingsAsJsonString: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        
        loadJQueryIfNeeded()
        loadReadingFunctionInWebView()
        let escapedString = settingsAsJsonString.stringByReplacingOccurrencesOfString("\"", withString: "\\\"").stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
        
        let results = self.webView?.stringByEvaluatingJavaScriptFromString("window.readSettings(\"\(escapedString)\")")
        
        
        completion?(readSettings: nil, error: nil)
    }
    
    private func loadReadingFunctionInWebView()
    {
        self.loadAndExecuteScriptNamed("readSNSettings")
    }
    
    private func loadJQueryIfNeeded()
    {
        let exists = self.loadAndExecuteScriptNamed("testJQuery")
        if exists == "false"
        {
            self.loadAndExecuteScriptNamed("jquery214min")
        }
    }
    
    
    
    private func loadAndExecuteScriptNamed(scriptName: String) -> String
    {
        guard let filePath = NSBundle.mainBundle().pathForResource(scriptName, ofType: "js") else {return ""}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            return self.webView?.stringByEvaluatingJavaScriptFromString(jsString as String) ?? ""
        }
        
        return ""
    }
    
    //MARK: UIWebViewDelegate and button action
    func webViewDidFinishLoad(webView: UIWebView) {
        self.whenWebViewFinishesLoad?()
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        return;
        self.whenWebViewLoadsWithError?(error: error)
    }
    
    
    func loginFinishedButtonDidPress(sender: UIButton)
    {
        self.whenLoginButtonIsPressed?()
    }
    
    private func isCurrentPageOnWebViewAtAddress(urlString: String) -> Bool
    {
        if let currentURL = self.webView?.request?.mainDocumentURL?.absoluteString
        {
            if urlString == currentURL{
                return true;
            }
        }
        
        return false;
    }
    
    private func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString)}
        let request = NSURLRequest(URL: url)
        
        self.webView?.loadRequest(request)
        
        return nil
    }
}