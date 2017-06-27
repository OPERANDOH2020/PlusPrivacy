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
    
    
    func detectLoginInputsInWebView(webView: WKWebView, withCompletion completion: @escaping ((_ result: HTMLLoginInputDetectionResult?) -> Void))
    {
        // Naive way to check for the existence of login and password input types
        
        webView.getCurrentPageHtmlStringWithCompletion { (htmlString) in
            
            if let html = htmlString
            {
                let detectionResult = self.analyzeHTML(html: html);
                completion(detectionResult)
                return;
            }
            
            completion(nil);
        }
    }
    
    
    func analyzeHTML(html: String) -> HTMLLoginInputDetectionResult
    {
        var passwordInputId : String? = nil
        var loginInputId: String? = nil
        
        let htmlInputTypePassword = "type=\"password\"";
        let htmlInputTypeEmail = "type=\"email\"";
        
        let htmlIdEquals = "id=\"";
        
        if let rangeOfInputTypePassword = html.range(of: htmlInputTypePassword)
        {
            let searchRange = rangeOfInputTypePassword.lowerBound ..< html.endIndex
            
            if let rangeOfIdEquals =  html.range(of: htmlIdEquals, options: .literal,  range: searchRange, locale: nil)
            {
                passwordInputId = self.loopInString(sourceString: html, fromIndex: rangeOfIdEquals.upperBound, stopWhenNextCharIs: "\"")
            }
        }
        
        if let rangeOfInputTypeEmail = html.range(of: htmlInputTypeEmail)
        {
            let searchRange = rangeOfInputTypeEmail.lowerBound ..< html.endIndex
            
            
            if let  rangeOfIdEquals = html.range(of: htmlIdEquals,options: .literal, range: searchRange, locale: nil)
            {
                loginInputId = self.loopInString(sourceString: html, fromIndex: rangeOfIdEquals.upperBound, stopWhenNextCharIs: "\"")
                
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
            
            loopingIndex = sourceString.index(loopingIndex, offsetBy: 1)
            currentChar = sourceString.characters[loopingIndex]
        }
        
        return result;
    }
    
}
