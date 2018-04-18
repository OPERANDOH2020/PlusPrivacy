//
//  NSDictionaryExtension.swift
//  Operando
//
//  Created by Cristi Sava on 18/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func toConnectedApps() -> [ConnectedApp] {
        
        var elements:[ConnectedApp] = []
        
        if let array = self["statusMessageContent"] as? [NSDictionary] {
            
            for element in array {
                elements.append(ConnectedApp(dictionary: element))
            }
        }
        
        return elements
    }
}
