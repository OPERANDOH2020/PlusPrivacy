//
//  UserIdentityModel.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

class UserIdentityModel: NSObject
{
    private var _username: String = ""
    private var _password: String = ""
    
    var username : String
    {
        get
        {
            return _username
        }
    }
    
    init(username: String, password: String)
    {
        super.init()
        _username = username
        _password = password
    }
}
