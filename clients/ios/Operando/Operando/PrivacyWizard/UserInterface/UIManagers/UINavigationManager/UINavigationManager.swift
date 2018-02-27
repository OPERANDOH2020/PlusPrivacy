//
//  UINavigationManager.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

enum UIStoryboardType: String {
    case Main = "Main"
}

class UINavigationManager: NSObject {
    
    // MARK: - Private Methods
    fileprivate static func getViewController(_ storyboardName: String, bundle: Bundle?, controllerStoryboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: controllerStoryboardId)
        return viewController
    }
    
    // MARK: - Public Methods
    static func getMainScreenViewController() -> UIMainViewController {
        return getViewController(UIStoryboardType.Main.rawValue, bundle: nil, controllerStoryboardId: UIMainVCStoryboardId) as! UIMainViewController
    }
    
    static func getQuestionnaireTableViewController() -> UIQuestionnaireTableViewController {
        return getViewController(UIStoryboardType.Main.rawValue, bundle: nil, controllerStoryboardId: UIQuestionnaireTVCStoryboardId) as! UIQuestionnaireTableViewController
    }
    
    static func getPrivacySettingViewController() -> UIPrivacySettingViewController {
        return getViewController(UIStoryboardType.Main.rawValue, bundle: nil, controllerStoryboardId: UIPrivacySettingVCStoryboardId) as! UIPrivacySettingViewController
    }
    
    static func getSetPrivacyViewController() -> UISetPrivacyViewController {
        return getViewController(UIStoryboardType.Main.rawValue, bundle: nil, controllerStoryboardId: UISetPrivacyVCStoryboardId) as! UISetPrivacyViewController
    }
}
