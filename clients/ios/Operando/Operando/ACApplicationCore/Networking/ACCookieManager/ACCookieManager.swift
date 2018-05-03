//
//  ACCookieManager.swift
//  Operando
//
//  Created by Cristi Sava on 17/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import WebKit
extension WKWebsiteDataStore {
    
    func goCookiesExists(callback: @escaping CallbackWithBool){
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                
                if record.displayName.contains(find: "google") {
                    
                    callback(true)
                    return
                }
            }

            callback(false)
        }
    }
    
    func twCookiesExists(callback: @escaping CallbackWithBool){
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                
                if record.displayName == "twitter.com" {
                    
                    callback(true)
                    return
                }
            }

            callback(false)
        }
    }
    
    func lkCookiesExists(callback: @escaping CallbackWithBool){
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                
                if record.displayName == "linkedin.com" {
                    
                    callback(true)
                    return
                }
            }

            callback(false)
        }
    }
    
    func fbCookiesExists(callback: @escaping CallbackWithBool){
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                
                if record.displayName == "facebook.com" {
                    
                    callback(true)
                    return
                }
            }
            
            callback(false)
            
        }
    }
    
    func deleteCookiesFromFacebook(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                
                if record.displayName == "facebook.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        
                        callback()
                    })
                }
            }
            
            if cookiesCount == 0 {
                callback()
            }
        }
    }
    
    func deleteCookiesFromLinkedin(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                if record.displayName == "linkedin.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                }
            }
            if cookiesCount == 0 {
                callback()
            }
        }
    }
    
    func deleteCookiesFromTwitter(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                if record.displayName == "twitter.com" {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                cookiesCount += 1
                }
            }
            
            if cookiesCount == 0 {
                callback()
            }
        }
    }
    
    func deleteCookiesFromGoogle(callback: @escaping VoidBlock){
        
        let storage = WKWebsiteDataStore.default()
        
        storage.fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) { (records) in
            
            var cookiesCount = 0
            
            for record in records {
                if record.displayName.contains(find: "google") {
                    storage.removeData(ofTypes: [WKWebsiteDataTypeCookies], for: [record], completionHandler: {
                        callback()
                    })
                }
            }
            if cookiesCount == 0 {
                callback()
            }
        }
    }
}
