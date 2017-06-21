//
//  BackgroundConnectionsScanner.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

class BackgroundConnectionsScanner
{
    static let timeInterval: NSTimeInterval = 20
    private weak var source: ConnectionReportsSource?
    private var timer: NSTimer?
    
    func beginScanningProcessWithSource(source: ConnectionReportsSource)
    {
        return;
        self.source = source;
        self.beginNewScan()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackgroundConnectionsScanner.applicationWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil);
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    @objc
    func applicationWillEnterForeground(notification: AnyObject)
    {
        
        self.beginNewScan()
    }
    
    private func beginNewScan()
    {
        
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(BackgroundConnectionsScanner.timeInterval, target: self, selector: #selector(BackgroundConnectionsScanner.timerFired(_:)), userInfo: nil, repeats: false);
    }
    
    
    private func addReportForConnectionInfoAtIndex(index: Int, fromSource source: [ExternalConnectionInfo])
    {
        
        guard index >= 0 && index < source.count else {print("Scan ended");self.beginNewScan(); return}
        
        let stepToNext = {
            dispatch_async(dispatch_get_main_queue(), {
                self.addReportForConnectionInfoAtIndex(index+1, fromSource: source)
            })
        }
        
        let connInfo = source[index];
        //if connInfo.reportedSecurityEvents.count == 0 {stepToNext(); return}
        
        if let address = connInfo.connectionPair.address
        {
            let events = connInfo.reportedSecurityEvents.map({ (ev: IPSecurityEvent) -> SecurityEventProtocol in
                return ev
            })
            self.source?.addReportForAddress(address, withInfo: connInfo.connectionIPInfo ,withAssociatedEvents: events, withCompletion: { (error) in
                
                print("Error for a scan: \(error)")
                stepToNext()
            })
        }

    }
    
    @objc
    func timerFired(sender: NSTimer)
    {
        
        print("Beginning new scan")
        ExternalConnectionsProvider.getCurrentConnectionsInfoWithCompletion { (result) in
            guard let connectionInfos = result else {return}
            self.addReportForConnectionInfoAtIndex(0, fromSource: connectionInfos);
        }
        
    }
}