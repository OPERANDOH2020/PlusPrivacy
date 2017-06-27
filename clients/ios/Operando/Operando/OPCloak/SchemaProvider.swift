//
//  SchemaProvider.swift
//  Operando
//
//  Created by Costin Andronache on 12/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

typealias SchemaCallback = (_ schema: [String: Any]?, _ error: NSError?) -> Void
protocol SchemaProvider {
    func getSchemaWithCallback(_ callback: SchemaCallback?)
}


class LocalFileSchemaProvider: SchemaProvider {
    
    let pathToFile: String
    
    init(pathToFile: String) {
        self.pathToFile = pathToFile
    }
    
    func getSchemaWithCallback(_ callback: SchemaCallback?) {
        var jsonError: NSError?
        var jsonSchemaDict: [String: Any]?
        
        guard let fileAsString = try? String(contentsOfFile: self.pathToFile),
            let data = fileAsString.data(using: .utf8) else {
                callback?(nil, .jsonSchemaNotFound)
                return
        }
        
        do {
            jsonSchemaDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let error {
                jsonError = error as NSError
            }

        
        callback?(jsonSchemaDict, jsonError);
    }
}
