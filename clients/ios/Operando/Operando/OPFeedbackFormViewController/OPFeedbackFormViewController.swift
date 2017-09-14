//
//  OPFeedbackFormViewController.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 9/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

protocol OPFeedbackFormVCProtocol {
    func refreshUI()
    func showMessage(title: String, message: String)
    func showLoadingMessage(message: String?)
}

class OPFeedbackFormViewController: UIViewController {
    
    fileprivate var interactor: OPFeedbackFormVCInteractorProtocol?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        interactor?.didSubmitForm()
    }
    
    
    func dismissKeyboard() {
        tableView.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        interactor?.viewDidLoad()
    }
    
    private func setupControls() {
        tableView.register(UINib(nibName: "OPFeedbackFormTVTitleCell", bundle: nil), forCellReuseIdentifier: OPFeedbackFormTVTitleCell.reuseId())
        tableView.register(UINib(nibName: "OPFeedbackFormTVTextInputCell", bundle: nil), forCellReuseIdentifier: OPFeedbackFormTVTextInputCell.reuseId())
        tableView.register(UINib(nibName: "OPFeedbackFormTVRadioCell", bundle: nil), forCellReuseIdentifier: OPFeedbackFormTVRadioCell.reuseId())
        tableView.register(UINib(nibName: "OPFeedbackFormTVCheckCell", bundle: nil), forCellReuseIdentifier: OPFeedbackFormTVCheckCell.reuseId())
        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = .operandoBrownieYellow
        
        submitButton.backgroundColor = .operandoCyan
    }
    
    func setup(with interactor: OPFeedbackFormVCInteractor?) {
        self.interactor = interactor
    }
    
}

extension OPFeedbackFormViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.height(forRowAt: indexPath) ?? 75.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interactor?.cell(forRowAt: indexPath, in: tableView) ?? UITableViewCell()
        
        if let cell = cell as? OPFeedbackFormTVTextInputCell {
            cell.willBeginEditingCallback = { (textView) in
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OPFeedbackFormViewController: OPFeedbackFormVCProtocol {
    
    func refreshUI() {
        ProgressHUD.dismiss()
        tableView.reloadData()
    }
    
    func showLoadingMessage(message: String?) {
        ProgressHUD.show(message ?? "")
    }
    
    func showMessage(title: String, message: String) {
        OPViewUtils.showOkAlertWithTitle(title: title, andMessage: message)
    }
}
