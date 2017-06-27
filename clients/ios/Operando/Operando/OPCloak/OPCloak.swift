//
//  File.swift
//  Operando
//
//  Created by Costin Andronache on 12/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit
import PPCommonTypes
import PPCommonUI

let kURLSchema = "operando"

enum CertifiedAppRequestType: String {
    case TypeRegisterWithSCD = "TypeRegisterWithSCD"
    case TypeNotifyAboutAction = "TypeNotifyAboutAction"
}

let kURLParameterRequestType = "RequestType"
let kURLParameterJSONContent = "JSONContent"


class OPCloak {
    
    private let schemaProvider: SchemaProvider
    private let schemaValidator: SchemaValidator
    private let scdRepository: SCDRepository
    
    init(schemaProvider: SchemaProvider,
         schemaValidator: SchemaValidator,
         scdRepository: SCDRepository) {
        self.schemaProvider = schemaProvider
        self.schemaValidator = schemaValidator
        self.scdRepository = scdRepository
    }
    
    func canProcess(url: URL) -> Bool {
        guard let scheme = url.scheme, scheme == kURLSchema else {
            return false
        }
        
        return true
    }
    
    func processIncoming(url: URL) {
        let requestDict = self.buildRequestDict(from: url)
        
        guard let messageType = requestDict[kURLParameterRequestType],
              let jsonContentURLEncoded = requestDict[kURLParameterJSONContent],
              let jsonData = jsonContentURLEncoded.removingPercentEncoding?.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments),
              let json = jsonObject as? [String: Any] else {
            
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "The document received is not a valid JSON")
            return
        }
        
        if messageType == CertifiedAppRequestType.TypeRegisterWithSCD.rawValue {
            self.processRegisterJSONContent(scdDocument: json)
        }
        
        if messageType == CertifiedAppRequestType.TypeNotifyAboutAction.rawValue {
            self.processNotifyJSONContent(json: json)
        }
    }
    
    
    
    
    private func processRegisterJSONContent(scdDocument: [String: Any]){
        self.validate(scdDocument: scdDocument){ error in 
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
//            self.scdRepository.registerSCDJson(scdDocument) {
//                if let error = $0 {
//                    OPErrorContainer.displayError(error: error)
//                    return
//                }
//                 OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "Done");
//            }
           
        }
    }
    
    private func processNotifyJSONContent(json: [String: Any]){
        
    }
    
    
    private func validate(scdDocument: [String: Any], completion: CallbackWithError?){
        self.schemaProvider.getSchemaWithCallback { (schema, error) in
            if let error = error {
                completion?(error)
            }
            guard let schema = schema else {
                return
            }
            
            self.schemaValidator.validate(json: scdDocument, withSchema: schema, completion: completion)
        }
    }
    
    
    private func buildRequestDict(from url: URL) -> [String: String] {
        let nameValuePairs = url.host?.components(separatedBy: "&") ?? []
        var requestDict: [String: String] = [:]
        for pair in nameValuePairs {
            let components = pair.components(separatedBy: "=")
            guard let name = components.first,
                let last = components.last else {
                    return [:]
            }
            
            requestDict[name] = last
        }
        
        return requestDict
    }
}
