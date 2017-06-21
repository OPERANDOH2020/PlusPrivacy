//
//  FbWebKitSecurityEnforcer.swift
//  Operando
//
//  Created by Costin Andronache on 8/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit


enum POSTRequestStatus: String
{
    case Finished = "finished"
    case TerminatedWithError = "terminated"
}

extension NSHTTPCookieStorage
{
    func cookieHeadersFromURL(url: String) -> [String: String]
    {
        guard let urlURL = NSURL(string: url) else {return [:]}
        let cookies = self.cookies
        return NSHTTPCookie.requestHeaderFieldsWithCookies(cookies ?? []);
    }
}

typealias CallToLoginWithCompletion = (callbackWhenLoginIsDone: VoidBlock?) -> Void

extension UIWebView
{
    func loadWebViewToURL(urlString: String) -> NSError?
    {
        guard let url = NSURL(string: urlString) else {return NSError.malformedURLError(urlString);}
        self.loadRequest(NSURLRequest(URL: url));
        return nil;
    }
    
    func loadAndExecuteScriptNamed(scriptName: String, withCompletion completion: ((result: AnyObject?, error: NSError?) -> Void)?)
    {
        guard let filePath = NSBundle.mainBundle().pathForResource(scriptName, ofType: "js") else {completion?(result: nil, error: nil);return}
        if let jsString = try? NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        {
            let result = self.stringByEvaluatingJavaScriptFromString(jsString as String);
            completion?(result: result, error: nil);
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
    
    
    func evaluateJavaScript(script: String, completionHandler: ((result: AnyObject?, error: NSError?) -> Void)?)
    {
        let result = self.stringByEvaluatingJavaScriptFromString(script)
        completionHandler?(result: result, error: nil);
    }
}

class FbWebKitSecurityEnforcer: NSObject, WKNavigationDelegate, WKUIDelegate
{
    private let webView: WKWebView
    private var whenWebViewFinishesNavigation: VoidBlock?
    
    init(webView: WKWebView)
    {
        self.webView = webView
        super.init()
        self.webView.UIDelegate = self
        self.webView.navigationDelegate = self
        
    }
    
    
    func enforceWithCallToLogin(callToLoginWithCompletion: CallToLoginWithCompletion?, completion: ((error: NSError?) -> Void)?)
    {

        if let error = self.webView.loadWebViewToURL("https://www.facebook.com")
        {
            completion?(error: error);
            return
        }
        weak var weakSelf = self
        
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC))
        dispatch_after(delay, dispatch_get_main_queue())
        {
            callToLoginWithCompletion?{
                self.loginIsDoneInitiateNextStep()
            }
            
            weakSelf?.whenWebViewFinishesNavigation = nil;
            
        }
        
    }
    
    
    private func loginIsDoneInitiateNextStep()
    {
        self.webView.loadAndExecuteScriptNamed("facebook_iOS") { (result, error) in
            print(error);
            print(result);
        }
    }
    
    private func loadJSFileInWebView()
    {
        let jsFile = self.getJSFile()
        let userScript = WKUserScript(source: jsFile, injectionTime: WKUserScriptInjectionTime.AtDocumentStart, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)
    }
    
    private func getJSFile() -> String
    {
        guard let path = NSBundle.mainBundle().pathForResource("facebook_iOS", ofType: "js") else {return ""}
        let js = try? String(contentsOfFile: path)
        return js ?? ""
    }
    
    //MARK: WKWebView delegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.whenWebViewFinishesNavigation?();
    }
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        print(message);
        completionHandler()
    }
    
    
    //MARK: UIWebView delegate
    

    
    
    //

    
    
}
