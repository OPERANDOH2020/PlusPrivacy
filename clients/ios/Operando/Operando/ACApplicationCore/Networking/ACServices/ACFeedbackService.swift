//
//  ACFeedbackService.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/13/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

final class ACFeedbackService: NSObject {

    static func fetchFeedbackForm(completion: ((_ feedbackForm: [String: Any]?, _ error: NSError?) -> Void)?) {
        ACRestClient.shared.get(ACServiceEndpoints.feedbackFetch.rawValue, params: []) { (data, error) in
            guard let data = data as? [String: Any], error == nil else { completion?(nil, OPErrorContainer.errorInvalidServerResponse); return }
            completion?(data, nil)
        }
    }
    
    static func submitFeedbackForm(_ feedbackDictionary: Dictionary<String, String>, completion: ((_ succes: Bool) -> Void)?) {
        ACRestClient.shared.post(ACServiceEndpoints.feedbackSubmit.rawValue, params: nil, body: feedbackDictionary as NSDictionary) { (data, error) in
            let success = error == nil
            completion?(success)
        }
    }
}
