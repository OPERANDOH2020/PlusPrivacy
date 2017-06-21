//
//  FacebookSecurityEnforcer.swift
//  Operando
//
//  Created by Costin Andronache on 8/17/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import JavaScriptCore
import WebKit

protocol WebRequestHelper {
    func makeRequest(request: NSURLRequest, withCompletion completion: ((error: NSError?, cookiesHeaderString: String, responseText: String) -> Void)?);
}

protocol FacebookPostParametersProvider {
    func getCurrentUserParametersWithCompletion(completion: ((error: NSError?, params: [String: String]) -> Void)?)
}

struct PrivacySetting
{
    let name: String
    let getURL: String
    let postURL: String
    let data: [String : AnyObject]
    
    
}

extension NSMutableURLRequest
{
    func setRequestHeader(header: String, value: String)
    {
        self.setValue(value, forHTTPHeaderField: header)
    }
}

class FbJSLogger: NSObject
{
    class func logObject(obj: Any)
    {
        print(obj);
    }
}

extension NSDictionary
{
    var postBodyString: String
    {
        var result: String = ""
        var keys = Array(self.allKeys)
        keys.sortInPlace { (a, b) -> Bool in
            return "\(a)" < "\(b)"
        }
        
        for i in 0..<keys.count
        {
            
            if let key = keys[i] as? String,
                value = self[key]
            {
                let stringValue = "\(value)"
                result.appendContentsOf("\(key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)=\(stringValue.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
                
                if i < keys.count-1
                {
                    result.appendContentsOf("&")
                }
            }
        }
        
        return result
    }

}

extension Dictionary where Key: StringLiteralConvertible, Value: StringLiteralConvertible
{
    var postBodyString: String
    {
        var result: String = ""
        var keys = Array(self.keys)
        keys.sortInPlace { (a, b) -> Bool in
            return "\(a)" < "\(b)"
        }
        
        for i in 0..<keys.count
        {
            if let key = keys[i] as? String,
                value = self[keys[i]] as? String
            {
                result.appendContentsOf("\(key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)=\(value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
                
                if i < keys.count-1
                {
                    result.appendContentsOf("&")
                }
            }
        }
        
        return result
    }
}


class NSURLSessionWebHelper : WebRequestHelper
{
    func makeRequest(request: NSURLRequest, withCompletion completion: ((error: NSError?, cookiesHeaderString: String, responseText: String) -> Void)?) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else {completion?(error: error, cookiesHeaderString: "", responseText: ""); return;}
            guard let data = data, response = response as? NSHTTPURLResponse
                else {completion?(error: nil, cookiesHeaderString: "", responseText: ""); return;}
            
            //most likely, it's UTF-8 encoded
            if let responseText = NSString(data: data, encoding: NSUTF8StringEncoding)
            {
                let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response.allHeaderFields as! [String: String], forURL: request.URL!)
                
                completion?(error: nil, cookiesHeaderString: self.buildCookiesHeaderValueFromCookies(cookies), responseText: responseText as String)
                return;
            }
            
            completion?(error: nil, cookiesHeaderString: "", responseText: "");
        }
        
        task.resume()
    }
    
    func buildCookiesHeaderValueFromCookies(cookies: [NSHTTPCookie]) -> String
    {
        var result = "";
        
        cookies.forEach { (cookie: NSHTTPCookie) -> Void in
            result.appendContentsOf("\(cookie.name)=\(cookie.value);")
        }
        
        return result;
    }
}


class FacebookSecurityEnforcer
{
    private var postParamsProvider: FacebookPostParametersProvider?
    private var webRequestHelper: WebRequestHelper?
    private let jsContext = JSContext()
    private var webView = WKWebView()
    
    private var fbdata: [String: AnyObject] = [:];
    
    let settings: [PrivacySetting] = [PrivacySetting(  name: "Who can see your future posts?",
                                                     getURL: "https://www.facebook.com/settings?tab=privacy&section=composer&view",
                                                    postURL: "https://www.facebook.com/privacy/selector/update/?privacy_fbid=0&post_param=291667064279714&render_location=22&is_saved_on_select=true&should_return_tooltip=true&prefix_tooltip_with_app_privacy=false&replace_on_select=false&ent_id=0&tag_expansion_button=friends_of_tagged&__pc=EXP1%3ADEFAULT",
                                                       data: [:])];
    
    
    
    
    init(paramsProvider: FacebookPostParametersProvider, webRequestHelper: WebRequestHelper)
    {
        self.postParamsProvider = paramsProvider
        self.webRequestHelper = webRequestHelper
        
        self.jsContext.setObject(FbJSLogger.self, forKeyedSubscript: "FbJSLogger");
        
    }
    
    func enforceWithCompletion(completion: ((error: NSError?) -> Void)?)
    {
        self.postParamsProvider?.getCurrentUserParametersWithCompletion({ (error, params) in
            guard error == nil else {completion?(error: error); return}
            
            self.fbdata = params;
            self.enforcePrivacySettingAtIndex(0, inArray: self.settings, completionWhenAllDone: completion)
            
        })
        
        
    }
    
    
    
    
    
    private func buildGETRequestForSetting(setting: PrivacySetting) -> NSURLRequest?
    {
        guard let url = NSURL(string: setting.getURL) else {return nil}
        let request = NSMutableURLRequest(URL: url);
        
        request.HTTPMethod = "GET";
        

        
        return request
    }
    
    
    private func enforcePrivacySettingAtIndex(index: Int, inArray array: [PrivacySetting], completionWhenAllDone:((error: NSError?) -> Void)?)
    {
        guard index >= 0 && index < array.count else {completionWhenAllDone?(error: nil); return;}
        let setting = array[index]
        
        let continueToNext = {
            self.enforcePrivacySettingAtIndex(index+1, inArray: array, completionWhenAllDone: completionWhenAllDone);
        }
        
        guard let getRequest = self.buildGETRequestForSetting(setting) else {continueToNext(); return;}
        
        self.webRequestHelper?.makeRequest(getRequest, withCompletion: { (error, cookiesHeaderString, responseText) in
            guard error == nil else {continueToNext(); return;}
            
            self.extractDataFromResponse(responseText, withCompletion: { (data) in
                
                var postData = data;
                setting.data.forEach { postData[$0] = $1 as? String }
                
                if let postRequest = self.buildPOSTRequestForSetting(setting, postBody: postData.postBodyString, cookiesHeaderString: cookiesHeaderString)
                {
                    
                    self.webRequestHelper?.makeRequest(postRequest, withCompletion: { (error, cookiesHeaderString, responseText) in
                        continueToNext()
                    })
                    
                }
            })
            
        })
        
    }
    
    private func buildPOSTRequestForSetting(setting: PrivacySetting, postBody: String, cookiesHeaderString: String) -> NSURLRequest?
    {
        guard let url = NSURL(string: setting.postURL) else {return nil}
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.setRequestHeader("content-length", value: "\(postBody.characters.count)");
        request.setRequestHeader("accept", value: "*/*");
        request.setRequestHeader("accept-language", value: "en-US,en;q=0.8");
        request.setRequestHeader("content-type", value: "application/x-www-form-urlencoded; charset=UTF-8");
        request.setRequestHeader("cookie", value: cookiesHeaderString);
        
        request.setRequestHeader("origin", value: "https://www.facebook.com");
        request.setRequestHeader("X-Alt-Referer", value: setting.getURL);
        //request.setRequestHeader("user-agent", navigator.userAgent);
        
        
        return request
    }
    
    
    private func extractDataFromResponse(response: String, withCompletion completion: ((data: [String: String]) -> Void)?)
    {
        guard let path = NSBundle.mainBundle().pathForResource("fbExtractData", ofType: "js"),
                  jsString = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        else
        {
            completion?(data: [:])
            return
        }
        
        if let fbdataJSONData = try? NSJSONSerialization.dataWithJSONObject(self.fbdata, options: []),
               fbdataJSONString = String(data: fbdataJSONData, encoding: NSUTF8StringEncoding)
        {
            self.jsContext.evaluateScript(jsString as String)
            self.jsContext.exceptionHandler = { context, value in
                
                print("An exception occurred");
            }
            
            let responseParam = response.escapedStringForJS.stringByReplacingOccurrencesOfString("\n", withString: "");
            
            let call = "\(jsString)(\"\(responseParam)\", \"\(fbdataJSONString.escapedStringForJS)\");"
            
            
            
            
            let result = self.jsContext.evaluateScript(call).toString()
            if let resultData = result.dataUsingEncoding(NSUTF8StringEncoding),
                   resultDict = try? NSJSONSerialization.JSONObjectWithData(resultData, options: []) as? [String: AnyObject],
                   fbData = resultDict!["fbdata"] as? [String: AnyObject],
                   data = resultDict!["data"] as? [String: String]
            {
                self.fbdata = fbData;
                completion?(data: data);
                return
            }
            
            
        }
        
        completion?(data: [:])
    }
    
}