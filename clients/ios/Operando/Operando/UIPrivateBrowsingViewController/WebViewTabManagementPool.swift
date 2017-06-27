//
//  WebViewTabManagementPool.swift
//  Operando
//
//  Created by Costin Andronache on 3/22/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
import UIKit

class WebViewTabManagementPool {
    
    class WebViewTabDatePair {
        var webViewTab: UIWebViewTab
        var date: Date
        init(webViewTab: UIWebViewTab) {
            self.webViewTab = webViewTab
            self.date = Date()
        }
    }
    
    private var webTabViews: [WebViewTabDatePair] = []
    var allWebViewTabs: [UIWebViewTab] {
        let result = self.webTabViews.map({$0.webViewTab})
        return result
    }
    
    func addNew(webViewTab: UIWebViewTab) {
        self.webTabViews.append(WebViewTabDatePair(webViewTab: webViewTab))
    }
    
    func markWebViewTab(_ webViewTab: UIWebViewTab) {
        guard let webDatePair = self.webTabViews.first(where: { pair -> Bool in
            return pair.webViewTab == webViewTab
        }) else {
            return
        }
        webDatePair.date = Date()
    }
    
    var oldestWebViewTab : UIWebViewTab? {
        guard let first = self.webTabViews.first else {
            return nil
        }
        
        
        let now: Date = Date()
        var maxTime: TimeInterval = 0
        var result = first;
        for candidate in self.webTabViews {
            let elapsedTime = now.timeIntervalSince(candidate.date)
            if  elapsedTime > maxTime {
                result = candidate;
                maxTime = elapsedTime
            }
        }
        
        return result.webViewTab
    }
    
}
