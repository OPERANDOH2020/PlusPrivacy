//
//  UIAddIdentityView.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIAddIdentityViewResult{
    let email: String?
    let domain: Domain?
    
    var asFinalIdentity: String? {
        guard let email = self.email, let domain = self.domain else {
            return nil
        }
        guard email.characters.count > 0 else{
            return nil
        }
        
        return "\(email)@\(domain.name)"
        
    }
}

struct UIAddIdentityViewCallbacks{
    let whenPressedClose: VoidBlock?
    let whenPressedSave: ((_ result: UIAddIdentityViewResult) -> Void)?
    let whenPressedRefresh: VoidBlock?
}

class UIAddIdentityView: RSNibDesignableView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    let cellIdentitifer = "domainCellIdentifier"
    private var domains: [Domain] = []
    private var currentlyShownDomains: [Domain] = []
    private var selectedDomainIndex: Int = -1
    
    private var callbacks: UIAddIdentityViewCallbacks?
    
    @IBOutlet weak var containerViewBottomSpaceToScrollView: NSLayoutConstraint!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aliasTF: UITextField!
    @IBOutlet weak var domainTF: UITextField!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var domainsTableView: UITableView!
    
    var editingTextField: UITextField!
    
    private func setupTableView(tv: UITableView?){
        tv?.delegate = self
        tv?.dataSource = self
        tv?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentitifer)
    }
    
    override func commonInit() {
        super.commonInit()
        self.clipsToBounds = true
        self.setupTableView(tv: self.domainsTableView)
        self.scrollView.isScrollEnabled = false
        
        self.aliasTF.delegate = self
        self.domainTF.delegate = self
        self.editingTextField = self.domainTF
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIAddIdentityView.keyboardWillAppear(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIAddIdentityView.keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupWith(domains: [Domain], andCallbacks callbacks: UIAddIdentityViewCallbacks?){
        self.domains = domains
        self.callbacks = callbacks
        self.domainsTableView.isHidden = true
        
        if self.aliasTF != nil && self.domainTF != nil {
            self.aliasTF.text = ""
            self.domainTF.text = ""
        }
        
    }
    
    func changeAlias(to newAlias: String){
        self.aliasTF.text = newAlias
    }
    
    //MARK: IBActions
    
    
    
    @IBAction func didPressclose(_ sender: UIButton) {
        self.callbacks?.whenPressedClose?()
    }
    
    @IBAction func didPressRefresh(_ sender: UIButton) {
        self.callbacks?.whenPressedRefresh?()
    }
    
    
    @IBAction func didPressSave(_ sender: UIButton) {
        var domain: Domain? = nil
        if self.selectedDomainIndex >= 0 && self.selectedDomainIndex < self.currentlyShownDomains.count{
            domain = self.currentlyShownDomains[self.selectedDomainIndex]
        }
        self.callbacks?.whenPressedSave?(UIAddIdentityViewResult(email: self.aliasTF.text, domain: domain))
    }
    
    
    //MARK: TextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.editingTextField = textField
        if textField == self.domainTF {
            if ( textField.text?.characters.count ?? 0 ) == 0 {
                self.displayAllDomains()
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard textField != self.aliasTF else {
            return true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
            if let text = textField.text {
                if text.characters.count > 0 {
                    self.displayDomains(containing: text)
                    return
                }
            }
            self.displayAllDomains()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: tableView delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentlyShownDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitifer) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentitifer)
        
        cell.textLabel?.text = self.currentlyShownDomains[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userDidChooseAt(index: indexPath.row)
    }
    
    //MARK: internal utils
    
    private func displayAllDomains(){
        self.currentlyShownDomains = self.domains
        self.domainsTableView.isHidden = false
        self.domainsTableView.reloadData()
    }
    
    private func displayDomains(containing domPart: String){
        self.currentlyShownDomains = self.domains.filter({ domain -> Bool in
            return domain.name.lowercased().contains(domPart.lowercased())
        })
        
        if self.currentlyShownDomains.count > 0 {
            self.domainsTableView.isHidden = false
            self.domainsTableView.reloadData()
        } else {
            self.domainsTableView.isHidden = true
        }
    }
    
    private func userDidChooseAt(index: Int){
        self.selectedDomainIndex = index
        let domain = self.currentlyShownDomains[index]
        self.domainTF.text = domain.name
        self.endEditing(true)
    }
    
    //MARK: keyboard 
    func keyboardWillAppear(_ notification: NSNotification){
        
        guard self.editingTextField == self.domainTF else {
            return
        }
        
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        
        let rect = value.cgRectValue
        self.containerViewBottomSpaceToScrollView.constant = rect.size.height
        UIView.animate(withDuration: 0.5) { 
            self.scrollView.layoutIfNeeded()
            let offset = CGPoint(x: 0, y: self.domainTF.frame.origin.y)
            self.scrollView.setContentOffset(offset, animated: false)
        }
    }
    
    func keyboardWillDisappear(_ notification: NSNotification){
        self.containerViewBottomSpaceToScrollView.constant = 0
        self.domainsTableView.isHidden = true
        UIView.animate(withDuration: 0.5) { 
            self.scrollView.layoutIfNeeded()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.endEditing(true)
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        self.domainsTableView.isHidden = true
        return super.endEditing(force)
    }
    
}
