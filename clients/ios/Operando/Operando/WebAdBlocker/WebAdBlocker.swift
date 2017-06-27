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
                        return
                }

                
                let actionType = self.contentBlockingEngine.action(for: request)
                if actionType == WebContentActionType.TypeBlockContent {
                    event.eventData?[kPPAllowWebViewRequestValue] = NSNumber(booleanLiteral: false)
                } else {
                    event.eventData?[kPPAllowWebViewRequestValue] = NSNumber(booleanLiteral: true)
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
