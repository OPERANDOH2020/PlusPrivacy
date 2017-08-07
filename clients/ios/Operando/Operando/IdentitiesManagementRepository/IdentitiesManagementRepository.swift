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


class DummyIdentitiesRepository: IdentitiesManagementRepository{
    
    var domainsList: [Domain] = [Domain(id: "1", name: "dom1"),
                                 Domain(id: "2", name: "dom2"),
                                 Domain(id: "3", name: "dom3")]
    var realIdentity: String = "youAre@real.com"
    var generatedNewIdentity: String = "someRandomIdentity"
    var errorForAddIdentity: NSError?
    
    var onAddIdentity: ((_ identity: String) -> Void)?
    
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?){
        
        var identities: [String] = []
        for i in 1...15 {
            identities.append("identity \(i)")
        }
        
        DispatchQueue.main.async {
            completion?(IdentitiesListResponse(identitiesList: identities, indexOfDefaultIdentity: 14), nil)
        }
        
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
        DispatchQueue.main.async {
            completion?("", nil)
        }
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
