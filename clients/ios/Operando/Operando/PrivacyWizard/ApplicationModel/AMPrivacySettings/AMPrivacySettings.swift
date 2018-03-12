//
//  AMPrivacySettings.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMPrivacySettings: NSObject {

    var facebookSettings: [AMPrivacySetting]?
    private(set) var linkedinSettings: [AMPrivacySetting]?
    private(set) var privacySettings: [AMPrivacySetting]?
    private(set) var twitterSettings: [AMPrivacySetting]?
    private(set) var googleSettings: [AMPrivacySetting]?
    private(set) var mappedPrivacySettings: [Int : AMPrivacySetting]?
    
    init?(dictionary: [String: Any]) {
        super.init()
        if let ospSettings = dictionary["ospSettings"] as? NSDictionary {
            extractPrivacySettings(from: ospSettings)
        } else {
            extractPrivacySettings(from: dictionary as NSDictionary)
        }
    }
    
    init?(with dictionary: [String: Any], type: ACPrivacySettingsType) {
        super.init()
        
        switch type {
        case .facebook:
            facebookSettings = getSettings(withType: .facebook, fromDictionary: dictionary as NSDictionary)
        case .linkedin:
            linkedinSettings = getSettings(withType: .linkedin, fromDictionary: dictionary as NSDictionary)
        case .twitter:
            twitterSettings = getSettings(withType: .twitter, fromDictionary: dictionary as NSDictionary)
        case .google:
            googleSettings = getSettings(withType: .google, fromDictionary: dictionary as NSDictionary)
        case .all:
            extractPrivacySettings(from: dictionary as NSDictionary)
        }
    }
    
    func update(type: ACPrivacySettingsType, updatedSettings: AMPrivacySettings) {
        
        switch type {
        case .facebook:
            facebookSettings = updatedSettings.facebookSettings
        case .linkedin:
            linkedinSettings = updatedSettings.linkedinSettings
        case .twitter:
            twitterSettings = updatedSettings.twitterSettings
        case .google:
            googleSettings = updatedSettings.googleSettings
        default:
            return
        }
        concatenateSettings()
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
    
    private func extractPrivacySettings(from dictionary: NSDictionary) {
        facebookSettings = getFacebookSettings(fromDictionary: dictionary)
        linkedinSettings = getLinkedinSettings(fromDictionary: dictionary)
        twitterSettings = getTwitterSettings(fromDictionary: dictionary)
        googleSettings = getGoogleSettings(fromDictionary: dictionary)
        concatenateSettings()
    }
    
    private func concatenateSettings() {
        privacySettings = concatenateArrays(facebookSettings, linkedinSettings, twitterSettings, googleSettings)
        mapPrivacySettings()
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
    
    private func concatenateArrays(_ array1: [AMPrivacySetting]?, _ array2: [AMPrivacySetting]?, _ array3: [AMPrivacySetting]?, _ array4: [AMPrivacySetting]?) -> [AMPrivacySetting] {
        return concatenate(settings: concatenate(settings: concatenate(settings: array1, withSettings: array2), withSettings: array3), withSettings: array4)
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
    
    private func getTwitterSettings(fromDictionary dictionary: NSDictionary) -> [AMPrivacySetting]? {
        return getSettings(withKey: "twitter", type: .facebook, fromDictionary: dictionary)
    }
    
    private func getGoogleSettings(fromDictionary dictionary: NSDictionary) -> [AMPrivacySetting]? {
        return getSettings(withKey: "google", type: .linkedin, fromDictionary: dictionary)
    }
    
    private func getSettings(withKey key: String, type: AMPrivacySettingType, fromDictionary dictionary: NSDictionary?) -> [AMPrivacySetting]? {
        guard let dictionary = dictionary, let settingsDictionary = dictionary[key] as? NSDictionary else { return nil }
        return getSettings(withType: type, fromDictionary: settingsDictionary)
    }
    
    private func getSettings(withType type: AMPrivacySettingType, fromDictionary dictionary: NSDictionary) -> [AMPrivacySetting]? {
        var settings = [AMPrivacySetting]()
        
        for (key, value) in dictionary {
            if let privacySetting = AMPrivacySetting(type: type, title: key as! String ,dictionary: value as! [String : Any]) {
                settings.append(privacySetting)
            }
        }
        
        return settings
    }
}
