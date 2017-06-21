//
//  IPErrorRelatedHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class IPErrorRelatedHelper: NSObject
{
    static let errorDomain = "com.operando.IPInfoHelper"
    static let errorLocalAddressCode = -1001;
    static let errorInvalidAddressCode = -1002;
    
    static let loopBackAddress = "127.0.0.1"
    static let lanWiFiAddressPart = "192.168."
    
    
    class func getErrorRelatedToIpIfAny(ip: String) -> NSError?
    {
        if ip.containsString(loopBackAddress) || ip.containsString(lanWiFiAddressPart)
        {
            return NSError(domain: errorDomain, code: errorLocalAddressCode, userInfo: nil);
        }
        
        return nil;
    }
    
}
