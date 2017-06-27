//
//  UIWebViewTabHelperModels.swift
//  Operando
//
//  Created by Costin Andronache on 3/29/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
import WebKit

extension URL {
    static func tryBuildWithHttp(with input: String) -> URL? {
        if let url = URL(string: input), input.contains("http") {
            return url
        }
        
        if let url = URL(string: "http://\(input)") {
            return url
        }
        
        if let url = URL(string: "http://www.\(input)") {
            return url
        }
        
        return nil
        
    }
}



struct UIWebViewTabNavigationModel {
    let urlList: [URL]
    let currentURLIndex: Int
    init?(urlList: [URL], currentURLIndex: Int) {
        guard currentURLIndex < urlList.count && currentURLIndex >= 0 else {
            return nil
        }
        self.urlList = urlList
        self.currentURLIndex = currentURLIndex
    }
}

enum WebViewSetupParameter {
    case fullConfiguration(WKWebViewConfiguration)
    case processPool(WKProcessPool)
}

struct UIWebViewTabNewWebViewModel {
    let navigationModel: UIWebViewTabNavigationModel?
    let setupParameter: WebViewSetupParameter
}


struct UIWebViewTabCallbacks {
    let whenUserChoosesToViewTabs: VoidBlock?
    let urlForUserInput: (_ userInput: String) -> URL
    
    let whenPresentingAlertController: ((_ controller: UIAlertController) -> Void)?
    let whenCreatingExternalWebView: ((_ configuration: WKWebViewConfiguration,
    _ navigationAction: WKNavigationAction) -> WKWebView?)?
    
    let whenUserOpensInNewTab: ((_ link: URL) -> Void)?
}

struct WebTabDescription {
    let name: String
    let screenshot: UIImage?
    let favIconURL: String?
}
