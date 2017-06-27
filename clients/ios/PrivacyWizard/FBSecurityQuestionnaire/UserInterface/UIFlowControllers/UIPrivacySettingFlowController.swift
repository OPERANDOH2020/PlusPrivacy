//
//  UIPrivacySettingFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIPrivacySettingFlowController: UIFlowController, UIPrivacySettingProtocol {

    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    var childViewController: UIViewController?
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        let mainScreenVC = UINavigationManager.getPrivacySettingViewController()
        mainScreenVC.delegate = self
        childViewController = mainScreenVC
        configuration.navigationController?.pushViewController(mainScreenVC, animated: true)
    }
    
    func launchFacebookPrivacySetting() {
        openConfigurator(withScope: .facebook)
    }
    
    func launchLinkedInPrivacySetting() {
        openConfigurator(withScope: .linkedIn)
    }
    
    private func openConfigurator(withScope scope: ACPrivacyWizardScope) {
        ACPrivacyWizard.shared.selectedScope = scope
        let setPrivacyTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UISetPrivacyFlowController(configuration: setPrivacyTVCConfiguration)
        childFlow?.start()
    }
}
