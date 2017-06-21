//
//  IPSecurityEventHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


enum SecurityEventTag: String {
    case Malware = "malware"
    case Botnet = "botnet"
    case Spam = "spam"
    case Phishing = "phishing"
    case MaliciousActivity = "malicious activity"
    case Blacklist = "blacklist"
    case DNSBL = "dnsbl"
    case Unknown = "unknown"
}




class IPSecurityEventHelper: NSObject {

    
    static var globalDataTask: NSURLSessionDataTask?
    static let authorizationHeaderValue = "Token 42fd943ee1711e780d1ceff5a95c891d4e0adca1"
    
    class func getSecurityEventsForIp(ip: String, withCompletion completion:((error: NSError?, result: [IPSecurityEvent]?) -> Void))
    {
        if let error = IPErrorRelatedHelper.getErrorRelatedToIpIfAny(ip)
        {
            completion(error: error, result: nil);
            return;
        }
        
        guard let url = NSURL(string: "https://cymon.io/api/nexus/v1/ip/\(ip)/events") else
        {
            completion(error: NSError(domain: IPErrorRelatedHelper.errorDomain, code: IPErrorRelatedHelper.errorInvalidAddressCode, userInfo: nil), result: nil);
            return;
        }
        
        let request = NSMutableURLRequest(URL: url);
        request.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization");
        
        globalDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            completion(error: error, result: convertToIPSecurityEventsData(data));
            
        })
        
        globalDataTask?.resume()
        
    }
    
    
    
    
    private class func convertToIPSecurityEventsData(data: NSData?) -> [IPSecurityEvent]?
    {
        var result: [IPSecurityEvent] = [];
        //wtf swift??? - guard skips to the end of the function even though data != nil 
        
        if let jsonData = data
        {
            do
            {
                if let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary,
                    jsonArray = jsonDict["results"] as? NSArray
                {
                    for obj in jsonArray
                    {
                        if let dict = obj as? [String: String]
                        {
                            result.append(IPSecurityEvent(title: dict["title"] ?? "",
                                description: dict["description"] ?? "",
                                detailsURL: dict["details_url"] ?? "",
                                securityEventTag: SecurityEventTag(rawValue: dict["tag"] ?? SecurityEventTag.Unknown.rawValue)! ))
                        }
                    }
                    
                    return result;
                }
                else
                {
                    return nil;
                }
            } catch _
            {
                return nil;
            }
                
        }
        else
        {
            return nil;
        }
    }

}
