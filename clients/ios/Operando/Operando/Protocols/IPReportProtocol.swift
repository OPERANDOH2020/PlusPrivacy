//
//  IPReportProtocol.swift
//  Operando
//
//  Created by Costin Andronache on 6/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol IPReportProtocol
{
    var reportId: Int { get }
    var address: String { get }
    var createdDate: NSDate { get }
    var numOfSecurityEvents: Int { get }
    
    var addressInfo: IPInfoProtocol {get}
}

struct IPReportStruct: IPReportProtocol {
    
    var addressInfo: IPInfoProtocol
    var reportId: Int
    var address: String
    var createdDate: NSDate
    var numOfSecurityEvents: Int
}