//
//  AMPrivacySettings.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMPrivacySettings: NSObject {

    private(set) var facebookSettings: [AMPrivacySetting]?
    private(set) var linkedinSettings: [AMPrivacySetting]?
    private(set) var privacySettings: [AMPrivacySetting]?
    private(set) var mappedPrivacySettings: [Int : AMPrivacySetting]?
    
    init?(dictionary: [String: Any]) {
        super.init()
        if let ospSettings = dictionary["ospSettings"] as? NSDictionary {
            facebookSettings = getFacebookSettings(fromDictionary: ospSettings)
            linkedinSettings = getLinkedinSettings(fromDictionary: ospSettings)
            privacySettings = concatenate(settings: facebookSettings, withSettings: linkedinSettings)
            mapPrivacySettings()
        }
    }
    
    func getPrivacySetting(withId id: Int?) -> AMPrivacySetting? {
        guard let id = id else { return nil }
        var result: AMPrivacySetting? = nil
        
        for setting in privacySettings ?? [] {
            if setting.id == id {
                result = setting
                break
            }
        }
        
        return result
    }
    
    private func mapPrivacySettings() {
        guard let privacySettings = privacySettings else { return }
        mappedPrivacySettings = [Int : AMPrivacySetting]()
        
        for setting in privacySettings {
            if let read = setting.read {
                if let availableSettings = read.availableSettings {
                    for availableSetting in availableSettings {
                        if let index = availableSetting.index {
                            mappedPrivacySettings?[index] = setting
                        }
                    }
                }
            }
        }
    }
    
    private func concatenate(settings array1: [AMPrivacySetting]?, withSettings array2: [AMPrivacySetting]?) -> [AMPrivacySetting] {
        return Array<AMPrivacySetting>.concatenate(array1: array1, array2: array2)
    }
    
    private func getFacebookSettings(fromDictionary dictionary: NSDictionary) -> [AMPrivacySetting]? {
        return getSettings(withKey: "facebook", type: .facebook, fromDictionary: dictionary)
    }
    
    private func getLinkedinSettings(fromDictionary dictionary: NSDictionary) -> [AMPrivacySetting]? {
        return getSettings(withKey: "linkedin", type: .linkedin, fromDictionary: dictionary)
    }
    
    private func getSettings(withKey key: String, type: AMPrivacySettingType, fromDictionary dictionary: NSDictionary?) -> [AMPrivacySetting]? {
        guard let dictionary = dictionary else { return nil }
        var settings = [AMPrivacySetting]()
        
        if let settingsDictionary = dictionary[key] as? NSDictionary {
            for (key, value) in settingsDictionary {
                if let privacySetting = AMPrivacySetting(type: type, title: key as! String ,dictionary: value as! [String : Any]) {
                    settings.append(privacySetting)
                }
            }
        }

        return settings
    }
}
