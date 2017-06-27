//
//  AMReadJQuerySelector.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMReadJQuerySelector: NSObject {

    private(set) var element: String?
    private(set) var valueType: String?
    
    init?(dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        element = dictionary["element"] as? String
        valueType = dictionary["valueType"] as? String
    }
}
