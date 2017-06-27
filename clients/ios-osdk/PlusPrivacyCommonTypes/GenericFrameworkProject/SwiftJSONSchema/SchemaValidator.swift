//
//  SchemaValidator.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol SchemaValidator {
    func validate(json: [String: Any], withSchema schema: [String: Any], completion: ((_ errorIfAny: NSError?) -> Void)?)
}


public extension NSError {
    static let SchemaValidatorDomain = "com.swiftSchemaValidator"
    static var jsonNotValidAccordingToSchema: NSError {
        return NSError(domain: SchemaValidatorDomain, code: 1, userInfo: nil)
    }
}

class SwiftSchemaValidator: SchemaValidator {
    
    func validate(json: [String : Any], withSchema schema: [String : Any], completion: ((NSError?) -> Void)?) {
        
        let schema = Schema(schema)
        
        let result = schema.validate(json)
        
        switch result {
        case .Valid:
            completion?(nil)
        case let .invalid(errorList):
            var totalErrors = "";
            for  error in errorList {
                totalErrors.append(error)
                totalErrors.append("\n")
            }
            
            completion?(.jsonNotValidAccordingToSchema)
            
        }

    }
    
}
