//
//  OPErrorContainer.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import SwarmClient


enum OPErrorCodes: Int
{
    case unknownError = 0
    case invalidInput = 1
    case invalidServerResponse = 2
    case connectionLost = 3
    case noIdentityProvided = 4
    case identityDoesntExist = 5
    case emptyEmail = 6
    case userIdMissing = 7
    case identityEmailNotUnique = 8
    case credentialsNotStoredProperly = 9
    case credentialsCouldNotBeDeletedProperly = 10
}


let localizableCodesPerErrorMessage: [String: Int] =
    [
        "no_identity_provided":             OPErrorCodes.noIdentityProvided.rawValue,
        "identity_not_exists":              OPErrorCodes.identityDoesntExist.rawValue,
        "empty_email":                      OPErrorCodes.emptyEmail.rawValue,
        "userId_is_required":               OPErrorCodes.userIdMissing.rawValue,
        "identity_email_should_be_unique":  OPErrorCodes.identityEmailNotUnique.rawValue,
        
]


let localizableKeysPerErrorCode: [Int: String] =
    [
      OPErrorCodes.unknownError.rawValue: "kUnknownErrorLocalizableKey",
      OPErrorCodes.invalidInput.rawValue: "kInvalidInputLocalizableKey",
      OPErrorCodes.invalidServerResponse.rawValue : "kInvalidServerResponseLocalizableKey",
      OPErrorCodes.connectionLost.rawValue: "kConnectionLostLocalizableKey",
      OPErrorCodes.noIdentityProvided.rawValue: "kNoIdentityProvidedLocalizableKey",
      OPErrorCodes.identityDoesntExist.rawValue: "kIdentityDoesntExistLocalizableKey",
      OPErrorCodes.emptyEmail.rawValue: "kEmptyEmailLocalizableKey",
      OPErrorCodes.userIdMissing.rawValue: "kUserIdIsRequiredLocalizableKey",
      OPErrorCodes.identityEmailNotUnique.rawValue: "kIdentityEmailShouldBeUnique",
      OPErrorCodes.credentialsNotStoredProperly.rawValue: "kCredentialsCouldNotBeStoredLocalizableKey",
      OPErrorCodes.credentialsCouldNotBeDeletedProperly.rawValue: "kCredentialsCouldNotBeDeletedProperlyLocalizableKey",
    ]

extension Bundle
{
    class func localizedStringFor(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


class OPErrorContainer
{
    static let kOperandoDomain = "com.operando.eu"
    
    
    static let errorInvalidInput: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.invalidInput.rawValue, userInfo: nil)
    static let errorInvalidServerResponse: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.invalidServerResponse.rawValue, userInfo: nil)
    
    static let errorConnectionLost: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.connectionLost.rawValue, userInfo: nil)
    static let unknownError: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.unknownError.rawValue, userInfo: nil)
    static let errorCouldNotStoreCredentials: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.credentialsNotStoredProperly.rawValue, userInfo: nil)
    
    static let errorCouldNotDeleteCredentials: NSError = NSError(domain: kOperandoDomain, code: OPErrorCodes.credentialsCouldNotBeDeletedProperly.rawValue, userInfo: nil)
    
    static func displayError(error: NSError)
    {
        
        if error.domain == kOperandoDomain
        {
            let key = localizableKeysPerErrorCode[error.code] ?? ""
            let message = Bundle.localizedStringFor(key: key)
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: message)
            return
        }
        
        
        OPViewUtils.showOkAlertWithTitle(title: "", andMessage: error.localizedDescription)
    }
}
