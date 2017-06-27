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



typealias CallToLoginWithCompletion = (_ callbackWhenLoginIsDone: VoidBlock?) -> Void

let kMessageTypeKey = "messageType";

let kLogMessageTypeContentKey = "logContent";
let kLogMessageType = "log";

let kStatusMessageMessageType = "statusMessageType";
let kStatusMessageContentKey = "statusMessageContent";

class FbWebKitSecurityEnforcer: NSObject, WKNavigationDelegate, WKUIDelegate
{
    private let webView: WKWebView
    private var whenWebViewFinishesNavigation: VoidBlock?
    private var whenDisplayingMessage: ((_ message: String) -> Void)?
    
    
    init(webView: WKWebView)
    {
        self.webView = webView
        super.init()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        
    }
    
    
    func enforceWithCallToLogin(callToLoginWithCompletion: CallToLoginWithCompletion?, whenDisplayingMessage: ((_ message: String) -> Void)? ,completion: ((_ error: NSError?) -> Void)?)
    {
        let socialMediaUrl = ACPrivacyWizard.shared.selectedScope.getNetworkUrl()
        
        if let error = self.webView.loadWebViewToURL(urlString: socialMediaUrl)
        {
            completion?(error);
            return
        }
        
        self.whenDisplayingMessage = whenDisplayingMessage;
        
        weak var weakSelf = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { 
            callToLoginWithCompletion?{
                self.loginIsDoneInitiateNextStep()
            }
            
            weakSelf?.whenWebViewFinishesNavigation = nil;

        }
    }
    
    
    private func loginIsDoneInitiateNextStep() {
        let resource = ACPrivacyWizard.shared.selectedScope.getWizardResourceName()
        
        self.webView.loadJQueryIfNeededWithCompletion(completion: {
            self.webView.loadAndExecuteScriptNamed(scriptName: resource) { (result, error) in
                print(error)
            }
        })
    }
    
    private func loadJSFileInWebView()
    {
        let jsFile = self.getJSFile()
        let userScript = WKUserScript(source: jsFile, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        self.webView.configuration.userContentController.addUserScript(userScript)
    }
    
    private func getJSFile() -> String
    {
        let resource = ACPrivacyWizard.shared.selectedScope.getWizardResourceName()
        guard let path = Bundle.main.path(forResource: resource, ofType: "js") else {return ""}
        let js = try? String(contentsOfFile: path)
        return js ?? ""
    }
    
    //MARK: WKWebView delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.whenWebViewFinishesNavigation?()
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler();
        
        if let data = message.data(using: String.Encoding.utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let messageDict = jsonObject as? [String: String]
        {
            self.handleMessage(message: messageDict)
        }
        
    }
    

    
    //MARK: internal utils
    
    private func handleMessage(message: [String: String])
    {
        guard let messageType = message[kMessageTypeKey] else {return}
        
        if messageType == kLogMessageType
        {
            print(message[kLogMessageTypeContentKey])
            return;
        }
        
        //
        if let statusMessage = message[kStatusMessageContentKey]
        {
            self.whenDisplayingMessage?(statusMessage)
        }
    }
}
