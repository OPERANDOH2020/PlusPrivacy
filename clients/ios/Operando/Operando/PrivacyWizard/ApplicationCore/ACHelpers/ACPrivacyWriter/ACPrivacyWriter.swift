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
        guard let privacySettings = ACPrivacyWizard.shared.privacySettings else {
            return nil }
        
        switch ACPrivacyWizard.shared.selectedScope {
        case .facebook:
            return createJsonString(fromPrivacySettings: privacySettings.facebookSettings)
        case .linkedIn:
            return createJsonString(fromPrivacySettings: privacySettings.linkedinSettings)
        case .twitter:
            return createJsonString(fromPrivacySettings: privacySettings.twitterSettings)
        case .googleLogin:
            return createJsonString(fromPrivacySettings: privacySettings.googleSettings)
        case .googleActivity:
            return createJsonString(fromPrivacySettings: privacySettings.googleSettings)
        case .googlePreferences:
            return createJsonString(fromPrivacySettings: privacySettings.googleSettings)
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
                break;
            case .linkedIn:
                if let mappedSetting = map(linkedinPrivacySetting: setting) {
                    array.append(mappedSetting)
                }
                break;
            case .twitter:
                if let mappedSetting = map(twitterPrivacySettings: setting) {
                    array.append(mappedSetting)
                }
                break
            case .googleLogin:
                if let mappedSetting = map(googlePrivacySettings: setting){
                    array.append(mappedSetting)
                }
                break;
            case .googlePreferences:
                if let mappedSetting = map(googlePreferencesSettings: setting){
                    array.append(mappedSetting)
                }
                break;
            case .googleActivity:
                if let mappedSetting = map(googleActivityPrivacySettings: setting){
                    array.append(mappedSetting)
                }
                break;
            default:
                return nil
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
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName)
            else {
                return nil
        }
        
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
    
    static func map(googleActivityPrivacySettings setting: AMPrivacySetting) -> Dictionary<String, Any>? {
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
//            let urlTemplate = write.urlTemplate,
            let methodType = write.methodType,
            methodType == "user-action"
            else {
                return nil
                
        }
        
        var result = Dictionary<String, Any>()
        
        let parameters = write.getParams(forSettingNamed: selectedSettingName)
        
        result["name"] = settingTitle.replacingOccurrences(of: "\"", with: "")
        result["page"] = page
//        result["url"] = urlTemplate
        result["data"] = parameters.data
        result["params"] = parameters.params
        result["type"] = write.type
        result["method_type"] = methodType
        return result
    }
    
    static func map(googlePreferencesSettings setting: AMPrivacySetting) -> Dictionary<String, Any>? {
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName),
            let methodType = write.methodType,
            methodType == "GET"
            else { return nil }
        
        var result = Dictionary<String, Any>()
        
        let parameters = write.getParams(forSettingNamed: selectedSettingName)
        
        let newDictionary = NSMutableDictionary()
        
        result["name"] = settingTitle.replacingOccurrences(of: "\\", with: "")
        result["method_type"] = write.methodType
        result["page"] = page
        result["url"] = urlTemplate
        result["data"] = parameters.data
        result["params"] = parameters.params
        result["type"] = write.type
        
        
        return result
    }
    
    static func map(googlePrivacySettings setting: AMPrivacySetting) -> Dictionary<String, Any>? {
        guard let read = setting.read,
            let selectedSettingName = read.getSelectedReadSettingName(),
            let write = setting.write,
            let settingTitle = write.name,
            let page = write.page,
            let urlTemplate = write.getCompletedUrlTemplate(forSettingNamed: selectedSettingName),
            write.methodType == nil
            else { return nil }
        
        var result = Dictionary<String, Any>()
        
        let parameters = write.getParams(forSettingNamed: selectedSettingName)
        
        let newDictionary = NSMutableDictionary()
        
//        for element in parameters.data! {
//
//            if let newElementValue = element.value as? String {
//                newDictionary.setValue(newElementValue.replacingOccurrences(of: "\\", with: ""), forKey: element.key as! String)
//            }
//        }
        
        result["name"] = settingTitle.replacingOccurrences(of: "\\", with: "")
        result["method_type"] = write.methodType
        result["page"] = page
        result["url"] = urlTemplate
        result["data"] = parameters.data
        result["params"] = parameters.params
        result["type"] = write.type
        
        
        return result
    }
    
    static func map(twitterPrivacySettings setting: AMPrivacySetting) -> Dictionary<String, Any>? {
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
