//
//  UICertifiedApplicationCell.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct CertifiedAppModel
{
    let appName: String
    let appVersion: String
}

class UICertifiedApplicationCell: UITableViewCell
{
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWithModel(model: CertifiedAppModel?)
    {
        self.appNameLabel.text = model?.appName;
        self.appVersionLabel.text = model?.appVersion
    }
    
    
    static let identifierNibName = "UICertifiedApplicationCell"
}
