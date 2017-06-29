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
            
            
            PPEventDispatcher.sharedInstance().appendNewEventHandler({ (event, next) in
                defer {
                    next?()
                }
                
                guard event.eventIdentifier.eventType == PPEventType.PPWKWebViewEvent,
                    let request = event.eventData?[kPPWebViewRequest] as? URLRequest else {
                        next?()
                        return
                }
                
                print(request)
                
                let actionType = self.contentBlockingEngine.action(for: request)
                if actionType == WebContentActionType.TypeBlockContent && self.adBlockingEnabled {
                    event.eventData?[kPPBlockWebViewRequestValue] = NSNumber(booleanLiteral: true)
                } else {
                    event.eventData?[kPPBlockWebViewRequestValue] = NSNumber(booleanLiteral: false)
                }
                
            })
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
}
