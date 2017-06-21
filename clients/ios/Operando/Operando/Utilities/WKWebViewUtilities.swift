//
//  WKWebViewUtilities.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView
{
    func getCurrentPageHtmlStringWithCompletion(completion: ((htmlString: String?) -> Void))
    {
        self.evaluateJavaScript("document.documentElement.outerHTML",
                                completionHandler: { (html: AnyObject?, error: NSError?) in
                                    completion(htmlString: html as? String);
        })
    }
}