//
//  OPFeedbackFormTVTextInputCell.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class OPFeedbackFormTVTextInputCell: OPFeedbackFormTableViewCell {

    var willBeginEditingCallback: ((_ textView: UITextView) -> Void)?
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.delegate = self
        setPlaceholder()
    }

    override func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) {
        super.setup(with: viewModel, delegate: delegate)
        if viewModel.textContent != nil && viewModel.textContent != "" {
            contentTextView.text = viewModel.textContent
        } else {
            setPlaceholder()
        }
    }
    
    override class func reuseId() -> String {
        return "OPFeedbackFormTVTextInputCellReusableIdentifier"
    }
    
    fileprivate func setPlaceholder() {
        contentTextView.text = "Your feedback ..."
        contentTextView.textColor = .lightGray
    }
}

extension OPFeedbackFormTVTextInputCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        willBeginEditingCallback?(textView)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholder()
        }
        delegate?.didEnterFeedback(for: viewModel, text: textView.text)
    }
}
