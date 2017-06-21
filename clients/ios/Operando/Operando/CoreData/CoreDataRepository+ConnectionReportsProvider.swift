//
//  CoreDataRepository+ConnectionReportsProvider.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import CoreData

extension CDIPReport: IPReportProtocol
{
    var address: String
    {
        return self.cdAddress ?? ""
    }
    
    var reportId: Int
    {
        return self.cdReportId?.integerValue ?? -1;
    }
    
    var createdDate: NSDate
    {
        return self.cdCreationDate ?? NSDate()
    }
    
    var numOfSecurityEvents: Int
    {
        return self.reportToEvents?.count ?? 0
    }
    
    var addressInfo: IPInfoProtocol
    {
        let structIpInfo = IPInfo(hostname:ipInfo?.hostname ?? "",
                                  city: ipInfo?.city ?? "",
                                  country: ipInfo?.country ?? "",
                                  locationCoordinates: ipInfo?.locationCoordinates ?? "",
                                  organization: ipInfo?.organization ?? "",
                                  postalCode: ipInfo?.postalCode ?? "",
                                  region: ipInfo?.region ?? "");
        return structIpInfo
    }

    
    @NSManaged func addCDSecurityEventsObject(cdSecurityEvent: CDSecurityEvent);
    
}

extension CoreDataRepository: ConnectionReportsProvider
{
    func getAllReportsWithCompletion(completion: IPReportsCompletion)
    {
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "CDIPReport");
        do
        {
            let results = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            var ipResults: [IPReportProtocol] = [];
            
            for obj in results
            {
                if let ipReport = obj as? CDIPReport
                {
                                        
                    ipResults.append(IPReportStruct(addressInfo: ipReport.addressInfo,
                        reportId: ipReport.reportId,
                        address: ipReport.address,
                        createdDate: ipReport.createdDate,
                        numOfSecurityEvents: ipReport.numOfSecurityEvents))
                }
            }
            
            ipResults.sortInPlace({ (a:IPReportProtocol, b:IPReportProtocol) -> Bool in
                return a.createdDate.compare(b.createdDate) == NSComparisonResult.OrderedDescending
            })
            
            completion(error: nil, reports: ipResults);
            
        } catch
        {
            completion(error: error as NSError, reports: nil);
        }
        
    }
    
    func getAllSecurityEventsForReportWithId(reportId: Int, withCompletion completion: SecurityEventsCompletion)
    {
        let predicate = NSPredicate(format: "reportId == %d", reportId)
        
        let fetchRequest = NSFetchRequest(entityName: "CDIPReport");
        fetchRequest.predicate = predicate
        
        
        do
        {
            var securityEvents: [SecurityEventProtocol] = [];
            let ipReportResult = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if let ipReport = ipReportResult.first as? CDIPReport
            {
                if let events = ipReport.reportToEvents
                {
                    for obj in events
                    {
                        if let securityEvent = obj as? CDSecurityEvent
                        {
                            securityEvents.append(IPSecurityEvent(title: securityEvent.title,
                                description: securityEvent.description,
                                detailsURL: securityEvent.detailsURL,
                                securityEventTag: securityEvent.securityEventTag))
                        }
                    }
                }
            }
            
            completion(error: nil, securityEvents: securityEvents);
            
        } catch
        {
            completion(error: error as NSError, securityEvents: nil);
        }
    }
}