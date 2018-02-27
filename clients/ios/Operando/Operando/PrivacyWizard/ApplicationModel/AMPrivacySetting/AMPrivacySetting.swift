//
//  AMPrivacySetting.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

enum AMPrivacySettingType {
    case facebook
    case linkedin
    case unknown
}

class AMPrivacySetting: NSObject {
    
    private(set) var id: Int?
    private(set) var title: String
    private(set) var read: AMRead?
    private(set) var write: AMWrite?
    private(set) var tags: [String]
    private(set) var type: AMPrivacySettingType = .unknown
    private(set) var selectedOption: Int?
    
    var availableOptionsCount: Int {
        guard let read = read, let availableSettings = read.availableSettings else { return 0 }
        return availableSettings.count
    }
    
    init?(type: AMPrivacySettingType, title: String, dictionary: [String: Any]) {
        id = dictionary["id"] as? Int
        self.type = type
        self.title = title
        read = AMRead(dictionary: dictionary["read"] as? [String : Any])
        if read!.availableSettings == nil {
            return nil
        }
        write = AMWrite(dictionary: dictionary["write"] as? [String : Any])
        tags = []
        super.init()
        tags = get(tagsFrom: dictionary["tags"] as? NSArray)
    }
    
    private func get(tagsFrom array: NSArray?) -> [String] {
        guard let array = array else { return [] }
        var result = [String]()
        
        for tag in array {
            if let tag = tag as? String {
                result.append(tag)
            }
        }
        
        return result
    }
    
    func selectOption(atIndex index: Int) -> Bool {
        guard let read = read, let availableSettings = read.availableSettings, index < availableSettings.count else { return false }
        
        var counter = 0
        for setting in availableSettings {
            setting.isSelected = counter == index
            if counter == index {
                selectedOption = setting.index
            }
            counter += 1
        }
        
        return true
    }
    
    func selectOption(withIndex index: Int) {
        guard let read = read, let availableSettings = read.availableSettings else { return }
        selectedOption = index
        for setting in availableSettings {
            setting.isSelected = setting.index == index
        }
    }
}
