//
//  IdentitiesManagementRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


protocol IdentitiesManagementRepository {
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?)
    func getCurrentListOfDomainsWith(completion: ((_ domainsList: [Domain], _ error: NSError?) -> Void)?)
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?)
    func add(identity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    func remove(identity: String, withCompletion completion: ((_ nextDefaultIdentity: String, _ error: NSError?) -> Void)?)
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    func getRealIdentityWith(completion: ((_ identity: String, _ error: NSError?) -> Void)?)
    
}


class DummyIdentitiesRepository: IdentitiesManagementRepository{
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
        
        var domains: [Domain] = []
        for i in 1...15 {
            domains.append(Domain(id: "id\(i)", name: "domain\(i)"))
        }
        DispatchQueue.main.async {
            completion?(domains, nil)
        }
    }
    
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.async {
            completion?("rx45745", nil);
        }
        
    }
    func add(identity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.async {
            completion?(true, nil)
        }
        
    }
    func remove(identity: String, withCompletion completion: ((_ success: String, _ error: NSError?) -> Void)?){
        DispatchQueue.main.async {
            completion?("", nil)
        }
    }
    
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?){
        DispatchQueue.main.async {
            completion?(true, nil)
        }
    }
    
    func getRealIdentityWith(completion: ((String, NSError?) -> Void)?) {
        completion?("youAre@real.com", nil)
    }
}
