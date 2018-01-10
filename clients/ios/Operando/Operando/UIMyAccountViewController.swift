//
//  UIMyAccountViewController.swift
//  Operando
//
//  Created by RomSoft on 12/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct UIMyAccountViewControllerOutlets {
    let tableView: UITableView?
    
    static let allNil: UIMyAccountViewControllerOutlets = UIMyAccountViewControllerOutlets(tableView: nil)
}

struct UIMyAccountViewControllerLogicCallbacks {
    
    let userUpdatedPassword:VoidBlock?
    let userDeletedAccount:VoidBlock?
}

class UIMyAccountViewControllerLogic: NSObject, UITableViewDelegate, UITableViewDataSource,PasswordCellDelegate,PasswordExpandedCellDelegate,AccountDeletionCellDelegate {
    
    var infoRepository: UsersRepository?
    
    let outlets: UIMyAccountViewControllerOutlets
    var logicCallbacks: UIMyAccountViewControllerLogicCallbacks?
    private var changePassword = false
    
    init(outlets: UIMyAccountViewControllerOutlets, logicCallbacks: UIMyAccountViewControllerLogicCallbacks?) {
        self.outlets = outlets;
        self.logicCallbacks = logicCallbacks
        super.init()
        self.setupTableView()
    }
    
    func setupTableView(){
        //register cells
        self.outlets.tableView?.delegate = self
        self.outlets.tableView?.dataSource = self
        
        let nib = UINib(nibName: PasswordCell.identifierNibName, bundle: nil)
        self.outlets.tableView?.register(nib, forCellReuseIdentifier: PasswordCell.identifierNibName)
        
        let accountDeletionNib = UINib(nibName: AccountDeletionCell.identifierNibName, bundle: nil)
        self.outlets.tableView?.register(accountDeletionNib, forCellReuseIdentifier: AccountDeletionCell.identifierNibName)
        
        let passwordExpanedNib = UINib(nibName: PasswordExpandedCell.identifierNibName, bundle: nil)
        self.outlets.tableView?.register(passwordExpanedNib, forCellReuseIdentifier: PasswordExpandedCell.identifierNibName)
        
        //        self.outlets.tableView?.estimatedRowHeight = 70
        //        self.outlets.tableView?.rowHeight = UITableViewAutomaticDimension
    }
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if changePassword == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: PasswordExpandedCell.identifierNibName) as! PasswordExpandedCell
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PasswordCell.identifierNibName) as! PasswordCell
                cell.delegate = self
                return cell
            }
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountDeletionCell.identifierNibName) as! AccountDeletionCell
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if changePassword == true {
                return 429
            }
            else {
                
                return 118
            }
            
        }
        
        return 230
        
    }
    
    // MARK: -  AccountDeletionCellDelegate
    
    func pressedDeleteAccountButton() {
        
        OPViewUtils.displayAlertWithMessage(message: "Are you sure you want to delete your account?", withTitle: "My Account", addCancelAction: true) {
            
            self.logicCallbacks?.userDeletedAccount?()
            
            self.infoRepository?.deleteAccount(withCompletion: { (error) in
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                }
                else {
                    CredentialsStore.deleteCredentials()
                }
            })
        }
    }
    
    // MARK: - ExpandedPasswordCellDelegate
    
    func pressedUpdatePassword(cell:PasswordExpandedCell) {
        
        if let (_,password) = CredentialsStore.retrieveLastSavedCredentialsIfAny() {
            
            if password == cell.currentPassTF.text {
                
                if cell.passwordStrenghtLevel > 1 && cell.newPassTF.text == cell.confirmPassTF.text {
                    
                    infoRepository?.changeCurrent(password: cell.currentPassTF.text!, to: cell.newPassTF.text!, withCompletion: { (error) in
                        
                        if let error = error {
                            OPErrorContainer.displayError(error: error)
                        }
                        else {
                            if let error = CredentialsStore.updatePassword(to: cell.newPassTF.text!) {
                                OPErrorContainer.displayError(error: error)
                            }
                            self.logicCallbacks?.userUpdatedPassword?()
                        }
                        
                    })
                    
                }
                
                cell.setMatchTypeImgView(withType: .match, imageView: cell.currentPassImageView)
                
            }
            else {
                cell.setMatchTypeImgView(withType: .doesntMatch, imageView: cell.currentPassImageView)
            }
        }
    }
    
    func pressedCancel() {
        self.changePassword = false
        self.outlets.tableView?.reloadData()
    }
    
    func newPasswordTFWereEdited(newPassword: String?, confirmPassword: String?, cell: PasswordExpandedCell) {
        
        var passwordStrenght = 0
        
        if newPassword != nil{
            
            if (newPassword?.count.toIntMax())! >= 6 {
                //                (numberOfStrenghtTypesIn(password: newPassword!) >= 1 && (newPassword?.count.toIntMax())! >= 8 ){
                
                passwordStrenght += 1
            }
            
            if passwordStrenght == 1 {
                
                passwordStrenght = numberOfStrenghtTypesIn(password: newPassword!)
                
                var multiples = (newPassword?.count)!/6 - 1
                
                if multiples == -1 {
                    multiples = 0
                }
                
                passwordStrenght = passwordStrenght + multiples
            }
            
            if passwordStrenght > 4 {
                passwordStrenght = 4
            }
        }
        
        if passwordStrenght == 0 {
            cell.setMatchTypeImgView(withType: .none, imageView: cell.newPassImageView)
            cell.setMatchLabelWithType(matchType: .none)
            cell.setMatchTypeImgView(withType: .none, imageView: cell.confirmPassImageView)
        }
        else if passwordStrenght == 1{
            cell.setMatchTypeImgView(withType: .doesntMatch, imageView: cell.newPassImageView)
        }
        else {
            
            if newPassword == confirmPassword {
                cell.setMatchTypeImgView(withType: .match, imageView: cell.confirmPassImageView)
            }
            cell.setMatchTypeImgView(withType: .match, imageView: cell.newPassImageView)
        }
        
        cell.resetLevels(passwordStrenght: passwordStrenght)
    }
    
    // MARK: - Utilities
    
    private func numberOfStrenghtTypesIn(password: String) -> Int {
        
        var strenght = 0
        
        let sets = [CharacterSet.decimalDigits, CharacterSet.lowercaseLetters, CharacterSet.uppercaseLetters,CharacterSet.alphanumerics.inverted]
        
        for set in sets {
            
            if password.rangeOfCharacter(from: set) != nil {
                strenght = strenght+1
            }
        }
        
        return strenght
    }
    
    // MARK: - PasswordCellDelegate
    
    func pressedChangeButton() {
        
        self.changePassword = true
        let indexPath = IndexPath(row: 0, section: 0)
        self.outlets.tableView?.reloadData()
    }
}

class UIMyAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var callbacks: UIMyAccountViewControllerLogicCallbacks?
    var infoRepo: UsersRepository?
    
    private(set) lazy var logic: UIMyAccountViewControllerLogic = {
        
        let outlets: UIMyAccountViewControllerOutlets = UIMyAccountViewControllerOutlets(tableView: self.tableView)
        let callBacks: UIMyAccountViewControllerLogicCallbacks = UIMyAccountViewControllerLogicCallbacks(userUpdatedPassword: {
            
        }, userDeletedAccount: {
            
        })
        
        return UIMyAccountViewControllerLogic(outlets: outlets, logicCallbacks: callBacks)
        
    }()
    
    func setup(with infoRepository: UsersRepository?, callbacks: UIMyAccountViewControllerLogicCallbacks){
        self.infoRepo = infoRepository
        self.callbacks = callbacks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logic.infoRepository = self.infoRepo
        logic.logicCallbacks = self.callbacks
        logic.setupTableView()
    }
    
}
