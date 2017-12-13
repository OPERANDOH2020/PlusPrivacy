//
//  IdentitiesManagementRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation



protocol IdentitiesManagementRepository: class {
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?)
    func getCurrentListOfDomainsWith(completion: ((_ domainsList: [Domain], _ error: NSError?) -> Void)?)
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?)
    func add(identity: String, withCompletion completion: CallbackWithError?)
    func remove(identity: String, withCompletion completion: ((_ nextDefaultIdentity: String, _ error: NSError?) -> Void)?)
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: CallbackWithError?)
    func getRealIdentityWith(completion: ((_ identity: String, _ error: NSError?) -> Void)?)
}


class DummySynchronousIdentitiesRepository: IdentitiesManagementRepository{
    
    var domainsList: [Domain] = [Domain(id: "1", name: "dom1"),
                                 Domain(id: "2", name: "dom2"),
                                 Domain(id: "3", name: "dom3")]
    var realIdentity: String = "youAre@real.com"
    var generatedNewIdentity: String = "someRandomIdentity"
    var errorForAddIdentity: NSError?
    var identitiesList: [String] = []
    var indexOfDefaultIdentity: Int? = 0
    
    var onAddIdentity: ((_ identity: String) -> Void)?
    var onRemove: ((_ identity: String, _ completion: ((_ nextDefault: String, _ error: NSError?) -> Void)?) -> Void)?
    
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?){
        
        if self.identitiesList.count == 0 {
            for i in 1...15 {
                self.identitiesList.append("identity \(i)")
            }
            
        }
        
            completion?(IdentitiesListResponse(identitiesList: self.identitiesList, indexOfDefaultIdentity: self.indexOfDefaultIdentity), nil)
        
    }
    func getCurrentListOfDomainsWith(completion: ((_ domainsList: [Domain], _ error: NSError?) -> Void)?){
    
        DispatchQueue.main.async {
            completion?(self.domainsList, nil)
        }
    }
    
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.async {
            completion?(self.generatedNewIdentity, nil);
        }
        
    }
    func add(identity: String, withCompletion completion: CallbackWithError?){
        
        self.onAddIdentity?(identity)
        DispatchQueue.main.async {
            completion?(self.errorForAddIdentity)
        }
        
    }
    func remove(identity: String, withCompletion completion: ((_ success: String, _ error: NSError?) -> Void)?){
        
        if self.onRemove == nil {
            completion?("", nil)
            return
        }
        
        self.onRemove?(identity, completion)
    }
    
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: CallbackWithError?){
        DispatchQueue.main.async {
            completion?(nil)
        }
    }
    
    func getRealIdentityWith(completion: ((String, NSError?) -> Void)?) {
        completion?(self.realIdentity, nil)
    }
}
