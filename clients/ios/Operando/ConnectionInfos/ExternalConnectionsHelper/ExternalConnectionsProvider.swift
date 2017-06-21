//
//  ExternalConnectionsHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit






class ExternalConnectionInfo
{
    let connectionPair: ConnectionPair
    let connectionIPInfo: IPInfo
    let reportedSecurityEvents: [IPSecurityEvent]
    init(connectionPair: ConnectionPair, connectionIPInfo: IPInfo, reportedSecurityEvents: [IPSecurityEvent])
    {
        self.connectionIPInfo = connectionIPInfo;
        self.connectionPair = connectionPair;
        self.reportedSecurityEvents = reportedSecurityEvents;
    }
}

typealias ExternalConnectionsCompletion = ((result: [ExternalConnectionInfo]?) -> Void)

class ExternalConnectionsProvider: NSObject
{
    
    class func getCurrentConnectionsInfoWithCompletion(completion: ExternalConnectionsCompletion?)
    {
        
        var tcpConnections = ConnectionInfoHelper.printTCPConnections()
        tcpConnections = removeDuplicateAddresses(tcpConnections);
        
        print(tcpConnections);
        
        let destination = NSMutableArray()
        ExternalConnectionsProvider.retrieveInfoAboutConnectionAtIndex(0, fromSource: tcpConnections, placeResultInDestination: destination) { (result) in
            
            var result: [ExternalConnectionInfo] = [];
            for i in 0 ..< destination.count
            {
                result.append(destination[i] as! ExternalConnectionInfo);
            }
            
            completion?(result: result);
        }
        
    }
    
    private class func removeDuplicateAddresses(connectionInfos: [ConnectionInfo]) -> [ConnectionInfo]
    {
        var result: [ConnectionInfo] = []
        
        for iCon in connectionInfos
        {
            if let iAddress = iCon.foreignConnection.address
            {
                var foundInResult: Bool = false
                for jCon in result
                {
                    if let jAddress = jCon.foreignConnection.address
                    {
                        if iAddress.containsString(jAddress) || jAddress.containsString(iAddress)
                        {
                            foundInResult = true
                            break
                        }
                    }
                }
                
                if !foundInResult
                {
                    result.append(iCon)
                }
            }
        }
        
        return result;
    }
    
    private class func retrieveInfoAboutConnectionAtIndex(index: Int, fromSource source: [ConnectionInfo],
                                                          placeResultInDestination destination: NSMutableArray,
                                                          withCompletion completion: ((result: NSArray) -> Void))
    {
        guard index >= 0 && index < source.count else
        {
            dispatch_async(dispatch_get_main_queue(), { 
                completion(result: destination);
            })
            return
        }
        
        let stepToNext =
        {
            dispatch_async(dispatch_get_main_queue(), { 
                retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion)
            })
        }
        
        let foreignConnectionPair = source[index].foreignConnection;
        
        guard let ip = foreignConnectionPair.address else
        {
            retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion);
            return;
        }
        
        
        IPInfoHelper.getIpInfoForAddress(ip) { (error, result) in
            
            guard let ipInfoResult = result else {stepToNext(); return}
            
            IPSecurityEventHelper.getSecurityEventsForIp(ip, withCompletion: { (error, result) in
                
                guard let securityEvents = result else {stepToNext(); return}
                
                destination.addObject(ExternalConnectionInfo(connectionPair: foreignConnectionPair, connectionIPInfo: ipInfoResult, reportedSecurityEvents: securityEvents));
                
                stepToNext();
                
            })
            
        }
        
    }
    
    
    
}
