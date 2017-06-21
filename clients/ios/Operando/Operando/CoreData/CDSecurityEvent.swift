//
//  CDSecurityEvent.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import CoreData


class CDSecurityEvent: NSManagedObject, SecurityEventProtocol {
    
    
    var title: String
    {
        return self.cdEventTitle ?? ""
    }
    
    override var description: String
    {
        return self.cdEventDescription ?? ""
    }
    
    var detailsURL: String
    {
        return self.cdDetailsURL ?? ""
    }
    
    var securityEventTag: SecurityEventTag
    {
        guard let rawTag = self.cdTagRawValue else {return SecurityEventTag.Unknown}
        guard let tag = SecurityEventTag(rawValue: rawTag) else {return SecurityEventTag.Unknown}
        return tag;
    }
}
