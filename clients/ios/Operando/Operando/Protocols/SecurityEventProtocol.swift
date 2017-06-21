//
//  SecurityEventProtocol.swift
//  Operando
//
//  Created by Costin Andronache on 6/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol SecurityEventProtocol {
    
    var title: String { get }
    var description: String { get }
    var securityEventTag: SecurityEventTag { get }
    var detailsURL: String { get }
}

struct IPSecurityEvent : SecurityEventProtocol
{
    var title: String
    var description: String
    var detailsURL: String
    var securityEventTag: SecurityEventTag
}