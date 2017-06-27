//
//  NSError+Utilities.swift
//  Operando
//
//  Created by Costin Andronache on 8/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case valuesMissing = -1
    case jquerySettingsStringifyError = -2
    case corruptSettingsDict = -3
    case readingSettingsError = -4
    case POSTinfoDictMalformed = -5
    case POSTFail = -6
    case jsonSchemaNotFound = -7
    case jsonNotValidAccordingToSchema = -8
    case errorMissingValuesFromSCDJSON = -9
}

let operandoDomain = "com.operando.operando"

extension NSError
{
    
    static var errorValuesMissing: NSError{
        return NSError(domain: operandoDomain, code: ErrorCode.valuesMissing.rawValue, userInfo: nil)
    }
    
    static var errorOnJQuerySettingsStringify: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.jquerySettingsStringifyError.rawValue, userInfo: nil)
    }
    
    static var errorCorruptSettingsDict: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.corruptSettingsDict.rawValue, userInfo: nil)
    }
    
    static var errorReadingSettings: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.readingSettingsError.rawValue, userInfo: nil)
    }
    
    static var errorPOSTinfoDict: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.POSTinfoDictMalformed.rawValue, userInfo: nil);
    }
    
    static var errorPOSTFailed: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.POSTFail.rawValue, userInfo: nil)
    }
    
    static var jsonSchemaNotFound: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.jsonSchemaNotFound.rawValue, userInfo: nil)
    }
    
    static var jsonNotValidAccordingToSchema: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.jsonNotValidAccordingToSchema.rawValue, userInfo: nil)
    }
    
    static var errorMissingValuesFromSCDJSON: NSError {
        return NSError(domain: operandoDomain, code: ErrorCode.errorMissingValuesFromSCDJSON.rawValue, userInfo: nil);
    }
}
