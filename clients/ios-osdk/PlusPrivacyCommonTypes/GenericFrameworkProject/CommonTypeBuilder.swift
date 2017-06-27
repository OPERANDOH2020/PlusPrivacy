//
//  CommonTypeBuilder.swift
//  PlusPrivacyCommonTypes
//
//  Created by Costin Andronache on 2/2/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit


extension Bundle {
    static var commonTypesBundle: Bundle? {
        guard let path = Bundle.main.path(forResource: "PPCommonTypesBundle", ofType: "bundle"), let bundle = Bundle(path: path) else {
            return nil
        }
        
        return bundle
    }
}

public extension NSError {
    public static let CommonTypeBuilderDomain = "com.commonTypeBuilder"
    
    public static var schemaUnavailable: NSError {
        return NSError(domain: CommonTypeBuilderDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find schema file"])
    }
    
    public static var unknownCommonTypeError: NSError {
        return NSError(domain: CommonTypeBuilderDomain, code: 2, userInfo: nil)
    }
}

@objc
public class CommonTypeBuilder: NSObject {
    
    private let schemaProvider: SchemaProvider?
    private let schemaValidator: SwiftSchemaValidator = SwiftSchemaValidator()
    
    public static let sharedInstance = CommonTypeBuilder()
    
    private override init() {
        let bundle = Bundle.commonTypesBundle
        guard let path = bundle?.path(forResource: "SCDSchema", ofType: "json") else {
            self.schemaProvider = nil;
            super.init()
            return
        }
        
        self.schemaProvider = LocalFileSchemaProvider(pathToFile: path)
        super.init()
    }
    
    public func buildSCDDocument(with json:[String: Any], in completion: ((_ doc: SCDDocument?, _ error: NSError?) -> Void)?) {
        guard let schemaProvider = self.schemaProvider else {
            completion?(nil, .schemaUnavailable)
            return
        }
        
        schemaProvider.getSchemaWithCallback { (schemaDict, error) in
            if let error = error {
                completion?(nil, error);
                return;
            }
            guard let dict = schemaDict else {
                completion?(nil, .unknownCommonTypeError)
                return
            }
            
            self.schemaValidator.validate(json: json, withSchema: dict, completion: { error in
                if let error = error {
                    completion?(nil, error);
                    return
                }
                
                guard let document = SCDDocument(scd: json) else {
                    completion?(nil, .unknownCommonTypeError)
                    return
                }
                
                completion?(document, nil)
            })
            
        }
    }
    
    public func buildFromJSON(array: [[String: Any]], completion:((_ documents: [SCDDocument]?, _ error: NSError?) -> Void)?)  {
        
        var items: [SCDDocument] = []

        guard let schemaProvider = self.schemaProvider else {
            completion?(nil, .schemaUnavailable)
            return
        }
        weak var weakSelf = self
        schemaProvider.getSchemaWithCallback { schemaDict, error  in
            if let error = error {
                completion?(nil, error)
                return
            }
            guard let dict = schemaDict else {
                completion?(nil, error)
                return
            }
            
            var count: Int = 0
            let buildDocument: ([String: Any]) -> Void = { jsonDict in
                weakSelf?.schemaValidator.validate(json: jsonDict, withSchema: dict, completion: { error  in
                    count += 1
                    if error != nil, let doc = SCDDocument(scd: jsonDict) {
                        items.append(doc)
                    }
                    
                    if count == array.count {
                        completion?(items, nil);
                    }
                    
                })
            }
            
            for scdJson in array {
                buildDocument(scdJson)
            }
            
        }
        
    }
    
}
