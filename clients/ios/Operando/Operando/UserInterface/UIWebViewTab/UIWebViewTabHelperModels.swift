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
        if input.contains("http"), let url = URL(string: input) {
            return url
        }
        
        if input.contains("www."), let url = URL(string: "http://\(input)") {
            return url
        }
            
        return nil
        
    }
}



struct UIWebViewTabNavigationModel: Equatable {
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

func ==(lhs: UIWebViewTabNavigationModel, rhs: UIWebViewTabNavigationModel) -> Bool {
    return lhs.urlList == rhs.urlList && lhs.currentURLIndex == rhs.currentURLIndex
}

struct UIWebViewTabModel {
    let navigationModel: UIWebViewTabNavigationModel?
    let webView: WKWebView?
}


struct UIWebViewTabCallbacks {
    let urlForUserInput: (_ userInput: String) -> URL
    
    let whenPresentingAlertController: ((_ controller: UIAlertController) -> Void)?
    let whenCreatingExternalWebView: ((_ configuration: WKWebViewConfiguration,
    _ navigationAction: WKNavigationAction) -> WKWebView?)?
    
    let whenUserOpensInNewTab: ((_ link: URL) -> Void)?
}

struct WebTabDescription: Equatable {
    let name: String
    let screenshot: UIImage?
    let favIconURL: String?
}
func ==(lhs: WebTabDescription, rhs: WebTabDescription) -> Bool {
    return lhs.name == rhs.name
}

