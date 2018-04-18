//
//  ConnectedApp.swift
//  Operando
//
//  Created by Cristi Sava on 18/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import Foundation

class ConnectedApp {
    
    var appId:String?
    var visibility: String?
    var permissions: [String]?
    var iconURL: String?
    var name: String?
    
    init(dictionary: NSDictionary){
        
        self.appId = dictionary["appId"] as? String
        self.visibility = dictionary["visibility"] as? String
        self.iconURL = dictionary["iconUrl"] as? String
        self.name = dictionary["name"] as? String
        self.permissions = dictionary["permissions"] as? [String]
        
    }
}
