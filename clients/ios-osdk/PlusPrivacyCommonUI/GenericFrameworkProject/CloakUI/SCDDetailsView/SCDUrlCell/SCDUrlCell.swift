//
//  SCDUrlCell.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class SCDUrlCell: UITableViewCell {

    static let identifierNibName = "SCDUrlCell"
    @IBOutlet weak var urlLabel: UILabel!
    
    func setupWith(url: String){
        self.urlLabel.text = url
    }
}
