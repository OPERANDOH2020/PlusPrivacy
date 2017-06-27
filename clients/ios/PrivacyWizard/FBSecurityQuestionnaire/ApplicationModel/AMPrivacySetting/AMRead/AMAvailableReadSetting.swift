//
//  AMAvailableReadSetting.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMAvailableReadSetting: NSObject {
    
    private(set) var key: String
    private(set) var name: String?
    private(set) var index: Int?
    var isSelected: Bool
    
    init?(key: String, dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        self.key = key
        name = dictionary["name"] as? String
        index = dictionary["index"] as? Int
        isSelected = false
    }
}
