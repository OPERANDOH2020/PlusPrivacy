//
//  OPLoginInputDetector.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import WebKit

struct HTMLLoginInputDetectionResult
{
    let loginInputId : String?
    let passwordInputId: String?
}

class HTMLLoginInputDetector: NSObject
{
    
    
    func detectLoginInputsInWebView(webView: WKWebView, withCompletion completion: ((result: HTMLLoginInputDetectionResult?) -> Void))
    {
        // Naive way to check for the existence of login and password input types
        
        webView.getCurrentPageHtmlStringWithCompletion { (htmlString) in
            
            if let html = htmlString
            {
                let detectionResult = self.analyzeHTML(html);
                completion(result: detectionResult)
                return;
            }
            
            completion(result: nil);
        }
    }
    
    
    func analyzeHTML(html: String) -> HTMLLoginInputDetectionResult
    {
        var passwordInputId : String? = nil
        var loginInputId: String? = nil
        
        let htmlInputTypePassword = "type=\"password\"";
        let htmlInputTypeEmail = "type=\"email\"";
        
        let htmlIdEquals = "id=\"";
        
        if let rangeOfInputTypePassword = html.rangeOfString(htmlInputTypePassword, options: .LiteralSearch)
        {
            let searchRange = rangeOfInputTypePassword.startIndex ... html.endIndex.predecessor()
            if let rangeOfIdEquals =  html.rangeOfString(htmlIdEquals,options: .LiteralSearch, range: searchRange)
            {
                passwordInputId = self.loopInString(html, fromIndex: rangeOfIdEquals.endIndex, stopWhenNextCharIs: "\"")
            }
        }
        
        if let rangeOfInputTypeEmail = html.rangeOfString(htmlInputTypeEmail, options: .LiteralSearch)
        {
            let searchRange = rangeOfInputTypeEmail.startIndex ... html.endIndex.predecessor()
            if let  rangeOfIdEquals = html.rangeOfString(htmlIdEquals,options: .LiteralSearch, range: searchRange)
            {
                loginInputId = self.loopInString(html, fromIndex: rangeOfIdEquals.endIndex, stopWhenNextCharIs: "\"")
                
            }
        }
        
        return HTMLLoginInputDetectionResult(loginInputId: loginInputId, passwordInputId: passwordInputId)
    }
    
    private func loopInString(sourceString: String, fromIndex index: String.CharacterView.Index,  stopWhenNextCharIs limitChar: Character) -> String
    {
        var result = "";
        var currentChar = sourceString.characters[index];
        var loopingIndex = index
        
        while currentChar != limitChar {
            result.append(currentChar);
            loopingIndex = loopingIndex.advancedBy(1);
            currentChar = sourceString.characters[loopingIndex]
        }
        
        return result;
    }
    
}