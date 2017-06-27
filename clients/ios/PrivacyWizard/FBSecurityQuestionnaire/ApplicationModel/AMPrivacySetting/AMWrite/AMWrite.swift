//
//  AMWrite.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMWrite: NSObject {
    
    private(set) var name: String?
    private(set) var page: String?
    private(set) var urlTemplate: String?
    private(set) var data: Dictionary<String, Any>
    private(set) var recommended: String?
    private(set) var type: String?
    private(set) var availableSettings: [AMAvailableWriteSetting]?
    
    init?(dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        name = dictionary["name"] as? String
        page = dictionary["page"] as? String
        urlTemplate = dictionary["url_template"] as? String
        data = Dictionary<String, Any>()
        recommended = dictionary["recommended"] as? String
        type = dictionary["type"] as? String
        
        if let settings = dictionary["availableSettings"] as? NSDictionary {
            availableSettings = [AMAvailableWriteSetting]()
            for (key, value) in settings {
                if let key = key as? String {
                    if let setting = AMAvailableWriteSetting(key: key, dictionary: value as? Dictionary) {
                        availableSettings!.append(setting)
                    }
                }
            }
        }
        
        super.init()
        
        extract(dataParameterFrom: dictionary["data"] as? NSDictionary)
    }
    
    private func extract(dataParameterFrom dictionary: NSDictionary?) {
        guard let dictionary = dictionary else { return }
        
        for (key, value) in dictionary {
            if let key = key as? String {
                data[key] = value
            }
        }
    }
    
    func getCompletedUrlTemplate(forSettingNamed settingName: String) -> String? {
        guard let urlTemplate = urlTemplate else { return nil }
        var writeSetting: AMAvailableWriteSetting? = nil
        
        for setting in availableSettings ?? [] {
            if let name = setting.name {
                if name == settingName {
                    writeSetting = setting
                }
            }
        }
        
        guard let writeStg = writeSetting else { return nil }
        let valuePlaceholderArray = writeStg.getWriteParametersPairs()
        var url = urlTemplate
        for item in valuePlaceholderArray {
            url = url.replacingOccurrences(of: "{\(item.placeholder)}", with: item.value)
        }
        
        return url
    }
    
    func getParams(forSettingNamed settingName: String) -> (data: NSDictionary?, params: NSDictionary?) {
        var writeSetting: AMAvailableWriteSetting? = nil
        
        for setting in availableSettings ?? [] {
            if let name = setting.name {
                if name == settingName {
                    writeSetting = setting
                }
            }
        }
        
        let dataDict: NSMutableDictionary = NSMutableDictionary(dictionary: self.data)
        if let selectedOptDataDict = writeSetting?.data {
            for (key, value) in selectedOptDataDict {
                dataDict.setValue(value, forKey: key)
            }
        }
        
        return (data: dataDict, params: writeSetting?.paramsDictionary)
    }
}
