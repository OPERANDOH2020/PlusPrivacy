//
//  CoreDataRepository+ConnectionReportsSource.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import CoreData



extension CoreDataRepository: ConnectionReportsSource
{
    static let domain = "com.operando.CoreDataRepositorySource"
    static let errorCouldNotSetId = -1001
    static let errorCouldNotCreateReport = -1002
    static let erorrCouldNotCreateSecurityEvent = -1003
    static let errorAddressAlreadyReported = -1004
    
    func addReportForAddress(address: String, withInfo info: IPInfoProtocol, withAssociatedEvents events: [SecurityEventProtocol], withCompletion completion: AddReportCompletion)
    {
        guard self.noReportForAddress(address) else {
            
            completion(error: NSError(domain: CoreDataRepository.domain, code: CoreDataRepository.errorAddressAlreadyReported, userInfo: nil));
            return
        }
        
        guard let ipReportEntity = NSEntityDescription.insertNewObjectForEntityForName("CDIPReport", inManagedObjectContext: self.managedObjectContext)
        as? CDIPReport, ipInfo   = NSEntityDescription.insertNewObjectForEntityForName("CDIpInfo", inManagedObjectContext: self.managedObjectContext)
        as? CDIpInfo else
        {
            completion(error: NSError(domain: CoreDataRepository.domain, code: CoreDataRepository.errorCouldNotCreateReport, userInfo: nil));
            return
        }
        
        do
        {
            let fetchForCounting = NSFetchRequest(entityName: "CDIPReport");
            ipReportEntity.cdAddress = address;
            
            ipInfo.city = info.city
            ipInfo.country = info.country
            ipInfo.hostname = info.hostname
            ipInfo.locationCoordinates = info.locationCoordinates
            ipInfo.organization = info.organization
            ipInfo.region = info.region
            ipInfo.postalCode = info.postalCode
            
            ipReportEntity.ipInfo = ipInfo
            
            var error: NSError?
            
            let possibleCount = self.managedObjectContext.countForFetchRequest(fetchForCounting, error: &error)
            if error != nil
            {
                completion(error: error);
                return
            }
            
            ipReportEntity.cdReportId = NSNumber(integer: possibleCount);
            ipReportEntity.cdCreationDate = NSDate()
            
            for secEvent in events
            {
                if let newSecEvent = NSEntityDescription.insertNewObjectForEntityForName("CDSecurityEvent", inManagedObjectContext: self.managedObjectContext) as? CDSecurityEvent
                {
                    newSecEvent.cdDetailsURL = secEvent.detailsURL
                    newSecEvent.cdEventDescription = secEvent.description
                    newSecEvent.cdEventTitle = secEvent.title
                    newSecEvent.cdTagRawValue = secEvent.securityEventTag.rawValue
                    //ipReportEntity.addCDSecurityEventsObject(newSecEvent);
                }
                else
                {
                    completion(error: NSError(domain: CoreDataRepository.domain, code: CoreDataRepository.erorrCouldNotCreateSecurityEvent, userInfo: nil));
                    return
                }
            }
            
          try self.saveContext()
            
        } catch
        {
            completion(error: error as NSError)
        }
        
    }
    
    
    private func noReportForAddress(addres: String) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "CDIPReport");
        let predicate = NSPredicate(format: "cdAddress == %@", addres);
        fetchRequest.predicate = predicate
        
        
        var error: NSError?
        let possibleCount = self.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        
        if error == nil && possibleCount == 0
        {
            return true
        }
        
        return false
    }
    
    
}