//
//  ACPrivacyWizard.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

enum ACPrivacyWizardState {
    case interrogation
    case recommendation
    case final
}

enum ACPrivacyWizardScope {
    case facebook
    case linkedIn
    case twitter
    case googleLogin
    case googlePreferences
    case googleActivity
    case all
    
    func getNetworks() -> [String] {
        switch self {
        case .facebook:
            return ["facebook"]
        case .linkedIn:
            return ["linkedin"]
        case .twitter:
            return ["twitter"]
        case .googleActivity, .googleLogin, .googlePreferences:
            return ["google"]
        case .all:
            return ["facebook", "linkedin","twitter","google"]
        }
    }
    
    func getAppsListUrl() -> String {
        switch self {
        case .facebook:
            return "https://www.facebook.com/settings?tab=applications"
        case .linkedIn:
            return "https://www.linkedin.com/psettings/permitted-services"
        case .twitter:
            return "https://twitter.com/settings/applications?lang=en"
        case .googleLogin:
            return "https://myaccount.google.com/permissions"
        default:
            return ""
        }
    }
    
    func getNetworkUrl() -> String {
        switch self {
        case .facebook:
            return "https://www.facebook.com"
        case .linkedIn:
            return "https://www.linkedin.com/uas/login?session_redirect=https%3A%2F%2Fwww%2Elinkedin%2Ecom%2Fpsettings%2Fprivacy&fromSignIn=true&trk=uno-reg-join-mobile-sign-in"
        case .twitter:
            return "https://mobile.twitter.com/settings/safety"
//        case .googleLogin:
//            return "https://accounts.google.com/signin/v2/identifier?service=accountsettings&passive=1209600&osid=1&continue=https%3A%2F%2Fmyaccount.google.com%2Fintro%2Factivitycontrols&followup=https%3A%2F%2Fmyaccount.google.com%2Fintro%2Factivitycontrols&flowName=GlifWebSignIn&flowEntry=ServiceLogin"
            
//            return "https://accounts.google.com/"
        case  .googleLogin, .googleActivity:
            return "https://myaccount.google.com/activitycontrols"
        case .googlePreferences:
            return "https://www.google.com/preferences"
        case .all:
            return "https://www.facebook.com"
        }
    }
    
    func getWizardResourceName() -> String {
        switch self {
        case .facebook:
            return "facebook_iOS"
        case .linkedIn:
            return "linkedin-iOS"
        case .twitter:
            return "twitter"
        case .all:
            return "facebook_iOS"
        case .googleLogin:
            return "google_preferences_settings"
        case .googlePreferences:
            return "google_usual_settings"
        case .googleActivity:
            return "google_activity_controls"
        }
    }
}

class ACPrivacyWizard: NSObject {
    
    // MARK: - Properties
    private var state: ACPrivacyWizardState = .interrogation
    private var currentRecommendation: AMPrivacyRecommendation?
    private(set) var currentSettings = [AMPrivacySetting]()
    var privacySettings: AMPrivacySettings?
    var recommendedParameters: AMRecommendedSettings?
    var privacyWizardScope: ACPrivacyWizardScope = .all
    var selectedScope: ACPrivacyWizardScope = .all
    
    var connectedApps:[ConnectedApp] = []
    var inactiveConnectedApps:[ConnectedApp]?
    
    // MARK: - Lifecycle
    private override init() {
        super.init()
    }
    
    // MARK: - Shared Instance
    class var shared : ACPrivacyWizard {
        struct Singleton {
            static let instance = ACPrivacyWizard()
        }
        return Singleton.instance
    }
    
    // MARK: - Private Methods
    private func getCurrentChosenOptions() -> [Int] {
        var result = [Int]()
        
        for setting in currentSettings {
            if let selectedOption = setting.selectedOption {
                result.append(selectedOption)
            }
        }
        
        return result
    }
    
    private func getPrivacySettingsSuggestions() -> [AMPrivacySetting] {
        guard let previousSetting = currentSettings.last,
            let selectedOption = previousSetting.selectedOption,
            let currentRecommendation = currentRecommendation,
            let possibleChoicesIds = currentRecommendation.possibleChoicesIds,
            let possibleSuggestions = currentRecommendation.suggestions
            else { return [] }
        
        var suggestions = [Int]()
        
        if let selectedOptionIndex = possibleChoicesIds.index(of: selectedOption) {
            if possibleSuggestions.count > selectedOptionIndex {
                suggestions = possibleSuggestions[selectedOptionIndex]
            }
        }
        
        var result = [AMPrivacySetting]()
        if let lastSetting = currentSettings.last {
            result.append(lastSetting)
        }
        
        for suggestion in suggestions {
            if let privacySetting = privacySettings?.mappedPrivacySettings?[suggestion] {
                privacySetting.selectOption(withIndex: suggestion)
                result.append(privacySetting)
            }
        }
        
        currentSettings.removeLast()
        currentSettings.append(contentsOf: result)
        
        return result
    }
    
    private func retrieveQuestionAndSuggestions(completionHandler: @escaping (_ privacySettings: [AMPrivacySetting], _ state: ACPrivacyWizardState) -> Void) {
        JSPrivacyWizardContext.getNextQuestionAndSuggestions(selectedOptions: getCurrentChosenOptions(), networks: privacyWizardScope.getNetworks(), completionHandler: { [weak self] (data) in
            guard let strongSelf = self else { return }
            strongSelf.currentRecommendation = AMPrivacyRecommendation(dictionary: data as! [String : Any])
            if let currentRecommendation = strongSelf.currentRecommendation, let privacySettings = strongSelf.privacySettings, let setting = privacySettings.getPrivacySetting(withId: currentRecommendation.questionId) {
                strongSelf.currentSettings.append(setting)
                completionHandler([setting], .interrogation)
            } else {
                strongSelf.state = .final
                completionHandler(strongSelf.currentSettings, .final)
            }
        })
    }
    
    // MARK: - Public Methods
    func setup(completion: @escaping (_ success: Bool) -> Void) {
        ACSwarmManager.shared.retrieveConfiguration(forUser: "privacy_wizard@rms.ro", withPassword: "wizard") { [weak self] (error, privacySettings, recommendedSettings) in
            guard let strongSelf = self else { completion(false); return }
            DispatchQueue.main.async {
                strongSelf.privacySettings = privacySettings
                strongSelf.recommendedParameters = recommendedSettings
                completion(error == nil)
            }
        }
    }
    
    func reset() {
        state = .interrogation
        currentSettings = []
        currentRecommendation = nil
        privacyWizardScope = .all
    }
    
    func updatePrivacySettings(type: ACPrivacySettingsType, updatedSettings: AMPrivacySettings?) {
        guard let updatedSettings = updatedSettings else { return }
        if self.privacySettings == nil || type == .all {
            self.privacySettings = updatedSettings
            return
        }
        
        self.privacySettings?.update(type: type, updatedSettings: updatedSettings)
    }
    
    func getPrivacySettings(completion: @escaping (_ privacySettings: [AMPrivacySetting], _ state: ACPrivacyWizardState) -> Void) {
        switch state {
        case .interrogation:
            retrieveQuestionAndSuggestions(completionHandler: { (privacySettings, state) in
                completion(privacySettings, state)
            })
        case .recommendation:
            completion(getPrivacySettingsSuggestions(), .recommendation)
        case .final:
            completion([], .final)
        }
        
        if state != .final {
            state = state == .interrogation ? .recommendation : .interrogation
        }
    }
}
