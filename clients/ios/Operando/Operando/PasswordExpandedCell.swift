//
//  PasswordExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 12/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

protocol PasswordExpandedCellDelegate {
    func pressedUpdatePassword()
    func pressedCancel()
    func newPasswordTFWereEdited(newPassword:String?, confirmPassword: String?,cell:PasswordExpandedCell)
}

class PasswordExpandedCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifierNibName = "PasswordExpandedCell"

    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var currentPassTF: UITextField!
    
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    @IBOutlet weak var level4: UIView!
    
    var passwordStrenghtLevel = 0
    
    var levels: [UIView] = []
    
    var delegate: PasswordExpandedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirmPassTF.delegate = self
        newPassTF.delegate = self
        currentPassTF.delegate = self
        levels.append(level1)
        levels.append(level2)
        levels.append(level3)
        levels.append(level4)
        resetLevels()
    }
    
    func resetLevels(passwordStrenght: Int = 0) {
        self.passwordStrenghtLevel = passwordStrenght
        for lvl in self.levels {
            
            if let index = self.levels.index(of: lvl),
                index <= passwordStrenghtLevel-1 {
                
                lvl.backgroundColor = UIColor.levelColor(lvl: LevelColor(rawValue: passwordStrenght)!)
            }
            else {
                lvl.backgroundColor = UIColor.levelColor(lvl: LevelColor.noLevel)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == newPassTF {
            let string = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            delegate?.newPasswordTFWereEdited(newPassword: string, confirmPassword: self.confirmPassTF.text, cell: self)
        }
        else if textField == confirmPassTF {
            let string = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            delegate?.newPasswordTFWereEdited(newPassword: self.newPassTF.text, confirmPassword: string, cell: self)
        }
        
        return true
    }
    @IBAction func pressedUpdatePasswordButton(_ sender: Any) {
        delegate?.pressedUpdatePassword()
    }
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        delegate?.pressedCancel()
    }
}
