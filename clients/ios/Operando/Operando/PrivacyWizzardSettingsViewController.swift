//
//  PrivacyWizzardFacebookSettingsViewController.swift
//  Operando
//
//  Created by RomSoft on 2/5/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum PrivacyWizzardType {
    case facebook
    case linkedin
    case twitter
}

struct PrivacyWizzardSettingsCallbacks {
    let pressedSubmit:((_ facebookSettings: [AMPrivacySetting]) -> ())
    let pressedRecommended:(() -> ())
}

class PrivacyWizzardSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PrivacyWizardFacebookExpandedCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var repository: PrivacyWizardRepository?
    @objc private var allSettings: AMPrivacySettings?
    
    var
    callbacks:PrivacyWizzardSettingsCallbacks?
    
    private var selectedIndexPath: IndexPath?
    private var currentSelectedSetting: AMPrivacySetting?
    
    var wizzardType: PrivacyWizzardType = .facebook
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupTableView()
        
        repository?.getAllQuestions(withCompletion: { (settings,error) in
            
            if let error = error {
                
                OPErrorContainer.displayError(error: error)
            }
            else {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    ACPrivacyWizard.shared.privacySettings = settings
                    
                    self.allSettings = settings
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        ACPrivacyWizard.shared.privacySettings = self.allSettings
        
        switch self.wizzardType {
        case .facebook:
            ACPrivacyWizard.shared.selectedScope = .facebook
            break
        case .linkedin:
            ACPrivacyWizard.shared.selectedScope = .linkedIn
            break
        case .twitter:
            ACPrivacyWizard.shared.selectedScope = .twitter
        }
    }
    
    func setup(with privacyWizardRepository:PrivacyWizardRepository, callbacks: PrivacyWizzardSettingsCallbacks){
        self.repository = privacyWizardRepository
        self.callbacks = callbacks
    }
    
    private func setupTableView() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.register(UINib(nibName: "PrivacyWizardFacebookCell", bundle: nil), forCellReuseIdentifier: "PrivacyWizardFacebookCell")
        tableView.register(UINib(nibName: "PrivacyWizardFacebookExpandedCell", bundle: nil), forCellReuseIdentifier: "PrivacyWizardFacebookExpandedCell")
        
    }
    
    // MARK: - Actions
    
    @IBAction func pressedRecommendedButton(_ sender: Any) {
        self.callbacks?.pressedRecommended()
        
        let scopeSetting = getSettings()
        
        if let facebookSettings = scopeSetting {
            for facebookSetting in facebookSettings {
                
                guard let recommendedString = facebookSetting.write?.recommended else {
                    continue
                }
                
                guard let availableSettings = facebookSetting.read?.availableSettings else {
                    continue
                }
                
                for availableSetting in availableSettings {
                    if availableSetting.name == recommendedString.replace(target: "_", withString: " ").capitalized {
                        
                        if let index = availableSetting.index {
                            
                            facebookSetting.selectOption(withIndex: index)
                        }
                    }
                }
            }
        }  
    }
    
    func isSelectedSettingRecommended(setting: AMPrivacySetting) -> Bool {
            
            guard let recommendedString = setting.write?.recommended else {
                return false
            }
            
            guard let availableSettings = setting.read?.availableSettings else {
                return false
            }
            
            for availableSetting in availableSettings {
                if availableSetting.name == recommendedString.replace(target: "_", withString: " ").capitalized &&
                     availableSetting.isSelected == true {
                    
                    return true
                }
            }
        
        return false
        
    }
    
    @IBAction func pressedSubmitButton(_ sender: Any) {
        
        let scopeSetting: [AMPrivacySetting]?
        
        switch self.wizzardType {
        case .facebook:
            scopeSetting = allSettings?.facebookSettings
            break
        case .linkedin:
            scopeSetting = allSettings?.linkedinSettings
            break
        case .twitter:
            scopeSetting = allSettings?.twitterSettings
            break
        }
        
        guard let scopeSettingUnwrapped = scopeSetting else {
            return
        }
        
        self.callbacks?.pressedSubmit(scopeSettingUnwrapped)
    }
    
    
    // MARK: - PrivacyWizardFacebookExpandedCellDelegate
    
    func privacyWizardFacebookExpandedSelectedOption(selectedOptionIndex: Int) {
        
        self.currentSelectedSetting?.selectOption(withIndex: selectedOptionIndex)
        self.tableView.reloadData()
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scopeSetting = getSettings()
        
        
        if let count = scopeSetting?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scopeSetting = getSettings()
        
        if indexPath == selectedIndexPath {
            //rotate arrow
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyWizardFacebookExpandedCell", for: indexPath) as! PrivacyWizardFacebookExpandedCell
            
            if let setting = scopeSetting?[indexPath.row] {
                cell.setupWithSetting(setting: setting,isRecommendedSelected: isSelectedSettingRecommended(setting: setting))
                cell.delegate = self
                
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyWizardFacebookCell", for: indexPath) as! PrivacyWizardFacebookCell
            
            if let setting = scopeSetting?[indexPath.row]{
                cell.setupWithSetting(setting: setting,isRecommendedSelected: isSelectedSettingRecommended(setting: setting))
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    private func getSettings() -> [AMPrivacySetting]? {
        switch self.wizzardType {
        case .twitter:
            return allSettings?.twitterSettings
        case .facebook:
            return allSettings?.facebookSettings
        case .linkedin:
            return allSettings?.linkedinSettings
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let scopeSetting = getSettings()
        
        if let selectedIndexPath = self.selectedIndexPath ,
            selectedIndexPath == indexPath,
            let count = scopeSetting?[selectedIndexPath.row].availableOptionsCount{
            
            return 90 + CGFloat(count) * 44
        }
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let scopeSetting = getSettings()
        
        if selectedIndexPath == indexPath {
            selectedIndexPath = nil
        }
        else {
            self.selectedIndexPath = indexPath
            self.currentSelectedSetting = scopeSetting?[indexPath.row]
        }
        
        self.tableView.reloadData()
    }
}
