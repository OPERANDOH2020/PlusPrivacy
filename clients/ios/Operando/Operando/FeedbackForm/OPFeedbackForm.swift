//
//  OPFeedbackForm.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

protocol OPFeedbackFormProtocol {
    func getFeedbackForm(completion: ((_ feedbackForm: [String: Any]?, _ error: NSError?) -> Void)?)
    func submitFeedbackForm(feedbackDictionary: Dictionary<String, String>, completion: ((_ succes: Bool) -> Void)?)
}

enum OPFeedBackQuestionType: String {
    case multipleRating = "multipleRating"
    case multipleSelection = "multipleSelection"
    case textInput = "textInput"
    case radio = "radio"
}

struct OPFeedbackAnswer {
    let questionKey: String
    let itemName: String?
    let answer: Any
}

struct OPFeedbackQuestion {
    let id: Int
    let title: String
    let description: String?
    let items: [String]?
    let range: [Int]?
    let required: Bool
    let type: String
}

class OPFeedbackForm: NSObject {
    
    private var delegate: OPFeedbackFormProtocol?
    var questions: [OPFeedbackQuestion]
    var questionsTitlesById: Dictionary<Int, String>
    
    var answers: [OPFeedbackAnswer] = []
    
    init(delegate: OPFeedbackFormProtocol?) {
        self.delegate = delegate
        questions = [OPFeedbackQuestion]()
        questionsTitlesById = Dictionary<Int, String>()
        super.init()
    }
    
    func requestFeedbackForm(completion: @escaping ((_ success: Bool) -> Void)) {
        delegate?.getFeedbackForm(completion: { [weak self] (data, error) in
            guard let strongSelf = self, error == nil, let data = data else { completion(false); return }
            let parsedData = strongSelf.parseFeedbackQuestions(dictionary: data)
            strongSelf.questions = parsedData.questions
            strongSelf.questionsTitlesById = parsedData.questionsById
            completion(true)
        })
    }
    
    func submitFeedbackForm(feedbackDictionary: Dictionary<String, String>, completion: ((_ succes: Bool) -> Void)?) {
        delegate?.submitFeedbackForm(feedbackDictionary: feedbackDictionary, completion: { (success) in
            completion?(success)
        })
    }
    
    private func parseAnswers(dictionary: Dictionary<String,Any>) -> [OPFeedbackAnswer] {
        
        var answers: [OPFeedbackAnswer] = []
        
        if let dict = dictionary["feedback"] as? NSDictionary {
            
            for (key,value) in dict {
                
                if let key = key as? String {
                    
                    if let slice = key.slice(from: "[", to: "]"){
                        
                        let newKey = key.replace(target: "[\(slice)]", withString: "")
                        
                        answers.append(OPFeedbackAnswer(questionKey: newKey, itemName: slice, answer: value))
                        
                    }else {
                        answers.append(OPFeedbackAnswer(questionKey: key, itemName: nil, answer: value))
                    }
                }
            }
        }
        else {
            
        }
        
        return answers
    }
    
    private func parseFeedbackQuestions(dictionary: Dictionary<String,Any>) -> (questions: [OPFeedbackQuestion], questionsById: Dictionary<Int, String>) {
        
        var result = [OPFeedbackQuestion]()
        var questionsById = Dictionary<Int, String>()
        
        if let feedbackQuestions = dictionary["result"] as? NSArray {
            var index = 0
            for question in feedbackQuestions {
                if let question = question as? Dictionary<String, Any> {
                    result.append(OPFeedbackQuestion(id: index,
                                                     title: question["title"] as? String ?? "",
                                                     description: question["description"] as? String,
                                                     items: question["items"] as? [String],
                                                     range: question["range"] as? [Int],
                                                     required: question["required"] as? Bool ?? false,
                                                     type: question["type"] as? String ?? ""))
                    questionsById[index] = question["title"] as? String ?? ""
                    index += 1
                }
            }
        }
        
        return (result, questionsById)
    }
}
