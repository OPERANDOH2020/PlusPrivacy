//
//  WKWebView+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 3/15/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit
import WebKit

extension WKWebView {
    
    func stringByEvaluatingJavaScriptFromString(script: String) -> Bool {
        var success = false
        var finished: Bool = false
        
        self.evaluateJavaScript(script) { (result, error) in
            if error == nil {
                if result != nil {
                    success = true
                }
            }
            else {
                NSLog("evaluateJavaScript error : %@", error?.localizedDescription ?? "Nil Error")
            }
            finished = true
        }
        
        while !finished {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
        
        return success
    }
}
