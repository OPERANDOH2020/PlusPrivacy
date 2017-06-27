//
//  UIQuestionnaireFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIQuestionnaireFlowController: UIFlowController, UIQuestionnaireTVCProtocol {
    
    // MARK: - Properties
    let configuration : UIFlowConfiguration
    let privacyWizard = ACPrivacyWizard.shared
    private var wizzardIsFinished = false
    var childFlow : UIFlowController?
    
    // MARK: - Lifecycle
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    func setup(withPrivacyWizardScope scope: ACPrivacyWizardScope) {
        privacyWizard.privacyWizardScope = scope
    }
    
    func start() {
        let questionnaireTVC = UINavigationManager.getQuestionnaireTableViewController()
        questionnaireTVC.delegate = self
        configuration.navigationController?.pushViewController(questionnaireTVC, animated: true)
    }
    
    // MARK: - UIQuestionnaireTVCProtocol Methods
    func requestNewPrivacySettings(completionHandler: @escaping (_ privacySettings: UIQuestionnaireTVCObject?) -> Void) {
        if wizzardIsFinished {
            completionHandler(nil)
            wizardDidFinished()
        } else {
            ACPrivacyWizard.shared.getPrivacySettings { [weak self] (privacySettings, state) in
                guard let strongSelf = self else {
                    completionHandler(UIQuestionnaireTVCObject(status: "", actionName: "", privacySettings: privacySettings))
                    return
                }
                strongSelf.wizzardIsFinished = state == .final
                let result = UIQuestionnaireTVCObject(status: strongSelf.getStatus(forState: state), actionName: strongSelf.getActionName(forState: state), privacySettings: privacySettings)
                completionHandler(result)
            }
        }
    }
    
    func viewDidUnload() {
        ACPrivacyWizard.shared.reset()
    }
    
    // MARK: - Private Methods
    private func getStatus(forState state: ACPrivacyWizardState) -> String {
        switch state {
        case .interrogation:
            return "Choose your privacy preference"
        case .recommendation:
            return "Recommended privacy settings"
        case .final:
            return "Privacy settings finalized"
        }
    }
    
    private func getActionName(forState state: ACPrivacyWizardState) -> String {
        switch state {
        case .interrogation:
            return "Submit"
        case .recommendation:
            return "Continue"
        case .final:
            return "Apply settings"
        }
    }
    
    private func wizardDidFinished() {
        switch privacyWizard.privacyWizardScope {
        case .facebook:
            launchPrivacySetting()
        case .linkedIn:
            launchPrivacySetting()
        case .all:
            openPrivacySettingsScreen()
        }
    }
    
    private func openPrivacySettingsScreen() {
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UIPrivacySettingFlowController(configuration: questionnaireTVCConfiguration)
        childFlow?.start()
    }
    
    func launchPrivacySetting() {
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UISetPrivacyFlowController(configuration: questionnaireTVCConfiguration)
        childFlow?.start()
    }
}

