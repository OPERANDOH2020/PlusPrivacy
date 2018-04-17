//
//  ACCookieManager.swift
//  Operando
//
//  Created by Cristi Sava on 17/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import WebKit
extension WKWebsiteDataStore {
    
    func deleteCookiesFromFacebook(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            for record in records {
                
                if record.displayName == "facebook.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        
                        callback()
                    })
                }
            }
            
            if records.count == 0 {
                callback()
            }
        }
    }
    
    func deleteCookiesFromLinkedin(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            for record in records {
                if record.displayName == "linkedin.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                }
                
            }
                if records.count == 0 {
                    callback()
                }
        }
    }
    
    func deleteCookiesFromTwitter(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            for record in records {
                if record.displayName == "twitter.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                }
            }
            
            if records.count == 0 {
                callback()
            }
        }
    }
    
    func deleteCookiesFromGoogle(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            for record in records {
                if record.displayName == "google.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                }
            }
            if records.count == 0 {
                callback()
            }
        }
    }
}
