//
//  UIAddIdentityView.swift
//  Operando
//
//  Created by Costin Andronache on 10/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIAddIdentityViewResult: Equatable{
    let email: String
    let domain: Domain
    
    var asFinalIdentity: String {
        return "\(email)@\(domain.name)"
    }
}
func ==(lhs: UIAddIdentityViewResult, rhs: UIAddIdentityViewResult) -> Bool {
    return lhs.email == rhs.email && lhs.domain == rhs.domain
}

struct UIAddIdentityViewCallbacks{
    let whenPressedClose: VoidBlock?
    let whenPressedSave: ((_ result: UIAddIdentityViewResult) -> Void)?
    let whenPressedRefresh: VoidBlock?
}

struct UIAddIdentityViewLogicCallbacks {
    let dismissKeyboard: VoidBlock?
    let presentAlertWithMessage: CallbackWithString?
    
    static let allNil: UIAddIdentityViewLogicCallbacks = UIAddIdentityViewLogicCallbacks(dismissKeyboard: nil, presentAlertWithMessage: nil)
}

struct UIAddIdentityViewOutlets {
    
    let aliasTF: UITextField?
    let domainTF: UITextField?
    let closeButton: UIButton?
    let saveBtn: UIButton?
    let profileLbl: UILabel?
    let refreshBtn: UIButton?
    
    static var allDefault: UIAddIdentityViewOutlets {
        return UIAddIdentityViewOutlets(aliasTF: .init(), domainTF: .init(), closeButton: .init(), saveBtn: .init(),profileLbl: .init(), refreshBtn: .init())
    }
    
    static var allNil: UIAddIdentityViewOutlets {
        return UIAddIdentityViewOutlets(aliasTF: nil, domainTF: nil, closeButton: nil, saveBtn: nil, profileLbl: nil, refreshBtn: nil)
    }
}


class UIAddIdentityViewLogic: NSObject, UITextFieldDelegate {
    
    let cellIdentitifer = "domainCellIdentifier"
    private var domains: [Domain] = []
    private var currentlyShownDomains: [Domain] = []
    private var selectedDomainIndex: Int = -1
    
    private var callbacks: UIAddIdentityViewCallbacks?
    var editingTextField: UITextField!
    
    private var currentSelectedDomainIfAny: Domain? {
        if self.selectedDomainIndex >= 0 && self.selectedDomainIndex < self.currentlyShownDomains.count{
            return self.currentlyShownDomains[self.selectedDomainIndex]
        }
        return nil;
    }
    
    let outlets: UIAddIdentityViewOutlets
    let logicCallbacks: UIAddIdentityViewLogicCallbacks
    
    init(outlets: UIAddIdentityViewOutlets, logicCallbacks: UIAddIdentityViewLogicCallbacks) {
        self.outlets = outlets;
        self.logicCallbacks = logicCallbacks;
        super.init()
        self.commonInit()
    }
    
    //    private func setupTableView(tv: UITableView?){
    //        tv?.delegate = self
    //        tv?.dataSource = self
    //        tv?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentitifer)
    //    }
    
    func commonInit() {
        //        self.setupTableView(tv: outlets.domainsTableView)
        //        outlets.scrollView?.isScrollEnabled = false
        
        outlets.aliasTF?.delegate = self
        outlets.domainTF?.delegate = self
        self.editingTextField = outlets.domainTF
        outlets.domainTF?.isUserInteractionEnabled = false
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(UIAddIdentityViewLogic.keyboardWillAppear(_:)), name: .UIKeyboardWillShow, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(UIAddIdentityViewLogic.keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
        
        outlets.closeButton?.addTarget(self, action: #selector(didPressclose(_:)), for: .touchUpInside)
        //        outlets.closeButtons?.forEach{$0.addTarget(self, action: #selector(didPressclose(_:)), for: .touchUpInside)}
        
        outlets.refreshBtn?.addTarget(self, action: #selector(didPressRefresh(_:)), for: .touchUpInside)
        outlets.saveBtn?.addTarget(self, action: #selector(didPressSave(_:)), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupWith(domains: [Domain], andCallbacks callbacks: UIAddIdentityViewCallbacks?){
        self.domains = domains
        self.callbacks = callbacks
        //        outlets.domainsTableView?.isHidden = true
        
        
        outlets.aliasTF?.text = ""
        outlets.domainTF?.text = ""
        
        if domains.count == 1 {
            outlets.domainTF?.text  = domains.first?.name
            self.selectedDomainIndex = 0
            self.currentlyShownDomains = domains;
        }
        
    }
    
    func changeAlias(to newAlias: String){
        outlets.aliasTF?.text = newAlias
    }
    
    func updateProfileLabel() {
        
        if let aliastText = outlets.aliasTF?.text,
            let domainText = outlets.domainTF?.text {
            outlets.profileLbl?.text = aliastText + "@" + domainText
        }
    }
    
    //MARK: IBActions
    
    
    
    @IBAction func didPressclose(_ sender: UIButton) {
        self.callbacks?.whenPressedClose?()
    }
    
    @IBAction func didPressRefresh(_ sender: UIButton) {
        self.callbacks?.whenPressedRefresh?()
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        
        guard let domain = self.currentSelectedDomainIfAny,
            let alias = self.outlets.aliasTF?.text, !alias.isEmpty else {
                self.logicCallbacks.presentAlertWithMessage?(Bundle.localizedStringFor(key: kNoIncompleteFieldsLocalizableKey))
                return
        }
        
        self.callbacks?.whenPressedSave?(UIAddIdentityViewResult(email: alias, domain: domain))
    }
    
    
    //MARK: TextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.editingTextField = textField
        if textField == outlets.domainTF {
            if ( textField.text?.characters.count ?? 0 ) == 0 {
                self.displayAllDomains()
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard textField != outlets.aliasTF else {
            
            self.outlets.profileLbl?.text = NSString(string: textField.text!).replacingCharacters(in: range, with: string) + "@" + (self.outlets.domainTF?.text)!
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
    
    //    //MARK: tableView delegate and datasource
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return self.currentlyShownDomains.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentitifer) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentitifer)
    //
    //        cell.textLabel?.text = self.currentlyShownDomains[indexPath.row].name
    //
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        self.applySelectionLogicForDomainAt(index: indexPath.row)
    //    }
    
    //MARK: internal utils
    
    private func displayAllDomains(){
        self.currentlyShownDomains = self.domains
        //        outlets.domainsTableView?.isHidden = false
        //        outlets.domainsTableView?.reloadData()
    }
    
    private func displayDomains(containing domPart: String){
        self.currentlyShownDomains = self.domains.filter({ domain -> Bool in
            return domain.name.lowercased().contains(domPart.lowercased())
        })
        
        //        if self.currentlyShownDomains.count > 0 {
        //            outlets.domainsTableView?.isHidden = false
        //            outlets.domainsTableView?.reloadData()
        //        } else {
        //            outlets.domainsTableView?.isHidden = true
    }
}

//    private func applySelectionLogicForDomainAt(index: Int){
//        self.selectedDomainIndex = index
//        let domain = self.currentlyShownDomains[index]
//        outlets.domainTF?.text = domain.name
//        self.logicCallbacks.dismissKeyboard?()
//    }

//MARK: keyboard
func keyboardWillAppear(_ notification: NSNotification){
    
    //        guard self.editingTextField == outlets.domainTF else {
    //            return
    //        }
    //
    //        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
    //            return
    //        }
    //
    //        let rect = value.cgRectValue
    //        outlets.containerViewBottomSpaceToScrollView?.constant = rect.size.height
    //        UIView.animate(withDuration: 0.5) {
    //            self.outlets.scrollView?.layoutIfNeeded()
    //            let offset = CGPoint(x: 0, y: self.outlets.domainTF?.frame.origin.y ?? 0)
    //            self.outlets.scrollView?.setContentOffset(offset, animated: false)
    //        }
}

func keyboardWillDisappear(_ notification: NSNotification){
    //        outlets.containerViewBottomSpaceToScrollView?.constant = 0
    //        outlets.domainsTableView?.isHidden = true
    //        UIView.animate(withDuration: 0.5) {
    //            self.outlets.scrollView?.layoutIfNeeded()
    //        }
    //    }
    
}

class UIAddIdentityView: RSNibDesignableView, UITextFieldDelegate
{
    
    private var callbacks: UIAddIdentityViewCallbacks?
    
    @IBOutlet weak var aliasTF: UITextField!
    @IBOutlet weak var domainTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    //    @IBOutlet weak var domainsTableView: UITableView!
    @IBOutlet weak var closeXButton: UIButton!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    lazy var logic: UIAddIdentityViewLogic = {
        
        let outlets: UIAddIdentityViewOutlets = UIAddIdentityViewOutlets( aliasTF: self.aliasTF, domainTF: self.domainTF, closeButton: self.closeXButton, saveBtn: self.saveBtn,profileLbl: self.profileLbl,refreshBtn: self.refreshBtn)
        
        self.aliasTF.delegate = self
        
        weak var weakSelf = self
        return UIAddIdentityViewLogic(outlets: outlets, logicCallbacks: UIAddIdentityViewLogicCallbacks(dismissKeyboard: {
            //            weakSelf?.endEditing(true);
        }, presentAlertWithMessage: { message in
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: message)
        })); 
        
    }()
    
    
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        super.touchesEnded(touches, with: event)
    //        self.endEditing(true)
    //    }
    
    //    override func endEditing(_ force: Bool) -> Bool {
    //        self.domainsTableView.isHidden = true
    //        return super.endEditing(force)
    //    }
    
}
