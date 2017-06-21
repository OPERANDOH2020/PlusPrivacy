//
//  UIIdentityCell.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIdentityCell: UITableViewCell {

    @IBOutlet weak var identityLabel: UILabel!
    
    private var whenDeletingButtonPressed: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWithIdentity(identity: String?, whenDeletingButtonPressed: (() -> ())?)
    {
        self.whenDeletingButtonPressed = whenDeletingButtonPressed;
        self.identityLabel.text = identity;
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject)
    {
        self.whenDeletingButtonPressed?();
    }
    static let identifierNibName = "UIIdentityCell"
}
