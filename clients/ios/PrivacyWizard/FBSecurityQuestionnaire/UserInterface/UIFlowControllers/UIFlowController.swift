//
//  UIFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

struct UIFlowConfiguration {
    let window : UIWindow?
    let navigationController : UINavigationController?
    let parent : UIFlowController?
}

protocol UIFlowController {
    init(configuration : UIFlowConfiguration)
    func start()
}
