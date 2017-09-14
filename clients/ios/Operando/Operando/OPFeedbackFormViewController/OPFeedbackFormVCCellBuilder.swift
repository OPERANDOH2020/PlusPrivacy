//
//  OPFeedbackFormVCCellBuilder.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

enum OPFeedbackFormVCCellType {
    case title
    case radio
    case radioWithExclusivity
    case textInput
    case rating
}

class OPFeedbackFormVCCellViewModel {
    let type: OPFeedbackFormVCCellType
    let parentId: Int
    var title: String
    var detail: String?
    var option: Int
    var textContent: String?
    var required: Bool
    var shouldDisplayWarning: Bool = false
    
    init(type: OPFeedbackFormVCCellType, parentId: Int, title: String, detail: String?, option: Int, textContent: String?, required: Bool) {
        self.type = type
        self.parentId = parentId
        self.title = title
        self.detail = detail
        self.option = option
        self.textContent = textContent
        self.required = required
    }
}

protocol OPFeedbackFormVCCell {
    func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate)
    static func reuseId() -> String
}

protocol OPFeedbackFormVCCellDelegate {
    func didSelectQuestion(withIndex index: Int, for viewModel: OPFeedbackFormVCCellViewModel?)
    func didSelectQuestion(for viewModel: OPFeedbackFormVCCellViewModel?)
    func didEnterFeedback(for viewModel: OPFeedbackFormVCCellViewModel?, text: String)
}

class OPFeedbackFormVCCellBuilder: NSObject {

    static func cell(inTableView tableView: UITableView, for indexPath: IndexPath, withObject viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch viewModel.type {
        case .title:
            cell = tableView.dequeueReusableCell(withIdentifier: OPFeedbackFormTVTitleCell.reuseId(), for: indexPath)
        case .radio, .radioWithExclusivity:
            cell = tableView.dequeueReusableCell(withIdentifier: OPFeedbackFormTVRadioCell.reuseId(), for: indexPath)
        case .textInput:
            cell = tableView.dequeueReusableCell(withIdentifier: OPFeedbackFormTVTextInputCell.reuseId(), for: indexPath)
        case .rating:
            cell = tableView.dequeueReusableCell(withIdentifier: OPFeedbackFormTVCheckCell.reuseId(), for: indexPath)
        }
        
        if let cell = cell as? OPFeedbackFormVCCell {
            cell.setup(with: viewModel, delegate: delegate)
        }
        
        return cell ?? UITableViewCell()
    }
}
