//
//  CDIpInfo+CoreDataProperties.swift
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

extension CDIpInfo {

    @NSManaged var hostname: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var locationCoordinates: String?
    @NSManaged var organization: String?
    @NSManaged var postalCode: String?
    @NSManaged var region: String?

}
