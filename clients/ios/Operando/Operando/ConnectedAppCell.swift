//
//  ConnectedAppCell.swift
//  Operando
//
//  Created by RomSoft on 4/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum ConnectedAppCellStyle {
    case permission
    case app
}

class ConnectedAppCell: UITableViewCell {

    static let identifier = "ConnectedAppCell"
    
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var permissionDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupColorView()
        self.selectionStyle = .none
    }
    
    func setupLayout(style: ConnectedAppCellStyle) {
        
        switch style {
        case .app:
            permissionDescriptionLabel.isHidden = true
            appDescriptionLabel.isHidden = false
            appTitleLabel.isHidden = false
            appImageView.isHidden = false
        case .permission:
            permissionDescriptionLabel.isHidden = false
            appDescriptionLabel.isHidden = true
            appTitleLabel.isHidden = true
            appImageView.isHidden = true
        }
    }
    
    private func setupColorView(){
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
