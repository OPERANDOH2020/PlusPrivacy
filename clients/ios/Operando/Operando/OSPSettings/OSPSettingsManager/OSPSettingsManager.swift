//
//  OSPSettingsManager.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

typealias ErrorCallback = (error: NSError?) -> Void

typealias SettingsResultCallback = ()

protocol OSPSettingsProvider
{
    func getCurrentOSPSettingsWithCompletion(completion: ((settingsDict: NSDictionary?, error: NSError?) -> Void)?)
}

protocol OSPSettingsReader
{
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?)
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((readSettings: NSDictionary?, error: NSError?) -> Void)?)
}


class SettingsReadResult: NSObject
{
    var siteName: String = ""
    var resultsPerSettingName: [String : NSDictionary] = [:]
    
    override var description: String
    {
        return "\(siteName) -- \(self.resultsPerSettingName)"
    }
}





class OSPSettingsManager
{
    
    var settingsApplier: OSPSettingsReader?
    var errorCallback: ErrorCallback?
    
    func readSettingsWithProvider(provider: OSPSettingsProvider, andApplier applier: OSPSettingsReader, withCompletion completion: ((results: [SettingsReadResult]?, error : NSError?) -> Void)?)
    {
        self.settingsApplier = applier
        provider.getCurrentOSPSettingsWithCompletion { (settingsDict, error) in
            
            if let error = error
            {
                completion?(results: nil, error: error)
                return
            }
            
            guard let dict = settingsDict else {
                completion?(results: nil, error: NSError.errorCorruptSettingsDict);
                return
            }
            
            self.buildReadSettingsResultWithSettingsDict(dict, withCompletion: completion)
        }
    }
    
    
    func buildReadSettingsResultWithSettingsDict(settingsDict: NSDictionary, withCompletion completion: ((results: [SettingsReadResult]?, error: NSError?) -> Void)?)
    {
        guard let settingsSiteKeys = settingsDict.allKeys as? [String] else {completion?(results: nil, error: nil); return}
        let resultsArray = NSMutableArray()
        
        self.applySettingsForSiteKeyAtIndex(0, fromKeys: settingsSiteKeys, inSettingsDict: settingsDict, aggregateResultsIn: resultsArray) { (error) in
            if let error = error
            {
                completion?(results: nil, error: error)
                return
            }
            
            var results: [SettingsReadResult] = []
            for obj in resultsArray
            {
                results.append(obj as! SettingsReadResult)
            }
            
            completion?(results: results, error: nil)
        }
    }

    
    
    func applySettingsForSiteKeyAtIndex(index: Int, fromKeys settingsDictKeys: [String], inSettingsDict dict: NSDictionary, aggregateResultsIn results: NSMutableArray, withCompletion completion: ErrorCallback?)
    {
        guard index >= 0 && index < settingsDictKeys.count else {completion?(error: nil); return;}
        guard let siteDict = dict[settingsDictKeys[index]] as? NSDictionary else {completion?(error: NSError.errorValuesMissing); return}
        guard let siteKeys = siteDict.allKeys as? [String] else { completion?(error: NSError.errorCorruptSettingsDict); return}
        // main body
        
        let siteURL = "https://www.\(settingsDictKeys[index]).com"
        
        let newSettings = SettingsReadResult()
        newSettings.siteName = settingsDictKeys[index]
        results.addObject(newSettings)
        
        self.settingsApplier?.logUserOnSite(siteURL, withCompletion: { (error) in
            
            if let error = error
            {
                completion?(error: error)
                return;
            }
            
            //start an iteration, beginning from index 0
            self.readForSettingKeyAtIndex(0, inKeys: siteKeys, inSiteDict: siteDict, populateSettingsResult: newSettings, completion: { (error) in
                
                if let error = error
                {
                    //something has occured, abort everything
                    completion?(error: error)
                    return
                }
                
                //the error is nil, which means that all the keys have been iterated
                // we can continue with the next site
                
                self.applySettingsForSiteKeyAtIndex(index+1, fromKeys: settingsDictKeys, inSettingsDict: dict, aggregateResultsIn: results,
                                                   withCompletion: completion)
                
            })
            
        })
        
    }
    
    
    func readForSettingKeyAtIndex(keyIndex: Int, inKeys keys: [String], inSiteDict siteDict: NSDictionary, populateSettingsResult settingsResult: SettingsReadResult, completion: ErrorCallback?)
    {
        guard keyIndex >= 0 && keyIndex < keys.count else {completion?(error: nil); return;}
        
        guard let settingsDict = siteDict[keys[keyIndex]]?["read"] as? NSDictionary,
                  url = settingsDict["url"] as? String
        
        else
        {
            completion?(error: NSError.errorValuesMissing);
            return
        }
        
        do
        {
            let settingsDictData = try NSJSONSerialization.dataWithJSONObject(settingsDict, options: [])
            let settingsDictString = NSString(data: settingsDictData, encoding: NSUTF8StringEncoding)
            self.settingsApplier?.redirectAndReadSettings(settingsDictString as! String, onAddress: url, completion: { (readSettings, error) in
                
                if let error = error
                {
                    settingsResult.resultsPerSettingName[keys[keyIndex]] = ["An exception occurred": error.localizedDescription]
                }
                else
                {
                    settingsResult.resultsPerSettingName[keys[keyIndex]] = readSettings
                }
                
                self.readForSettingKeyAtIndex(keyIndex+1, inKeys: keys, inSiteDict: siteDict, populateSettingsResult: settingsResult, completion: completion)
                
            })
        }
        catch
        {
            completion?(error: NSError.errorOnJQuerySettingsStringify)
        }

    }
    
    
    
}

