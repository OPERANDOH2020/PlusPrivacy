//
//  ACPrivacyWriter.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/24/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class ACPrivacyWriter: NSObject {
    
    static func privacyOptionsJsonString() -> String? {
        guard let privacySettings = ACPrivacyWizard.shared.privacySettings else { return nil }
        
        switch ACPrivacyWizard.shared.selectedScope {
        case .facebook:
            return createJsonString(fromPrivacySettings: privacySettings.facebookSettings)
        case .linkedIn:
            return createJsonString(fromPrivacySettings: privacySettings.linkedinSettings)
        default:
            return nil
        }
    }

    static func createJsonString(fromPrivacySettings settings: [AMPrivacySetting]?) -> String? {
        guard let settings = settings else { return nil }
        var array = [Dictionary<String, Any>]()
        
        for setting in settings {
            
            switch ACPrivacyWizard.shared.selectedScope {
            case .facebook:
                if let mappedSetting = map(facebookPrivacySetting: setting) {
                    array.append(mappedSetting)
                }
            case .linkedIn:
                if let mappedSetting = map(linkedinPrivacySetting: setting) {
                    array.append(mappedSetting)
                }
            default:
                continue;
            }
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            return result as String?
        } catch {
            return nil
        }
    }
    
    static func map(facebookPrivacySetting setting: AMPrivacySetting) -> Dictionary<String, Any>? {
//        guard let read = setting.read,
//            let selectedSettingName = read.getSelectedReadSettingName(),
//            let write = setting.write,
//            let settingTitle = write.name,
//            let page = write.page,
//            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName)
//        else { return nil }
//        
//        var result = Dictionary<String, Any>()
//        
//        result["name"] = settingTitle
//        result["page"] = page
//        result["url"] = urlTemplate
//        result["data"] = write.data
//        
//        return result
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName)
            else { return nil }
        
        var result = Dictionary<String, Any>()
        
        let parameters = write.getParams(forSettingNamed: selectedSettingName)
        
        result["name"] = settingTitle.replacingOccurrences(of: "\"", with: "")
        result["page"] = page
        result["url"] = urlTemplate
        result["data"] = parameters.data
        result["params"] = parameters.params
        result["type"] = write.type
        
        return result
    }
    
    static func map(linkedinPrivacySetting setting: AMPrivacySetting) -> Dictionary<String, Any>? {
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
            let urlTemplate = write.urlTemplate
            else { return nil }
        
        var result = Dictionary<String, Any>()
        
        let parameters = write.getParams(forSettingNamed: selectedSettingName)
        
        result["name"] = settingTitle.replacingOccurrences(of: "\"", with: "")
        result["page"] = page
        result["url"] = urlTemplate
        result["data"] = parameters.data
        result["params"] = parameters.params
        result["type"] = write.type
        
        return result
    }

}
