//
//  ACPrivacySettingsService.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/8/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

final class ACPrivacySettingsService: NSObject {

    static func fetchPrivacySettings(completion: @escaping (_ settings: AMPrivacySettings?, _ error: NSError?) -> Void) {
        ACRestClient.shared.get(ACServiceEndpoints.privacySettings.rawValue, params: []) { (data, error) in
            guard error == nil, let data = data as? [String: Any] else { completion(nil, OPErrorContainer.errorInvalidServerResponse); return }
            let settings = AMPrivacySettings(dictionary: data)
            completion(settings, nil)
        }
    }
}
