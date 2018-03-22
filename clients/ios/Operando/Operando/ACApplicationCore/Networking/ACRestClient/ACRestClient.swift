//
//  ACRestClient.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/8/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum ACServiceEndpoints: String {
    case privacySettings = "/social-networks/privacy-settings"
}

class ACRestClient: NSObject {
    typealias QueryParam = (name: String, val: String)
    typealias QueryParams = [QueryParam]
    typealias Callback = (AnyObject?, NSError?) -> ()
    
    fileprivate var session: URLSession?
    fileprivate let API_URL = "https://plusprivacy.club:8080"
    
    static let shared = ACRestClient()
    
    override init() {
        super.init()
        
        setupURLSession()
    }
    
    // MARK: - Public Methods
    func get(_ path: String, params: QueryParams, cb: @escaping Callback) {
        get(API_URL, path: path, params: params, cb: cb)
    }
    
    func post(_ path: String, params: QueryParams?, body: NSDictionary, cb: @escaping Callback) {
        post(API_URL, path: path, params: params, body: body, cb: cb)
    }
    
    // MARK: - Private Methods
    private func get(_ url: String, path: String, params: QueryParams, cb: @escaping Callback) {
        guard let uri = getRequestURL(url, path: path, params:  params) else {return}
        
        let request = NSMutableURLRequest()
        request.url = uri
        request.httpMethod = "GET"
        
        startURLSession(request as URLRequest, callback: cb)
    }
    
    private func post(_ url: String, path: String, params: QueryParams?, body: NSDictionary, cb: @escaping Callback) {
        guard let uri = URL(string: url + path) else {return}
        let request = NSMutableURLRequest()
        request.url = uri
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonData
            
            startURLSession(request as URLRequest, callback: cb)
        } catch let error {
            cb(nil, error as NSError)
        }
    }
    
    fileprivate func startURLSession(_ request: URLRequest, callback: @escaping Callback) {
        self.session?.configuration.httpAdditionalHeaders = self.getSessionAdditionalHeaders()
        
        let dataTask = session?.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if let _ = response as? HTTPURLResponse {
                if let receivedData = data {
                    do {
                        if let result = try JSONSerialization.jsonObject(with: receivedData, options: []) as? NSArray {
                            self.call(callback, json: ["result" : result], error: nil)
                        } else if let result = try JSONSerialization.jsonObject(with: receivedData, options: []) as? NSDictionary {
                            self.call(callback, json: result, error: nil)
                        }
                    } catch {
                        self.call(callback, json: nil, error: ACErrorContainer.getInvalidServerResponseError())
                    }
                } else {
                    self.call(callback, json: nil, error: ACErrorContainer.getInvalidServerResponseError())
                }
            } else {
                self.call(callback, json: nil, error: ACErrorContainer.getInvalidServerResponseError())
            }
        })
        
        
        if let task = dataTask {
            
            
            if ACNetworkReachability.hasInternetConnection() {
                task.resume()
            } else {
                self.call(callback, json: nil, error: ACErrorContainer.getProblemWithTheInternetError())
            }
        }
    }
    
    fileprivate func call(_ cb: @escaping Callback, json: NSDictionary?, error: NSError?) {
        DispatchQueue.main.async {
            cb(json, error)
        }
    }
    
    fileprivate func setupURLSession() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = getSessionAdditionalHeaders()
        config.timeoutIntervalForRequest = 5
        session = URLSession(configuration: config)
    }
    
    fileprivate func getSessionAdditionalHeaders() -> [AnyHashable: Any] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    fileprivate func queryString(_ params: QueryParams?) -> String? {
        if let ps = params {
            if ps.count > 0 && ps.count < 15 {
                let query = ps.map() { p in "\(p.name)=\(p.val)" }
                return query.joined(separator: "&")
            }
        }
        
        return nil
    }
    
    fileprivate func getRequestURL(_ url: String, path: String, params: QueryParams) -> URL? {
        var parameters = ""
        if let body = queryString(params) {
            parameters = "?" + body
        }
        
        return URL(string: url + path + parameters)
    }
}
