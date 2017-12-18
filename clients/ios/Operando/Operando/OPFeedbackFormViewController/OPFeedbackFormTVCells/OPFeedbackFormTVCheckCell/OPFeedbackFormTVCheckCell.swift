//
//  OPFeedbackFormTVCheckCell.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class OPFeedbackFormTVCheckCell: OPFeedbackFormTableViewCell {

    private var ratingButtons = [UIButton]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var oneRatingButton: UIButton!
    @IBOutlet weak var twoRatingButton: UIButton!
    @IBOutlet weak var threeRatingButton: UIButton!
    @IBOutlet weak var fourRatingButton: UIButton!
    @IBOutlet weak var fiveRatingButton: UIButton!
    @IBOutlet weak var leftWarningView: UIView!
    @IBOutlet weak var rightWarningView: UIView!
    
    @IBAction func didTapRatingButton(_ sender: Any) {
        guard let sender = sender as? UIButton else { return }
        var index = 0
        for button in ratingButtons {
            if button == sender {
                setupRating(withSelectedValue: index)
                delegate?.didSelectQuestion(withIndex: index, for: viewModel)
                return
            }
            index += 1
        }
    }
    
    private func setupRating(withSelectedValue value: Int) {
        var index = 0
        for button in ratingButtons {
            button.backgroundColor = value == index ? .operandoDarkBrown : .operandoLightBrown
            index += 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingButtons.append(oneRatingButton)
        ratingButtons.append(twoRatingButton)
        ratingButtons.append(threeRatingButton)
        ratingButtons.append(fourRatingButton)
        ratingButtons.append(fiveRatingButton)
        leftWarningView.isHidden = true
        rightWarningView.isHidden = true
        leftWarningView.backgroundColor = UIColor.operandoRed
        rightWarningView.backgroundColor = UIColor.operandoRed
    }
    
    override func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) {
        super.setup(with: viewModel, delegate: delegate)
        
        titleLabel.text = viewModel.title
        setupRating(withSelectedValue: viewModel.option)
        
        leftWarningView.isHidden = !viewModel.shouldDisplayWarning
        rightWarningView.isHidden = !viewModel.shouldDisplayWarning
    }
    
    override class func reuseId() -> String {
        return "OPFeedbackFormTVCheckCellReusableIdentifier"
    }
}
