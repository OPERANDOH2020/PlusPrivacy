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
        
        button?.addTarget(self, action: #selector(WebViewSettingsReader.loginFinishedButtonDidPress(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    
    private func clearAllCallbacks()
    {
        self.whenWebViewFinishesLoad = nil
        self.whenWebViewLoadsWithError = nil
        self.whenLoginButtonIsPressed = nil
    }
    
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?)
    {
        if let error = self.loadWebViewToURL(urlString: site)
        {
            completion?(error)
            return
        }
        
        self.clearAllCallbacks()
        
        weak var weakSelf = self
        self.whenWebViewLoadsWithError = completion
        self.whenWebViewFinishesLoad = {
            
            weakSelf?.whenWebViewFinishesLoad = nil
            RSCommonUtilities.showOKAlertWithMessage(message: alertLoginMessage)
            weakSelf?.whenLoginButtonIsPressed =
            {
                weakSelf?.clearAllCallbacks()
                completion?(nil)
            }
            
        }
    }
    
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((_ readSettings: NSDictionary?, _ error: NSError?) -> Void)?)
    {
        self.clearAllCallbacks()
        weak var weakSelf = self
        
        if self.isCurrentPageOnWebViewAtAddress(urlString: address)
        {
            self.readSettingsBasedOnJsonString(settingsAsJsonString: settingsAsJsonString, completion: completion)
            return;
        }
        
        if let error = self.loadWebViewToURL(urlString: address)
        {
            completion?(nil, error)
            return
        }
        
        self.whenWebViewFinishesLoad = {
            weakSelf?.whenWebViewFinishesLoad = nil
            weakSelf?.readSettingsBasedOnJsonString(settingsAsJsonString: settingsAsJsonString, completion: completion)
        }
        
        self.whenWebViewLoadsWithError = { error in
            weakSelf?.whenWebViewLoadsWithError = nil
            completion?(nil,error)
        }
    }
    
    
    private func readSettingsBasedOnJsonString(settingsAsJsonString: String, completion: ((_ readSettings: NSDictionary?, _ error: NSError?) -> Void)?)
    {
        
        loadJQueryIfNeeded()
        loadReadingFunctionInWebView()
        let escapedString = settingsAsJsonString.replacingOccurrences(of: "\"", with: "\\\"").replacingOccurrences(of: "\'", with: "\\\'")
        
        let _ = self.webView?.stringByEvaluatingJavaScript(from: "window.readSettings(\"\(escapedString)\")")
        
        
        completion?(nil, nil)
    }
    
    private func loadReadingFunctionInWebView()
    {
        self.loadAndExecuteScriptNamed(scriptName: "readSNSettings")
    }
    
    private func loadJQueryIfNeeded()
    {
        let exists = self.loadAndExecuteScriptNamed(scriptName: "testJQuery")
        if exists == "false"
        {
            self.loadAndExecuteScriptNamed(scriptName: "jquery214min")
        }
    }
    
    
    @discardableResult
    private func loadAndExecuteScriptNamed(scriptName: String) -> String
    {
        guard let filePath = Bundle.main.path(forResource: scriptName, ofType: "js") else {return ""}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        {
            return self.webView?.stringByEvaluatingJavaScript(from: jsString as String) ?? ""
        }
        
        return ""
    }
    
    //MARK: UIWebViewDelegate and button action
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.whenWebViewFinishesLoad?()
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
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(url: urlString)}
        let request = NSURLRequest(url: url as URL)
        
        self.webView?.loadRequest(request as URLRequest)
        
        return nil
    }
}
