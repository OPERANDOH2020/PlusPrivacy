//
//  OPFeedbackFormTableViewCell.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class OPFeedbackFormTableViewCell: UITableViewCell, OPFeedbackFormVCCell {
    
    var delegate: OPFeedbackFormVCCellDelegate?
    var viewModel: OPFeedbackFormVCCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    class func reuseId() -> String {
        return "ReusableIdentifier"
    }

}
