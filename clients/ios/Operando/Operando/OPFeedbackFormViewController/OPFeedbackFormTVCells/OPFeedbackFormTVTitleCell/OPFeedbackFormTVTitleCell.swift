//
//  OPFeedbackFormTVTitleCell.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/11/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class OPFeedbackFormTVTitleCell: OPFeedbackFormTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setup(with viewModel: OPFeedbackFormVCCellViewModel, delegate: OPFeedbackFormVCCellDelegate) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
    }
    
    override class func reuseId() -> String {
        return "OPFeedbackFormTVTitleCellReusableIdentifier"
    }
}
