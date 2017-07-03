//
//  WebAdBlocker.swift
//  Operando
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PPWebContentBlocker
import PPApiHooksCore

extension NSError {
    static let errorContentBlocked: NSError = NSError(domain: "com.plusPrivacy.WebAdBlocker", code: -1, userInfo: nil)
}

class WebAdBlocker: NSObject {
    
    private var identifier: String?
    private let contentBlockingEngine: PPWebContentBlockerEngine = PPWebContentBlockerEngine()
    private var didInitEngine: Bool = false
    
    var adBlockingEnabled: Bool = true
    var protectionEnabled: Bool = true {
        didSet {
            if protectionEnabled {
                PPApiHooks_enableWebKitURLMonitoring();
            } else {
                PPApiHooks_disableWebKitURLMonitoring();
            }
        }
    }
    
    private func initEngineWith(completion: VoidBlock?) {
        weak var weakSelf = self;
        self.contentBlockingEngine.prepare { error in
            if error == nil {
                weakSelf?.didInitEngine = true
                completion?()
            }
        }
    }
    
    func beginBlocking() {
        
        let blockIfEngineInitialized: VoidBlock = {
            if let identifier = self.identifier {
                PPEventDispatcher.sharedInstance().removeHandler(withIdentifier: identifier)
            }
            self.registerAndProcessEvents()
        }
        
        if self.didInitEngine {
            blockIfEngineInitialized()
        } else {
            self.initEngineWith(completion: blockIfEngineInitialized)
        }
        
    }
    
    func endBlocking() {
        if let identifier = self.identifier {
            PPEventDispatcher.sharedInstance().removeHandler(withIdentifier: identifier)
        }
    }
    
    private func shouldBlockRequest(_ request: URLRequest) -> Bool {
        guard self.adBlockingEnabled else {
            return false
        }
        
        let actionType = self.contentBlockingEngine.action(for: request)
        return actionType == WebContentActionType.TypeBlockContent

    }
    
    private func registerAndProcessEvents() {
        PPEventDispatcher.sharedInstance().appendNewEventHandler({ (event, next) in
            defer {
                next?()
            }
            
            guard event.eventIdentifier.eventType == PPEventType.PPWKWebViewEvent,
                let request = event.eventData?[kPPWebViewRequest] as? URLRequest else {
                    return
            }
            
            if event.eventIdentifier.eventSubtype == PPWKWebViewEventType.EventShouldInterceptWebViewRequest.rawValue {
                if self.shouldBlockRequest(request) {
                    event.eventData?[kPPShouldInterceptWebViewRequestValue] = NSNumber(booleanLiteral: true)
                }
            }
            
            if event.eventIdentifier.eventSubtype == PPWKWebViewEventType.EventGetErrorForRequestIfAny.rawValue {
                if self.shouldBlockRequest(request) {
                    event.eventData?[kPPErrorForWebViewRequest] = NSError.errorContentBlocked
                }
            }
            
            if event.eventIdentifier.eventSubtype == PPWKWebViewEventType.EventGetAlternateRequestForWebViewRequest.rawValue {
                
                var modifiedRequest = request
                modifiedRequest.allHTTPHeaderFields?.removeValue(forKey: "Referer")
                modifiedRequest.allHTTPHeaderFields?["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0";
                
                if let body = modifiedRequest.httpBody,
                    let bodyString: String = String(data: body, encoding: .utf8){
                    print("Request body: \(bodyString)\n")
                }
                
                print(modifiedRequest.allHTTPHeaderFields!)
                event.eventData?[kPPAlternateRequestForWebViewRequest] = modifiedRequest
            }
            
        })

    }
}
