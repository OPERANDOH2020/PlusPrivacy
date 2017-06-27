//
//  UIMainScreenFlowController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIMainScreenFlowController: UIFlowController, UIMainScreenVCDelegate, DisclaimerViewDelegate {
    
    let configuration : UIFlowConfiguration
    var childFlow : UIFlowController?
    private var childViewController: UIMainViewController?
    private lazy var infoView = DisclaimerView.initView()
    
    required init(configuration : UIFlowConfiguration) {
        self.configuration = configuration
    }
    
    func start() {
        childViewController = UINavigationManager.getMainScreenViewController()
        childViewController!.setup(delegate: self)
        configuration.navigationController?.pushViewController(childViewController!, animated: true)
        setupPrivacyWizard()
    }
    
    private func setupPrivacyWizard() {
        ACPrivacyWizard.shared.setup { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.childViewController?.canStartWorkflow(allowed: success)
        }
    }
    
    // Mark: - Main Screen VC Delegate Methods
    func openQuestionnaire() {
        presentOptions()
    }
    
    func displayInfo() {
        infoView = DisclaimerView.initWith(title: "About Privacy Wizard", content: "Privacy Wizard is a mobile component part of OPERANDO, an online, open-source privacy enforcement, rights assurance and optimization platform.\n\nPrivacy Wizard helps the user personalize specific privacy levels & settings throughout social networks and other online services.\n\nOPERANDO is an EU Horizon 2020 funded project developed by an international consortium of 7 partners: Oxford Computer Consultants Ltd - UK, Arteevo Technologies Ltd - Israel, Stelar Security Technology Law Research UG - Germany, RomSoft - Romania, Fundacion TECNALIA Research & Innovation - Spain, University of Southampton - UK, University of Piraeus Research Center - Greece, Progetti di Impresa srl and Fondazione Centro San Raffaele / Ospedale San Raffaele - Italy.\n\nThe OPERANDO platform will support flexible and viable business models, including targeting of individual market segments such as public administration, social networks and Internet of Things.\n\nThe project innovates in being the first truly open online privacy platform that allows application developers establish and operate their own privacy services while creating federated business partnerships.", delegate: self)
        childViewController?.view.addSubview(infoView)
        infoView.setNeedsDisplay()
    }
    
    private func presentOptions() {
        guard let childViewController = childViewController else { return }
        UIAlertViewController.presentXLActionController(from: childViewController, headerTitle: "Options", actions: [
            ((title: "Facebook", subtitle: "Set your privacy on Facebook.", image: UIImage(named: "facebook_icon_"), callback: {
                self.openQuestionnnaire(withScope: .facebook)
            })),
            ((title: "LinkedIn", subtitle: "Set your privacy on LinkedIn.", image: UIImage(named: "linkedin_icon_"), callback: {
                self.openQuestionnnaire(withScope: .linkedIn)
            })),
            ((title: "All Social Networks", subtitle: "Set your privacy on multiple social media at once.", image: UIImage(named: "multiple_social_media_"), callback: {
                self.openQuestionnnaire(withScope: .all)
            }))
            ])
    }
    
    private func openQuestionnnaire(withScope scope: ACPrivacyWizardScope) {
        ACPrivacyWizard.shared.selectedScope = scope
        let questionnaireTVCConfiguration = UIFlowConfiguration(window: nil, navigationController: configuration.navigationController, parent: self)
        childFlow = UIQuestionnaireFlowController(configuration: questionnaireTVCConfiguration)
        (childFlow as? UIQuestionnaireFlowController)?.setup(withPrivacyWizardScope: scope)
        childFlow?.start()
    }
    
    func acceptDisclaimer() {
        infoView.removeFromSuperview()
    }
}
