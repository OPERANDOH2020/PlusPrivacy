//
//  ACPrivacySettingsService.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/8/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum ACPrivacySettingsType: String {
    case all = "all"
    case facebook = "facebook"
    case twitter = "twitter"
    case linkedin = "linkedin"
    case google = "google"
}

final class ACPrivacySettingsService: NSObject {

    static func fetchPrivacySettings(type: ACPrivacySettingsType, completion: @escaping (_ settings: AMPrivacySettings?, _ error: NSError?) -> Void) {
        let path = getPrivacySettingsPath(byType: type)
        ACRestClient.shared.get(path, params: []) { (data, error) in
            guard error == nil, let data = data as? [String: Any] else { completion(nil, OPErrorContainer.errorInvalidServerResponse); return }
            let settings = AMPrivacySettings(with: data, type: type)
            completion(settings, nil)
        }
    }
    
    static private func getPrivacySettingsPath(byType type: ACPrivacySettingsType) -> String {
        let defaultPath = ACServiceEndpoints.privacySettings.rawValue
        return "\(defaultPath)/\(type.rawValue)"
    }
}
