//
//  ACErrorContainer.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit
import SwarmClient

class ACErrorContainer: NSObject {
    
    static func getSwarmClientError(description: String) -> NSError {
        return NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
