//
//  PrivacyWizardFacebookExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 2/9/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

protocol PrivacyWizardFacebookExpandedCellDelegate {
    func privacyWizardFacebookExpandedSelectedOption(selectedOptionIndex: Int)
}


class PrivacyWizardFacebookExpandedCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, PrivacyWizardFacebookOptionCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingLabel: UILabel!
    
    var delegate: PrivacyWizardFacebookExpandedCellDelegate?
    
    private var setting: AMPrivacySetting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        settingLabel.text = ""
        self.setting = nil
    }
    
    func setupWithSetting(setting: AMPrivacySetting){
        self.settingLabel.text = setting.read?.name
        self.setting = setting
        setupTableView()
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrivacyWizardFacebookOptionCell", bundle: nil), forCellReuseIdentifier: "PrivacyWizardFacebookOptionCell")
    }
    
    // MARK: - PrivacyWizardFacebookOptionCellDelegate
    
    func selectedOption(setting: AMAvailableReadSetting) {
        
        if let index = setting.index{
            
            delegate?.privacyWizardFacebookExpandedSelectedOption(selectedOptionIndex: index)
        }
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.setting?.availableOptionsCount {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyWizardFacebookOptionCell", for: indexPath) as! PrivacyWizardFacebookOptionCell
        cell.selectionStyle = .none
        
        if let optionSetting = setting?.read?.availableSettings?[indexPath.row] {
            
            cell.setupWithSetting(setting: optionSetting,recommended: setting?.write?.recommended)
            
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
}
