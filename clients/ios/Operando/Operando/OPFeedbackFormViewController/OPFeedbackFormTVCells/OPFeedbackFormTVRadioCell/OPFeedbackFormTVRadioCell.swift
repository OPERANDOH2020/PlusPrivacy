//
//  OPFeedbackFormTVRadioCell.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class OPFeedbackFormTVRadioCell: OPFeedbackFormTableViewCell {

    private var isSelectedOption = false
    
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftWarningView: UIView!
    @IBOutlet weak var rightWarningView: UIView!
    
    @IBAction func didTapRadioButton(_ sender: Any) {
        isSelectedOption = !isSelectedOption
        selectOption(isSelected: isSelectedOption)
        delegate?.didSelectQuestion(for: viewModel)
    }
    
    private func selectOption(isSelected: Bool) {
        let image = isSelectedOption ? UIImage.optionSelectedImage?.withRenderingMode(.alwaysTemplate) : UIImage.optionUnselectedImage?.withRenderingMode(.alwaysTemplate)
        radioButton.setImage(image, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftWarningView.isHidden = true
        rightWarningView.isHidden = true
        leftWarningView.backgroundColor = UIColor.operandoRed
        rightWarningView.backgroundColor = UIColor.operandoRed
    }
    
    override func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) {
        super.setup(with: viewModel, delegate: delegate)
        titleLabel.text = viewModel.title
        isSelectedOption = viewModel.option >= 0
        selectOption(isSelected: isSelectedOption)
        radioButton.tintColor = .black
        leftWarningView.isHidden = !viewModel.shouldDisplayWarning
        rightWarningView.isHidden = !viewModel.shouldDisplayWarning
    }
    
    override class func reuseId() -> String {
        return "OPFeedbackFormTVRadioCellReusableIdentifier"
    }
}
