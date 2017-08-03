//
//  Utils.swift
//  Operando
//
//  Created by Costin Andronache on 8/3/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
@testable import Operando


func createLogicPopulated(with info: LoginInfo) -> (UILoginViewLogic, UILoginViewOutlets) {
    let outlets = UILoginViewOutlets(emailTF: UITextField(), passwordTF: UITextField(), rememberMeSwitch: UISwitch(), signInButton: UIButton(), forgotPasswordButton: UIButton())
    
    let logic = UILoginViewLogic(outlets: outlets)
    
    outlets.emailTF?.text = info.email
    outlets.passwordTF?.text = info.password
    outlets.rememberMeSwitch?.isOn = info.wishesToBeRemembered
    
    return (logic, outlets)
}
