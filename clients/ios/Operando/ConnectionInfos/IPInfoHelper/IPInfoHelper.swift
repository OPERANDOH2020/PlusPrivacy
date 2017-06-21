//
//  IPInfoHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit



class IPInfoHelper: NSObject
{
    static var globalDataTask: NSURLSessionDataTask?


    
    class func getIpInfoForAddress(ip: String, withCompletion completion: ((error: NSError?, result: IPInfo?) -> Void))
    {
        if let error = IPErrorRelatedHelper.getErrorRelatedToIpIfAny(ip)
        {
            completion(error: error, result: nil);
            return;
        }
        
        guard let url = NSURL(string: "http://ipinfo.io/\(ip)/json") else
        {
            completion(error: NSError(domain: IPErrorRelatedHelper.errorDomain, code: IPErrorRelatedHelper.errorInvalidAddressCode, userInfo: nil), result: nil);
            return;
        }
        
        globalDataTask = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url)) { (data: NSData?, response:NSURLResponse?, error: NSError?) in
            completion(error: error, result: convertToIpInfoData(data))
        }
        
        globalDataTask?.resume()
    }
    
    
    private class func convertToIpInfoData(data: NSData?) -> IPInfo?
    {
        guard let jsonData = data else {return nil;}
        
        do
        {
            if let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary
            {
                return IPInfo(hostname: jsonObject["hostname"] as? String ?? "",
                              city: jsonObject["city"] as? String ?? "",
                              country: jsonObject["country"] as? String ?? "",
                              locationCoordinates: jsonObject["loc"] as? String ?? "",
                              organization: jsonObject["org"] as? String ?? "",
                              postalCode: jsonObject["postal"] as? String ?? "",
                              region: jsonObject["region"] as? String ?? "");
            }
            return nil
        }
        catch _
        {
            return nil;
        }
        
    }
}
