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
    func getCurrentOSPSettingsWithCompletion(completion: ((settingsDict: NSDictionary?, error: NSError?) -> Void)?) {
        
        guard let path = NSBundle.mainBundle().pathForResource("OSP.Settings", ofType: "js") else
        {
            completion?(settingsDict: nil, error: nil);
            return
        }
            

        let urlPath = NSURL(fileURLWithPath: path)
        if let data = NSData(contentsOfURL: urlPath)
        {
            let fileString = NSString(data: data, encoding: NSUTF8StringEncoding)
            let context = JSContext()
            
            let value =  context.evaluateScript(fileString as! String)
            let jsonString = value.toString()
            
            do
            {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
                completion?(settingsDict: dictionary as? NSDictionary, error: nil)
                
            } catch
            {
                completion?(settingsDict: nil, error: nil)
            }
            
        }
        
        
        
        
    }
}