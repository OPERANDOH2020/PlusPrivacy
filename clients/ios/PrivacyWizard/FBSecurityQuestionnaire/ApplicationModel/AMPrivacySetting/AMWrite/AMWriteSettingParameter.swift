//
//  AMWriteSettingParameter.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 13/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMWriteSettingParameter: NSObject {
    
    private(set) var key: String
    private(set) var placeholder: String?
    private(set) var value: String?
    
    init?(key: String, dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        self.key = key
        placeholder = dictionary["placeholder"] as? String
        if let intValue = dictionary["value"] as? Int {
            value = String(intValue)
        } else if let stringValue = dictionary["value"] as? String {
            value = stringValue
        } else if let intValue = dictionary["type"] as? Int {
            value = String(intValue)
        } else if let stringValue = dictionary["type"] as? String {
            value = stringValue
        }
        
        if dictionary["placeholder"] as? String == "CSRF_TOKEN" {
            print(dictionary)
        }
    }
}
