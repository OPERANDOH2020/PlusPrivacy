//
//  ConnectionReportsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 6/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


typealias IPReportsCompletion = ((error: NSError?, reports: [IPReportProtocol]?) -> Void)
typealias SecurityEventsCompletion = ((error: NSError?, securityEvents: [SecurityEventProtocol]?) -> Void)
typealias AddReportCompletion = ((error: NSError?) -> Void)

protocol ConnectionReportsProvider : class
{
    func getAllReportsWithCompletion(completion: IPReportsCompletion);
    func getAllSecurityEventsForReportWithId(reportId: Int, withCompletion completion: SecurityEventsCompletion);
}

protocol ConnectionReportsSource : class {
    func addReportForAddress(address: String, withInfo info: IPInfoProtocol, withAssociatedEvents events: [SecurityEventProtocol], withCompletion completion: AddReportCompletion);
}