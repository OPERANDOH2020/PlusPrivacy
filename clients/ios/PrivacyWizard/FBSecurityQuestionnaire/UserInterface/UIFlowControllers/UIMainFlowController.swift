//
//  UIMainFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIMainFlowController: UIFlowController {
    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        if let frame = configuration.window?.bounds {
            navigationController.view.frame = frame
        }
        
        configuration.window?.rootViewController = navigationController
        configuration.window?.makeKeyAndVisible()
        
        let mainScreenVCConfiguration = UIFlowConfiguration(window: nil, navigationController: navigationController, parent: self)
        childFlow = UIMainScreenFlowController(configuration: mainScreenVCConfiguration)
        childFlow?.start()
    }
}
