//
//  LocalJSSettingsProvider.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import JavaScriptCore


class LocalJSSettingsProvider : OSPSettingsProvider
{
    func getCurrentOSPSettingsWithCompletion(completion: ((_ settingsDict: NSDictionary?, _ error: NSError?) -> Void)?) {
        
        guard let path = Bundle.main.path(forResource: "OSP.Settings", ofType: "js") else
        {
            completion?(nil, nil);
            return
        }
            

        let urlPath = NSURL(fileURLWithPath: path)
        if let data = NSData(contentsOf: urlPath as URL)
        {
            let fileString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            let context = JSContext()
            
            let value =  context?.evaluateScript(fileString as! String)
            let jsonString = value?.toString()
            
            do
            {
                let dictionary = try JSONSerialization.jsonObject(with: (jsonString?.data(using: String.Encoding.utf8)!)!, options: .allowFragments)
                completion?(dictionary as? NSDictionary, nil)
                
            } catch
            {
                completion?(nil, nil)
            }
            
        }
        
        
        
        
    }
}
