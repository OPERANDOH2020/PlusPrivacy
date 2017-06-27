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
    func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((_ result: Any?, _ error: Error?) -> Void)?) {
        guard let filePath = Bundle.main.path(forResource: scriptName, ofType: "js"), let privacySettingsJson = ACPrivacyWriter.privacyOptionsJsonString()
            else { completion?(nil, nil); return }
        
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) {
            let modifiedJS = jsString.replacingOccurrences(of: "RS_PARAM_PLACEHOLDER", with: "\"\(privacySettingsJson.escapedStringForJS)\"")
            print(modifiedJS)
            self.evaluateJavaScript(modifiedJS as String, completionHandler: completion)
        }
    }
    
    func loadJQueryIfNeededWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed(scriptName: "testJQuery") { (result, error) in
            if let resultString = result as? String
            {
                if resultString == "true"
                {
                    completion?();
                    return;
                }
                
                self.loadAndExecuteScriptNamed(scriptName: "jquery214min", withCompletion: { (result, error) in
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
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(url: urlString);}
        let request = NSURLRequest(url: url as URL);
        self.load(request as URLRequest)
        
        return nil
    }
    
}

extension String
{
    var escapedStringForJS: String
    {
        return self.replacingOccurrences(of: "\"", with: "\\\"").replacingOccurrences(of: "\'", with: "\\\'")
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
        
        loginIsDoneButton.addTarget(self, action: #selector(WebKitSettingsReader.didPressFinishLoginButton(sender:)), for: .touchUpInside);
    }
    
    
    private func clearAllCallbacks()
    {
        self.whenUserFinishedLogin = nil
        self.whenNavigationFails = nil
        self.whenNavigationFinishes = nil
    }
    
    
    
    
    @IBAction func didPressFinishLoginButton(sender: Any?)
    {
        self.whenUserFinishedLogin?()
    }
    
    
    
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?) {
        if let error = self.loadWebViewToURL(urlString: site)
        {
            completion?(error)
            return
        }
        
        self.clearAllCallbacks()
        
        weak var weakSelf = self
        self.whenNavigationFails = completion
        self.whenNavigationFinishes = {
            
            weakSelf?.whenNavigationFinishes = nil
            RSCommonUtilities.showOKAlertWithMessage(message: alertLoginMessage)
            weakSelf?.whenUserFinishedLogin =
                {
                    weakSelf?.clearAllCallbacks()
                    completion?(nil)
            }
            
        }
        
    }
    
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((_ readSettings: NSDictionary?, _ error: NSError?) -> Void)?)
    {
        self.clearAllCallbacks()
        
        let escapedString = settingsAsJsonString.escapedStringForJS
        
        let jsToExecute = "window.readSettings(\"\(escapedString)\")";
        
        if self.isWebViewAlreadyAtURL(urlString: address)
        {
            self.extractSettingsByExecuting(jsToExecute: jsToExecute, withCompletion: completion);
            return;
        }
        
        weak var weakSelf = self
        
        if let error = self.loadWebViewToURL(urlString: address)
        {
            completion?(nil, error);
            return;
        }
        
        self.whenNavigationFails = { error in
            completion?(nil, error)
            weakSelf?.clearAllCallbacks()
        }
        
        self.whenNavigationFinishes = {
            weakSelf?.extractSettingsByExecuting(jsToExecute: jsToExecute, withCompletion: completion)
            weakSelf?.clearAllCallbacks()
        }
        
        
    }
    
    
    private func extractSettingsByExecuting(jsToExecute: String, withCompletion completion: ((_ readSettings: NSDictionary?, _ error: NSError?) -> Void)?)
    {
        self.loadJQueryIfNeededWithCompletion {
            self.loadReadingFunctionInWebViewWithCompletion{
                self.webView.evaluateJavaScript(jsToExecute, completionHandler: { result, error in
                    if let error = error
                    {
                        completion?(nil, error as NSError?);
                        return;
                    }
                    
                    if let resultString = result as? String,
                        let resultData = resultString.data(using: String.Encoding.utf8),
                        let resultJsonObj = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments),
                        let resultDict = resultJsonObj as? NSDictionary
                    {
                        print(resultString);
                        completion?(resultDict, nil)
                        return;
                    }
                    
                    completion?(nil, NSError.errorReadingSettings)
                    
                })
            }
        }
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.whenNavigationFinishes?()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.whenNavigationFails?(error as NSError?)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    
    //MARK: internal utils
    
    private func isWebViewAlreadyAtURL(urlString: String) -> Bool
    {
        if let url = self.webView.url?.absoluteString
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
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(url: urlString);}
        let request = NSURLRequest(url: url as URL);
        self.webView.load(request as URLRequest)
        
        return nil
    }
    
    
    private func loadJQueryIfNeededWithCompletion(completion: VoidBlock?)
    {
        self.loadAndExecuteScriptNamed(scriptName: "testJQuery") { (result, error) in
            if let resultString = result as? String
            {
                if resultString == "true"
                {
                    completion?();
                    return;
                }
                
                self.loadAndExecuteScriptNamed(scriptName: "jquery214min", withCompletion: { (result, error) in
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
        self.loadAndExecuteScriptNamed(scriptName: "readSNSettings") { (result, error) in
            if error == nil || (error as? NSError)?.code ?? 0 == 5
            {
                completion?()
            }
        }
    }
    
    private func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((_ result: Any?, _ error: Error?) -> Void)?)
    {
        guard let filePath = Bundle.main.path(forResource: scriptName, ofType: "js") else {completion?(nil, nil);return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        {
            self.webView.evaluateJavaScript(jsString as String, completionHandler: completion)
        }
        
    }
    
}
