//
//  ACErrorContainer.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/8/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

let kRomsoftDomain = "com.romsoft.operando.error"

class ACErrorContainer: NSObject {
    
    static func getSwarmClientError(description: String) -> NSError {
        return NSError(domain: kRomsoftDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    static func getInvalidServerResponseError() -> NSError? {
        let info = [NSLocalizedDescriptionKey: "Something wrong happened"]
        return NSError(domain: kRomsoftDomain, code: 0, userInfo: info)
    }
    
    static func getProblemWithTheInternetError() -> NSError?
    {
        let info = [NSLocalizedDescriptionKey : "There is a problem with the internet connection"];
        return NSError(domain: kRomsoftDomain, code: 2, userInfo: info);
    }
    
    static let unknownError: NSError = NSError(domain: kRomsoftDomain, code: 5, userInfo: [NSLocalizedDescriptionKey: "An unknown error has occured"])
    
}
