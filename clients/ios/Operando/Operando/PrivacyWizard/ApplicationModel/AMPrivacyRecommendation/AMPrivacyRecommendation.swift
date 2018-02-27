//
//  AMPrivacyRecommendation.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class AMPrivacyRecommendation: NSObject {
    private(set) var suggestions: [[Int]]?
    private(set) var possibleChoicesIds: [Int]?
    private(set) var questionId: Int?
    
    init?(dictionary: [String: Any]) {
        
        if let suggestionsArrays = dictionary["suggestions"] as? NSArray {
            suggestions = [[Int]]()
            for suggestionsArray in suggestionsArrays {
                if let suggestionsArray = suggestionsArray as? [Int] {
                    suggestions!.append(suggestionsArray)
                }
            }
        }
        
        if let choicesIds = dictionary["possible_choices_ids"] as? NSArray {
            if let choicesIds = choicesIds as? [Int] {
                possibleChoicesIds = choicesIds
            }
        }
        
        if let qId = dictionary["question_id"] as? NSNumber {
            questionId = qId.intValue
        }
    }
}
