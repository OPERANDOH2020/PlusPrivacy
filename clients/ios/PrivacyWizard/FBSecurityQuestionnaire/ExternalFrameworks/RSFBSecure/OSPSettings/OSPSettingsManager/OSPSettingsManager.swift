//
//  OSPSettingsManager.swift
//  Operando
//
//  Created by Costin Andronache on 8/11/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

typealias ErrorCallback = (_ error: NSError?) -> Void

typealias SettingsResultCallback = ()

protocol OSPSettingsProvider
{
    func getCurrentOSPSettingsWithCompletion(completion: ((_ settingsDict: NSDictionary?, _ error: NSError?) -> Void)?)
}

protocol OSPSettingsReader
{
    func logUserOnSite(site: String, withCompletion completion: ErrorCallback?)
    func redirectAndReadSettings(settingsAsJsonString: String, onAddress address: String, completion: ((_ readSettings: NSDictionary?, _ error: NSError?) -> Void)?)
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
    
    func readSettingsWithProvider(provider: OSPSettingsProvider, andApplier applier: OSPSettingsReader, withCompletion completion: ((_ results: [SettingsReadResult]?, _ error : NSError?) -> Void)?)
    {
        self.settingsApplier = applier
        provider.getCurrentOSPSettingsWithCompletion { (settingsDict, error) in
            
            if let error = error
            {
                completion?(nil, error)
                return
            }
            
            guard let dict = settingsDict else {
                completion?(nil, NSError.errorCorruptSettingsDict);
                return
            }
            
            self.buildReadSettingsResultWithSettingsDict(settingsDict: dict, withCompletion: completion)
        }
    }
    
    
    func buildReadSettingsResultWithSettingsDict(settingsDict: NSDictionary, withCompletion completion: ((_ results: [SettingsReadResult]?, _ error: NSError?) -> Void)?)
    {
        guard let settingsSiteKeys = settingsDict.allKeys as? [String] else {completion?(nil, nil); return}
        let resultsArray = NSMutableArray()
        
        self.applySettingsForSiteKeyAtIndex(index: 0, fromKeys: settingsSiteKeys, inSettingsDict: settingsDict, aggregateResultsIn: resultsArray) { (error) in
            if let error = error
            {
                completion?(nil, error)
                return
            }
            
            var results: [SettingsReadResult] = []
            for obj in resultsArray
            {
                results.append(obj as! SettingsReadResult)
            }
            
            completion?(results, nil)
        }
    }

    
    
    func applySettingsForSiteKeyAtIndex(index: Int, fromKeys settingsDictKeys: [String], inSettingsDict dict: NSDictionary, aggregateResultsIn results: NSMutableArray, withCompletion completion: ErrorCallback?)
    {
        guard index >= 0 && index < settingsDictKeys.count else {completion?(nil); return;}
        guard let siteDict = dict[settingsDictKeys[index]] as? NSDictionary else {completion?(NSError.errorValuesMissing); return}
        guard let siteKeys = siteDict.allKeys as? [String] else { completion?(NSError.errorCorruptSettingsDict); return}
        // main body
        
        let siteURL = "https://www.\(settingsDictKeys[index]).com"
        
        let newSettings = SettingsReadResult()
        newSettings.siteName = settingsDictKeys[index]
        results.add(newSettings)
        
        self.settingsApplier?.logUserOnSite(site: siteURL, withCompletion: { (error) in
            
            if let error = error
            {
                completion?(error)
                return;
            }
            
            //start an iteration, beginning from index 0
            self.readForSettingKeyAtIndex(keyIndex: 0, inKeys: siteKeys, inSiteDict: siteDict, populateSettingsResult: newSettings, completion: { (error) in
                
                if let error = error
                {
                    //something has occured, abort everything
                    completion?(error)
                    return
                }
                
                //the error is nil, which means that all the keys have been iterated
                // we can continue with the next site
                
                self.applySettingsForSiteKeyAtIndex(index: index+1, fromKeys: settingsDictKeys, inSettingsDict: dict, aggregateResultsIn: results,
                                                   withCompletion: completion)
                
            })
            
        })
        
    }
    
    
    func readForSettingKeyAtIndex(keyIndex: Int, inKeys keys: [String], inSiteDict siteDict: NSDictionary, populateSettingsResult settingsResult: SettingsReadResult, completion: ErrorCallback?)
    {
        guard keyIndex >= 0 && keyIndex < keys.count else {completion?(nil); return;}
        
        let currentSiteDict = siteDict[keys[keyIndex]] as? [String: Any]
        guard let settingsDict = currentSiteDict?["read"] as? NSDictionary,
                  let url = settingsDict["url"] as? String
        
        else
        {
            completion?(NSError.errorValuesMissing);
            return
        }
        
        do
        {
            let settingsDictData = try JSONSerialization.data(withJSONObject: settingsDict, options: [])
            let settingsDictString = NSString(data: settingsDictData, encoding: String.Encoding.utf8.rawValue)
            self.settingsApplier?.redirectAndReadSettings(settingsAsJsonString: settingsDictString as! String, onAddress: url, completion: { (readSettings, error) in
                
                if let error = error
                {
                    settingsResult.resultsPerSettingName[keys[keyIndex]] = ["An exception occurred": error.localizedDescription]
                }
                else
                {
                    settingsResult.resultsPerSettingName[keys[keyIndex]] = readSettings
                }
                
                self.readForSettingKeyAtIndex(keyIndex: keyIndex+1, inKeys: keys, inSiteDict: siteDict, populateSettingsResult: settingsResult, completion: completion)
                
            })
        }
        catch
        {
            completion?(NSError.errorOnJQuerySettingsStringify)
        }

    }
    
    
    
}

