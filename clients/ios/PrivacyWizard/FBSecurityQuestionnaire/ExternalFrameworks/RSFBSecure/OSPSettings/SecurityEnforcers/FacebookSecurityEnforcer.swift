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
    func makeRequest(request: NSURLRequest, withCompletion completion: ((_ error: NSError?, _ cookiesHeaderString: String, _ responseText: String) -> Void)?);
}

protocol FacebookPostParametersProvider {
    func getCurrentUserParametersWithCompletion(completion: ((_ error: NSError?, _ params: [String: String]) -> Void)?)
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

//extension NSDictionary
//{
//    var postBodyString: String
//    {
//        var result: String = ""
//        var keys = Array(self.allKeys)
//        keys.sort { (a, b) -> Bool in
//            return "\(a)" < "\(b)"
//        }
//        
//        for i in 0..<keys.count
//        {
//            
//            if let key = keys[i] as? String,
//                let value = self[key]
//            {
//                let stringValue = "\(value)"
//                result.appendContentsOf("\(key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)=\(stringValue.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
//                
//                if i < keys.count-1
//                {
//                    result.append("&")
//                }
//            }
//        }
//        
//        return result
//    }
//
//}
//
//extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral
//{
//    var postBodyString: String
//    {
//        var result: String = ""
//        var keys = Array(self.keys)
//        keys.sort { (a, b) -> Bool in
//            return "\(a)" < "\(b)"
//        }
//        
//        for i in 0..<keys.count
//        {
//            if let key = keys[i] as? String,
//                let value = self[keys[i]] as? String
//            {
//                result.appendContentsOf("\(key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)=\(value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)")
//                
//                if i < keys.count-1
//                {
//                    result.append("&")
//                }
//            }
//        }
//        
//        return result
//    }
//}
