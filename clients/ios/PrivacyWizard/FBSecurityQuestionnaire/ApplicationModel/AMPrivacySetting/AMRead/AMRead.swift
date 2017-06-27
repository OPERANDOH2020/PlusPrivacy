//
//  AMRead.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMRead: NSObject {
    
    private(set) var name: String?
    private(set) var url: String?
    private(set) var availableSettings: [AMAvailableReadSetting]?
    private(set) var jquerySelector: AMReadJQuerySelector?
    
    init?(dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        name = dictionary["name"] as? String
        url = dictionary["url"] as? String
        jquerySelector = AMReadJQuerySelector(dictionary: dictionary["jquery_selector"] as? Dictionary)
        
        if let settings = dictionary["availableSettings"] as? NSDictionary {
            availableSettings = [AMAvailableReadSetting]()
            for (key, value) in settings {
                if let key = key as? String {
                    if let setting = AMAvailableReadSetting(key: key, dictionary: value as? Dictionary) {
                        availableSettings!.append(setting)
                    }
                }
            }
        }
    }
    
    func getSelectedReadSettingName() -> String? {
        for setting in availableSettings ?? [] {
            if setting.isSelected {
                return setting.name
            }
        }
        
        return nil
    }
}
