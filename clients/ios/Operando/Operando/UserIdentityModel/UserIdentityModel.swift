//
//  UserIdentityModel.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

class UserIdentityModel
{

    let sessionId: String
    let userId: String
    let email: String
    init?(swarmClientLoginReply: [String: Any])
    {
        guard let userId = swarmClientLoginReply["userId"] as? String,
              let sessionId = swarmClientLoginReply["sessionId"] as? String,
              let email = swarmClientLoginReply["email"] as? String,
              let authenticated = swarmClientLoginReply["authenticated"] as? Bool
            else
        {
                return nil
        }
        
        if !authenticated {return nil}
        
        
        self.userId = userId
        self.sessionId = sessionId
        self.email = email
    }
    
    
    private init(){
        self.sessionId = ""
        self.userId = ""
        self.email = ""
    }
    
    static let empty = UserIdentityModel()
}
