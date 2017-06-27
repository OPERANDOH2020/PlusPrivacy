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
    func getCurrentPageHtmlStringWithCompletion(completion: @escaping ((_ htmlString: String?) -> Void))
    {
        self.evaluateJavaScript("document.documentElement.outerHTML",
                                completionHandler: { (html: Any?, error: Error?) in
                                    completion(html as? String);
        })
    }
}
