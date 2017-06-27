//
//  UsersRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


typealias UserOperationCallback = (_ error: NSError?, _ identityModel: UserIdentityModel) -> Void
typealias CallbackWithError = (_ error: NSError?) -> Void

protocol UsersRepository {
    func loginWith(email: String, password: String, withCompletion completion: UserOperationCallback?)
    func registerNewUserWith(email: String, password: String, withCompletion completion: CallbackWithError?)
    func logoutUserWith(completion: CallbackWithError?)
    func resetPasswordFor(email: String, completion: CallbackWithError?)
    func changeCurrent(password: String, to newPassword: String, withCompletion completion: ((_ error: NSError?) -> Void)?)

}

