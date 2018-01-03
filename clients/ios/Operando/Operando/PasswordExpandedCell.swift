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

enum MatchType: String{
    
    case none = "none"
    case match = "Match"
    case doesntMatch = "Doesn't match"
}

enum PasswordStrenghtType: Int {
    case none
    case weak
    case acceptable
    case strong
    case veryStrong
    
    static func getTypeString(passwordStrenghtLevel: PasswordStrenghtType) -> String {
        
        switch passwordStrenghtLevel {
        case .none:
            return ""
        case .acceptable:
            return "Acceptable"
        case .strong:
            return "Strong"
        case .veryStrong:
            return "Very Strong"
        case .weak:
            return "Weak"
        }
    }
}

class PasswordExpandedCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifierNibName = "PasswordExpandedCell"
    
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var currentPassTF: UITextField!
    
    @IBOutlet var matchLabel: UILabel!
    @IBOutlet weak var level1: UIView!
    @IBOutlet weak var level2: UIView!
    @IBOutlet weak var level3: UIView!
    @IBOutlet weak var level4: UIView!
    
    @IBOutlet var passwordStrenghtLabel: UILabel!
    
    @IBOutlet var confirmPassImageView: UIImageView!
    @IBOutlet var currentPassImageView: UIImageView!
    @IBOutlet var newPassImageView: UIImageView!
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
    
    private func setupPasswordStrenghtLabel () {
        
        self.passwordStrenghtLabel.text = PasswordStrenghtType.getTypeString(passwordStrenghtLevel: PasswordStrenghtType(rawValue: self.passwordStrenghtLevel)!)
    }
    
    func setMatchLabelWithType(matchType: MatchType){
        
        self.matchLabel.text = matchType.rawValue
    }
    
    func setMatchTypeImgView(withType type: MatchType, imageView: UIImageView) {
        
        if type == .match {
            imageView.image = #imageLiteral(resourceName: "ic_succes")
        }
        else if type == .doesntMatch{
            imageView.image = #imageLiteral(resourceName: "ic_error")
        }
        else {
            imageView.image = nil
        }
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
        
        self.setupPasswordStrenghtLabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == newPassTF {
            let string = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            delegate?.newPasswordTFWereEdited(newPassword: string, confirmPassword: self.confirmPassTF.text, cell: self)
            
            if self.confirmPassTF.text == string {
                setMatchTypeImgView(withType: .match, imageView: confirmPassImageView)
            }
            else {
                
                if self.confirmPassTF.text == nil ||
                    self.confirmPassTF.text == ""
                {
                    setMatchTypeImgView(withType: .none, imageView: confirmPassImageView)
                }
                else {
                    setMatchTypeImgView(withType: .doesntMatch, imageView: confirmPassImageView)
                }
            }
        }
        else if textField == confirmPassTF {
            let string = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            if self.newPassTF.text == string {
                setMatchTypeImgView(withType: .match, imageView: confirmPassImageView)
            }
            else {
                setMatchTypeImgView(withType: .doesntMatch, imageView: confirmPassImageView)
            }
            
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
