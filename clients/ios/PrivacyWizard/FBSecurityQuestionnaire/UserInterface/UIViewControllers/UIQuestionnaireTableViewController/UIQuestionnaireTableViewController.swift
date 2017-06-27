//
//  UIQuestionnaireTableViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 04/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit
import QuartzCore

let UIQuestionnaireTVCStoryboardId = "UIQuestionnaireTVCStoryboardId"

struct UIQuestionnaireTVCObject {
    var status: String
    var actionName: String
    var privacySettings: [AMPrivacySetting]
}

protocol UIQuestionnaireTVCProtocol {
    func requestNewPrivacySettings(completionHandler: @escaping (_ privacySettings: UIQuestionnaireTVCObject?) -> Void)
    func viewDidUnload()
}

class UIQuestionnaireTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    private var privacySettings: [AMPrivacySetting] = []
    var delegate: UIQuestionnaireTVCProtocol?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var footerButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionnaireTableView: UIRadialGradientTableView!
    
    // MARK: - Actions
    func didTapBackButtonItem() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapFooterButton(_ sender: Any) {
        requestPrivacySettings()
    }
    
    // MARK: - Private Methods
    private func requestPrivacySettings() {
        if validOptions() {
            ProgressHUD.show("Loading")
            delegate?.requestNewPrivacySettings(completionHandler: { [weak self] (dataSourceObject) in
                ProgressHUD.dismiss()
                guard let strongSelf = self, let dataSourceObject = dataSourceObject else { return }
                strongSelf.privacySettings = dataSourceObject.privacySettings
                strongSelf.statusLabel.text = dataSourceObject.status
                strongSelf.footerButton.setTitle(dataSourceObject.actionName, for: .normal)
                strongSelf.questionnaireTableView.reloadData()
            })
        } else {
            UIAlertViewController.presentOkAlert(from: self, title: "Information", message: "One or more settings are missing")
        }
    }
    
    private func validOptions() -> Bool {
        for privacySetting in privacySettings {
            if privacySetting.selectedOption == nil {
                return false
            }
        }
        
        return true
    }
    
    private func getCurrentSetting(index: Int) -> AMPrivacySetting? {
        let currentSetting = privacySettings[index]
        return currentSetting
    }
    
    private func getCurrentSettingOption(settingIndex: Int, optionIndex: Int) -> AMAvailableReadSetting? {
        guard let currentSetting = getCurrentSetting(index: settingIndex),
            let read = currentSetting.read,
            let options = read.availableSettings,
            options.count > optionIndex else { return nil }
        
        return options[optionIndex]
    }
    
    private func getHeaderTitle(forSection section: Int) -> String {
        guard let currentSetting = getCurrentSetting(index: section),
            let read = currentSetting.read else { return "" }
        
        return read.name ?? ""
    }
    
    private func getHeaderImageName(forSection section: Int) -> String {
        guard let currentSetting = getCurrentSetting(index: section) else { return "" }
        
        switch currentSetting.type {
        case .facebook:
            return "facebook_icon_"
        case .linkedin:
            return "linkedin_icon_"
        case .unknown:
            return ""
        }
    }
    
    private func setupControls() {
        navigationItem.addCustomBackButton(target: self, selector: #selector(UIQuestionnaireTableViewController.didTapBackButtonItem))
        navigationItem.title = "Privacy Wizard"
        questionnaireTableView.delegate = self
        questionnaireTableView.dataSource = self
        questionnaireTableView.register(UICustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: UICustomTableViewHeaderReuseIdentifier)
        self.view.backgroundColor = .appYellow
        questionnaireTableView.backgroundColor = .appDarkBlue
        statusLabel.backgroundColor = .appDarkBlue
        footerButton.backgroundColor = .appDarkBlue
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        requestPrivacySettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        questionnaireTableView.setup(colors: [UIColor.appBlue.cgColor, UIColor.appMidBlue.cgColor, UIColor.appDarkBlue.cgColor, UIColor.appTransparentDarkBlue.cgColor], center: CGPoint(x: 0.0, y: UIScreen.main.bounds.height / 3), endRadius: 3/2 * questionnaireTableView.bounds.width)
        questionnaireTableView.setNeedsDisplay()
    }
    
    deinit {
        delegate?.viewDidUnload()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return privacySettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentSetting = getCurrentSetting(index: section) else { return 0 }
        return currentSetting.availableOptionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIQuestionnaireTableViewCellIdentifier, for: indexPath) as! UIQuestionnaireTableViewCell
        
        if let currentOption = getCurrentSettingOption(settingIndex: indexPath.section, optionIndex: indexPath.row) {
            cell.setup(withModel: currentOption, selectionCallback: { [weak self] (cell) in
                if let strongSelf = self {
                    strongSelf.didSelectOption(fromCell: cell)
                }
            })
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let title = getHeaderTitle(forSection: section)
        let titleHeight = UILabel.heightForView(text: title, width: UIScreen.main.bounds.width - 2 * 15)
        let result = titleHeight + 20.0 < 55.0 ? 57.0 : titleHeight + 22
        return result
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.questionnaireTableView.dequeueReusableHeaderFooterView(withIdentifier: UICustomTableViewHeaderReuseIdentifier) as! UICustomTableViewHeader
        headerView.setup(withTitle: getHeaderTitle(forSection: section), imageNamed: getHeaderImageName(forSection: section))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let currentSetting = getCurrentSetting(index: indexPath.section) else { return }
        
        if currentSetting.selectOption(atIndex: indexPath.row) {
            questionnaireTableView.reloadData()
        }
    }
    
    // MARK: - Cell Callbacks
    private func didSelectOption(fromCell cell: UITableViewCell) {
        guard let indexPath = questionnaireTableView.indexPath(for: cell),
            let currentSetting = getCurrentSetting(index: indexPath.section) else { return }
        
        if currentSetting.selectOption(atIndex: indexPath.row) {
            questionnaireTableView.reloadData()
        }
    }
}
