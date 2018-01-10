//
//  AccountDeletionCell.swift
//  Operando
//
//  Created by RomSoft on 12/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
protocol AccountDeletionCellDelegate {
    func pressedDeleteAccountButton()
}

class AccountDeletionCell: UITableViewCell {

    static let identifierNibName = "AccountDeletionCell"
    var delegate:AccountDeletionCellDelegate?
    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pressedDeleteAccountButton(_ sender: Any) {
        delegate?.pressedDeleteAccountButton()
    }
    
}
