//
//  ACNetworkingConstants.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

enum ACSwarmPhase: String {
    
    case start                  = "start"
}

enum ACSwarmName: String {
    
    case login                  = "login.js"
    case privacyWizard          = "PrivacyWizardSwarm.js"
}

enum ACLoginConstructor: String {
    case userLogin              = "userLogin"
    case userLogout             = "logout"
}

enum ACPrivacyWizardConstructor: String {
    
    case getOSPSettings         = "getOSPSettings"
    case fetchRecommenderParams = "fetchRecommenderParams"
    case completeWizard         = "completeWizard"
}
