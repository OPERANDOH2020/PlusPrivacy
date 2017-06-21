//
//  CDIPReport+CoreDataProperties.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDIPReport {

    @NSManaged var cdCreationDate: NSDate?
    @NSManaged var cdAddress: String?
    @NSManaged var cdReportId: NSNumber?
    @NSManaged var reportToEvents: NSSet?
    @NSManaged var ipInfo: CDIpInfo?

}
