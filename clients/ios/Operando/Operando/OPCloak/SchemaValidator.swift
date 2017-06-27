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
            
            let error = NSError(domain: operandoDomain, code: ErrorCode.jsonNotValidAccordingToSchema.rawValue, userInfo: [NSLocalizedDescriptionKey: totalErrors])
            completion?(error)
            
        }

    }
    
}
