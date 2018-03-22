//
//  OPFeedbackFormVCInteractor.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct OPFeedbackFormVCCallbacks
{
    let whenSubmitEndedWithSuccess: VoidBlock?
}

protocol OPFeedbackFormVCInteractorProtocol {
    func didSubmitForm()
    func viewDidLoad()
    func numberOfRows() -> Int
    func cell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    func height(forRowAt indexPath: IndexPath) -> CGFloat
    func changeResponse()
}

class OPFeedbackFormVCInteractor: NSObject {
    
    fileprivate let feedbackForm: OPFeedbackForm
    fileprivate let uiDelegate: OPFeedbackFormVCProtocol?
    fileprivate var dataSource: [OPFeedbackFormVCCellViewModel]
    
    fileprivate var callbacks: OPFeedbackFormVCCallbacks?
    
    init(feedbackForm: OPFeedbackForm, uiDelegate: OPFeedbackFormVCProtocol?,feedbackCallback: OPFeedbackFormVCCallbacks) {
        self.feedbackForm = feedbackForm
        self.uiDelegate = uiDelegate
        self.dataSource = [OPFeedbackFormVCCellViewModel]()
        self.callbacks = feedbackCallback
        super.init()
    }
    
    fileprivate func buildDataSource(withAnswers:Bool = false) {
        for question in feedbackForm.questions {
            dataSource.append(OPFeedbackFormVCCellViewModel(type: .title, parentId: question.id, title: question.title, detail: question.description, option: -1, textContent: nil, required: question.required))
            
            var type: OPFeedbackFormVCCellType = .rating
            if question.type == OPFeedBackQuestionType.multipleRating.rawValue {
                type = .rating
            } else if question.type == OPFeedBackQuestionType.multipleSelection.rawValue {
                type = .radio
            } else if question.type == OPFeedBackQuestionType.textInput.rawValue {
                type = .textInput
            } else if question.type == OPFeedBackQuestionType.radio.rawValue {
                type = .radioWithExclusivity
            }
            
            if type == .textInput {
                
                let cellModel = OPFeedbackFormVCCellViewModel(type: type, parentId: question.id, title: "", detail: nil, option: -1, textContent: "", required: question.required)
                
                if withAnswers == true {
                    
                    if let questionAnswer =  feedbackForm.answers.first(where: { (localAnswer) -> Bool in
                        
                        if localAnswer.questionKey == question.title {
                            return true
                        }
                        return false
                    }) {
                        cellModel.textContent = questionAnswer.answer as? String
                    }
                }
                
                dataSource.append(cellModel)
            }
            else {
                for item in question.items ?? [] {
                    
                    let cellModel = OPFeedbackFormVCCellViewModel(type: type, parentId: question.id, title: item, detail: nil, option: -1, textContent: nil, required: question.required)
                    
                    if withAnswers == true {
                        
                        if let questionAnswer =  feedbackForm.answers.first(where: { (localAnswer) -> Bool in
                            
                            if localAnswer.itemName == item {
                                return true
                            }
                            return false
                        }) {
                            
                            if let optionString = questionAnswer.answer as? String{
                                
                                if let option = Int(optionString){
                                    cellModel.option = option-1
                                }
                                else if let option = Bool(optionString){
                                    cellModel.option = 1
                                }
                            }
                        }
                        else if let questionAnswer =  feedbackForm.answers.first(where: { (localAnswer) -> Bool in
                            
                            if localAnswer.questionKey == question.title{
                                return true
                            }
                            return false
                        }) {
                            
                            if let questionAnswerString = questionAnswer.answer as? String,
                                item == questionAnswerString {
                                cellModel.option = 1
                            }
                        }
                    }
                    
                    dataSource.append(cellModel)
                }
            }
        }
    }
}

extension OPFeedbackFormVCInteractor: OPFeedbackFormVCCellDelegate {
    
    func didSelectQuestion(withIndex index: Int, for viewModel: OPFeedbackFormVCCellViewModel?) {
        viewModel?.option = index
    }
    
    func didSelectQuestion(for viewModel: OPFeedbackFormVCCellViewModel?) {
    
        if viewModel?.option == 1 {
            viewModel?.option = -1
        }
        else {
             viewModel?.option = 1
        }
        if viewModel?.type == .radioWithExclusivity {
            for item in dataSource {
                if item.parentId == viewModel?.parentId && item.title != viewModel?.title {
                    item.option = -1
                }
            }
            uiDelegate?.refreshUI()
        }
    }
    
    func didEnterFeedback(for viewModel: OPFeedbackFormVCCellViewModel?, text: String) {
        viewModel?.textContent = text
    }
}

extension OPFeedbackFormVCInteractor: OPFeedbackFormVCInteractorProtocol {
    
    func viewDidLoad() {
        if self.feedbackForm.answers.count == 0 {
            self.showQuestionList()
        } else {
            self.uiDelegate?.showThankYouSubView()
        }
    }
    
    func numberOfRows() -> Int {
        return dataSource.count
    }
    
    func cell(forRowAt indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        return OPFeedbackFormVCCellBuilder.cell(inTableView: tableView, for: indexPath, withObject: dataSource[indexPath.row], delegate: self)
    }
    
    func height(forRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = dataSource[indexPath.row]
        
        switch viewModel.type {
        case .textInput:
            return 100.0
        case .radio, .radioWithExclusivity:
            return 50.0
        default:
            return 75.0
        }
    }
    
    func showQuestionList(withAnswers:Bool = false) {
        uiDelegate?.hideThankYouParrentView()
        uiDelegate?.showLoadingMessage(message: nil)
        feedbackForm.requestFeedbackForm { [weak self] (succes) in
            guard let strongSelf = self else { return }
            strongSelf.buildDataSource(withAnswers: true)
            strongSelf.uiDelegate?.refreshUI()
        }
    }
    
    func changeResponse() {
        showQuestionList(withAnswers: true)
    }
    
    func didSubmitForm() {
        uiDelegate?.showLoadingMessage(message: nil)
        var feedbackDictionary = Dictionary<String, String>()
        var answers = [OPFeedbackAnswer]()
        var feedbackComplete = true
        var radioWithExclusivityVerifiedQuestions = [Int]()
        
        for viewModel in dataSource {
            switch viewModel.type {
            case .rating, .radio:
                if viewModel.required && viewModel.option < 0 {
                    feedbackComplete = false
                    viewModel.shouldDisplayWarning = true
                } else {
                    let key = (feedbackForm.questionsTitlesById[viewModel.parentId] ?? "") + "[" + viewModel.title + "]"
                    let value = viewModel.type == .rating ? ("\(viewModel.option + 1)") : (viewModel.option >= 0 ? "true" : "")
                    feedbackDictionary[key] = value
                    viewModel.shouldDisplayWarning = false
                    answers.append(OPFeedbackAnswer(questionKey: key, itemName: viewModel.title, answer: value))
                }
            case .radioWithExclusivity:
                if radioWithExclusivityVerifiedQuestions.contains(viewModel.parentId) {
                    break
                } else {
                    radioWithExclusivityVerifiedQuestions.append(viewModel.parentId)
                    var checkedViewModels = [OPFeedbackFormVCCellViewModel]()
                    var validOptionFound = false
                    for model in dataSource {
                        if model.parentId == viewModel.parentId {
                            if model.option >= 0 {
                                let key = feedbackForm.questionsTitlesById[viewModel.parentId] ?? ""
                                feedbackDictionary[key] = model.title
                                validOptionFound = true
                                answers.append(OPFeedbackAnswer(questionKey: key, itemName: nil, answer: model.title))
                            }
                            checkedViewModels.append(model)
                        }
                    }
                    
                    for model in checkedViewModels {
                        model.shouldDisplayWarning = !validOptionFound
                    }
                    
                    feedbackComplete = validOptionFound ? feedbackComplete : false
                }
            case .textInput:
                if viewModel.required && (viewModel.textContent == nil || viewModel.textContent == "") {
                    feedbackComplete = false
                    viewModel.shouldDisplayWarning = true
                } else {
                    let key = feedbackForm.questionsTitlesById[viewModel.parentId] ?? ""
                    feedbackDictionary[key] = viewModel.textContent ?? ""
                    viewModel.shouldDisplayWarning = false
                    answers.append(OPFeedbackAnswer(questionKey: key, itemName: nil, answer: viewModel.textContent ?? ""))
                }
            case .title:
                break
            }
        }
        
        if feedbackComplete {
            feedbackForm.submitFeedbackForm(feedbackDictionary: feedbackDictionary, withAnswers: answers, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                strongSelf.uiDelegate?.refreshUI()
                if success {
                    strongSelf.uiDelegate?.showMessage(title: "Success", message: "Thank you for your feedback!")
                    self?.callbacks?.whenSubmitEndedWithSuccess?()
                } else {
                    strongSelf.uiDelegate?.showMessage(title: "Sorry", message: "Something wrong happened!")
                }
            })
        } else {
            uiDelegate?.refreshUI()
            uiDelegate?.showMessage(title: "Sorry", message: "Please complete all the required sections before submit.")
        }
    }
}
