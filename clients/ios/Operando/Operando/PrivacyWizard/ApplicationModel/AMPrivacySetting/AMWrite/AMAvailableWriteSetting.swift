//
//  AMAvailableWriteSetting.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 13/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class AMAvailableWriteSetting: NSObject {
    
    private(set) var key: String?
    private(set) var name: String?
    private(set) var parameters: [AMWriteSettingParameter]
    private(set) var data: Dictionary<String, Any>
    
    private(set) var dataDictionary: NSDictionary?
    private(set) var paramsDictionary: NSDictionary?
    
    init?(key: String, dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        self.key = key
        name = dictionary["name"] as? String
        parameters = []
        data = Dictionary<String, Any>()
        
        dataDictionary = dictionary["data"] as? NSDictionary
        paramsDictionary = dictionary["params"] as? NSDictionary
        
        super.init()
        parameters = get(parametersFrom: dictionary["params"] as? NSDictionary)
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
    
    private func get(parametersFrom dictionary: NSDictionary?) -> [AMWriteSettingParameter] {
        guard let dictionary = dictionary else { return [] }
        var result = [AMWriteSettingParameter]()
        
        for (key, value) in dictionary {
            if let key = key as? String {
                if let setting = AMWriteSettingParameter(key: key, dictionary: value as? Dictionary) {
                    result.append(setting)
                }
            }
        }

        return result
    }
    
    func getWriteParametersPairs() -> [(placeholder: String, value: String)] {
        var result = [(placeholder: String, value: String)]()
        
        for param in parameters {
            if let placeholder = param.placeholder, let value = param.value {
                result.append((placeholder: placeholder, value: value))
            }
        }
        
        return result
    }
}
