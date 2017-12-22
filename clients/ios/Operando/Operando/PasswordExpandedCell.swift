//
//  PasswordExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 12/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class PasswordExpandedCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifierNibName = "PasswordExpandedCell"

    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var currentPassTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirmPassTF.delegate = self
        newPassTF.delegate = self
        currentPassTF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        textField.text stringByReplacingCharactersInRange:range withString:string
        
        let string = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        
        return true
    }
    
}
