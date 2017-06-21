//
//  WebKitSettingsReader.swift
//  Operando
//
//  Created by Costin Andronache on 8/12/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import WebKit


extension WKWebView
{
    func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((result: AnyObject?, error: NSError?) -> Void)?)
    {
        guard let filePath = NSBundle.mainBundle().pathForResource(scriptName, ofType: "js") else {completion?(result: nil, error: nil);return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            self.evaluateJavaScript(jsString as String, completionHandler: completion)
        }
    }
    
    func loadJQueryIfNeededWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed("testJQuery") { (result, error) in
            if let resultString = result as? String
            {
                if resultString == "true"
                {
                    completion?();
                    return;
                }
                
                self.loadAndExecuteScriptNamed("jquery214min", withCompletion: { (result, error) in
                    if error == nil
                    {
                        completion?()
                    }
                })
            }
        }
    }
    
    func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString);}
        let request = NSURLRequest(URL: url);
        self.loadRequest(request)
        
        return nil
    }

}

extension String
{
    var escapedStringForJS: String
    {
        return self.stringByReplacingOccurrencesOfString("\"", withString: "\\\"").stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
    }
}

class WebKitSettingsReader : NSObject, OSPSettingsReader, WKNavigationDelegate
{
    
    private(set) var webView : WKWebView
    private var whenNavigationFails: ErrorCallback?
    private var whenNavigationFinishes: VoidBlock?
    private var whenUserFinishedLogin: VoidBlock?
    
    init(loginIsDoneButton: UIButton, webView: WKWebView)
    {
        self.webView = webView
        super.init()
        self.webView.navigationDelegate = self
        
        loginIsDoneButton.addTarget(self, action: #selector(WebKitSettingsReader.didPressFinishLoginButton(_:)), forControlEvents: .TouchUpInside);
    }
    
    
    private func clearAllCallbacks()
    {
        self.whenUserFinishedLogin = nil
        self.whenNavigationFails = nil
        self.whenNavigationFinishes = nil
    }
    
    
    func didPressFinishLoginButton(sender: UIButton)
    {
        self.whenUserFinishedLogin?()
    }
    
    
    
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?) {
        if let error = self.loadWebViewToURL(site)
        {
            completion?(error: error)
            return
        }
        
        self.clearAllCallbacks()
        
        weak var weakSelf = self
        self.whenNavigationFails = completion
        self.whenNavigationFinishes = {
            
            weakSelf?.whenNavigationFinishes = nil
            RSCommonUtilities.showOKAlertWithMessage(alertLoginMessage)
            weakSelf?.whenUserFinishedLogin =
                {
                    weakSelf?.clearAllCallbacks()
                    completion?(error: nil)
            }
            
        }

    }
    
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        self.clearAllCallbacks()
        
        let escapedString = settingsAsJsonString.escapedStringForJS
        
        let jsToExecute = "window.readSettings(\"\(escapedString)\")";
        
        if self.isWebViewAlreadyAtURL(address)
        {
            self.extractSettingsByExecuting(jsToExecute, withCompletion: completion);
            return;
        }
        
        weak var weakSelf = self
        
        if let error = self.loadWebViewToURL(address)
        {
            completion?(readSettings: nil, error: error);
            return;
        }
        
        self.whenNavigationFails = { error in
            completion?(readSettings: nil, error: error)
            weakSelf?.clearAllCallbacks()
        }
        
        self.whenNavigationFinishes = {
            weakSelf?.extractSettingsByExecuting(jsToExecute, withCompletion: completion)
            weakSelf?.clearAllCallbacks()
        }
        
        
    }
    
    
    private func extractSettingsByExecuting(jsToExecute: String, withCompletion completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
    {
        self.loadJQueryIfNeededWithCompletion {
            self.loadReadingFunctionInWebViewWithCompletion{
                self.webView.evaluateJavaScript(jsToExecute, completionHandler: { result, error in
                    if let error = error
                    {
                        completion?(readSettings: nil, error: error);
                        return;
                    }
                    
                    if let resultString = result as? String, resultData = resultString.dataUsingEncoding(NSUTF8StringEncoding),
                        resultJsonObj = try? NSJSONSerialization.JSONObjectWithData(resultData, options: .AllowFragments),
                        resultDict = resultJsonObj as? NSDictionary
                    {
                        print(resultString);
                        completion?(readSettings: resultDict, error: nil)
                        return;
                    }
                    
                    completion?(readSettings: nil, error: NSError.errorReadingSettings)
                    
                })
            }
        }
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.whenNavigationFinishes?()
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        self.whenNavigationFails?(error: error)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.Allow)
    }
    
    //MARK: internal utils
    
    private func isWebViewAlreadyAtURL(urlString: String) -> Bool
    {
        if let url = self.webView.URL?.absoluteString
        {
            if url == urlString
            {
                return true
            }
        }
        
        return false
    }
    
    
    private func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString);}
        let request = NSURLRequest(URL: url);
        self.webView.loadRequest(request)
        
        return nil
    }
    
    
    private func loadJQueryIfNeededWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed("testJQuery") { (result, error) in
            if let resultString = result as? String
            {
                if resultString == "true"
                {
                    completion?();
                    return;
                }
                
                self.loadAndExecuteScriptNamed("jquery214min", withCompletion: { (result, error) in
                    if error == nil
                    {
                        completion?()
                    }
                })
            }
            
        }
    }
    
    private func loadReadingFunctionInWebViewWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed("readSNSettings") { (result, error) in
            if error == nil || error?.code == 5
            {
                completion?()
            }
        }
    }
    
    private func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((result: AnyObject?, error: NSError?) -> Void)?)
    {
        guard let filePath = NSBundle.mainBundle().pathForResource(scriptName, ofType: "js") else {completion?(result: nil, error: nil);return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            self.webView.evaluateJavaScript(jsString as String, completionHandler: completion)
        }
        
    }
    
}