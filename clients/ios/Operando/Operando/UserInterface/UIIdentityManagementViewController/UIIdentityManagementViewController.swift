//
//  UIIdentityManagementViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit




let kMaxNumOfIdentities: Int = 20

struct UIIdentityManagementCallbacks {
    let obtainNewIdentityWithCompletion: ((_ completion: CallbackWithString?) -> Void)?
}

struct UIIdentityManagementViewControllerOutlets {
    let identitiesListViewLogic: UIIdentitiesListViewLogic?
    let addNewIdentityButton: UIButton?
    let numberOfIdentitiesLeftLabel: UILabel?
    let realIdentityView: UIRealIdentityView?
    
    static let allNil: UIIdentityManagementViewControllerOutlets = UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: nil, addNewIdentityButton: nil, numberOfIdentitiesLeftLabel: nil, realIdentityView: nil)
}

struct UIIdentityManagementViewControllerLogicCallbacks {
    let displayStatusPopupWithMessage: CallbackWithString?
    let dismissStatusPopup: VoidBlock?
    let displayConfirmationPanel: ((_ title: String, _ message: String, _ confirmationCallback: VoidBlock?) -> Void)?
    let displayError: CallbackWithError?
}

class UIIdentityManagementViewControllerLogic: NSObject {
    let outlets: UIIdentityManagementViewControllerOutlets
    let logicCallbacks: UIIdentityManagementViewControllerLogicCallbacks?
    
    init(outlets: UIIdentityManagementViewControllerOutlets, logicCallbacks: UIIdentityManagementViewControllerLogicCallbacks?) {
        self.outlets = outlets;
        self.logicCallbacks = logicCallbacks
        super.init()
    }
    
    private var realIdentity: String = ""
    private var identitiesRepository: IdentitiesManagementRepository?
    private var callbacks: UIIdentityManagementCallbacks?
    
    private var currentNumOfIdentities: Int = 0 {
        didSet{
            self.updateUIBasedOnNumOfIdentities(self.currentNumOfIdentities)
        }
    }
    
    
    
    
    func setupWith(identitiesRepository: IdentitiesManagementRepository?, callbacks: UIIdentityManagementCallbacks?) {
        self.identitiesRepository = identitiesRepository
        self.loadCurrentIdentitiesWith(repository: identitiesRepository)
        self.callbacks = callbacks
    }
    
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewIdentity(_ sender: AnyObject) {
        self.addNewIdentity()
    }
    
    
    //MARK: helper
    
    private func updateUIBasedOnNumOfIdentities(_ num: Int){
        outlets.numberOfIdentitiesLeftLabel?.text = "You can add \(kMaxNumOfIdentities - num) more identities"
        if num == kMaxNumOfIdentities {
            outlets.addNewIdentityButton?.isUserInteractionEnabled = false
            outlets.addNewIdentityButton?.alpha = 0.6
        } else {
            outlets.addNewIdentityButton?.isUserInteractionEnabled = true
            outlets.addNewIdentityButton?.alpha = 1.0
        }
    }
    
    private func loadCurrentIdentitiesWith(repository: IdentitiesManagementRepository?)
    {
        repository?.getRealIdentityWith(completion: { realIdentity, _ in
            self.realIdentity = realIdentity
            self.outlets.realIdentityView?.setupWith(identity: realIdentity)
        })
        
        self.logicCallbacks?.displayStatusPopupWithMessage?(Bundle.localizedStringFor(key: kConnectingLocalizableKey))
        
        repository?.getCurrentIdentitiesListWith(completion: { (identities, error) in
            self.logicCallbacks?.dismissStatusPopup?()
            
            if let error = error {
                self.logicCallbacks?.displayError?(error)
                return
            }
            
            self.currentNumOfIdentities = identities.identitiesList.count
            self.outlets.identitiesListViewLogic?.setupWith(initialList: identities.identitiesList, defaultIdentityIndex: identities.indexOfDefaultIdentity ,andCallbacks: self.callbacksForIdentitiesListLogic())
            
            if identities.indexOfDefaultIdentity == nil {
                // this means that the default identity is the real identity
                self.outlets.realIdentityView?.changeDisplay(to: .defaultIdentity, animated: true)
            }
        })
    }
    
    
    
    private func callbacksForIdentitiesListLogic() -> UIIdentitiesListCallbacks{
        weak var weakSelf = self
        
        return UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { item, index in
            weakSelf?.delete(identity: item, atIndex: index)
        }, whenActivatedItem: { item in
            weakSelf?.setAsDefault(identity: item)
        })
        
    }
    
    private func delete(identity: String, atIndex index: Int){
        
        self.logicCallbacks?.displayConfirmationPanel?(identity, Bundle.localizedStringFor(key: kDoYouWantToDeleteSIDLocalizableKey)) {
            
            self.logicCallbacks?.displayStatusPopupWithMessage?(Bundle.localizedStringFor(key: kConnectingLocalizableKey))
            
            self.identitiesRepository?.remove(identity: identity, withCompletion: { nextDefaultIdentity, error  in
                
                self.logicCallbacks?.dismissStatusPopup?()
                if let error = error {
                    self.logicCallbacks?.displayError?(error)
                    return
                }
                if nextDefaultIdentity.characters.count == 0 {
                    self.logicCallbacks?.displayError?(OPErrorContainer.unknownError)
                    return
                }
                
                self.outlets.identitiesListViewLogic?.deleteItemAt(index: index)
                
                if nextDefaultIdentity == self.realIdentity {
                    // must animate the new custom view
                    self.outlets.realIdentityView?.changeDisplay(to: .defaultIdentity, animated: true)
                } else {
                    self.outlets.identitiesListViewLogic?.displayAsDefault(identity: nextDefaultIdentity)
                }
                
                self.currentNumOfIdentities -= 1
            })
        }
    }
    
    private func setAsDefault(identity: String) {
        self.logicCallbacks?.displayStatusPopupWithMessage?(Bundle.localizedStringFor(key: kConnectingLocalizableKey))
        
        self.identitiesRepository?.updateDefaultIdentity(to: identity, withCompletion: { error  in
            self.logicCallbacks?.dismissStatusPopup?()
            if let error = error {
                self.logicCallbacks?.displayError?(error)
                return
            }
            
            let state: UIRealIdentityViewDisplayState = identity != self.realIdentity ? .nonDefault : .defaultIdentity
            self.outlets.realIdentityView?.changeDisplay(to: state, animated: true)
            self.outlets.identitiesListViewLogic?.displayAsDefault(identity: identity)
            
        })
    }
    
    
    private func addNewIdentity(){
        weak var weakSelf = self
        self.callbacks?.obtainNewIdentityWithCompletion? { identity in
            weakSelf?.outlets.identitiesListViewLogic?.appendAndDisplayNew(item: identity)
            weakSelf?.currentNumOfIdentities += 1
        }
    }
}

class UIIdentityManagementViewController: UIViewController {
    
    @IBOutlet weak var identitiesListView: UIIdentitiesListView?
    @IBOutlet weak var addNewIdentityButton: UIButton?
    @IBOutlet weak var numOfIdentitiesLeftLabel: UILabel!
    @IBOutlet weak var realIdentityView: UIRealIdentityView!
    
    private(set) lazy var logic: UIIdentityManagementViewControllerLogic = {
        let _ = self.view
        
        let outlets: UIIdentityManagementViewControllerOutlets =
        UIIdentityManagementViewControllerOutlets(identitiesListViewLogic: self.identitiesListView?.logic, addNewIdentityButton: self.addNewIdentityButton, numberOfIdentitiesLeftLabel: self.numOfIdentitiesLeftLabel, realIdentityView: self.realIdentityView)
        
        return UIIdentityManagementViewControllerLogic(outlets: outlets, logicCallbacks: UIIdentityManagementViewControllerLogicCallbacks(displayStatusPopupWithMessage: { status in
            ProgressHUD.show(status)
        }, dismissStatusPopup: {
            ProgressHUD.dismiss()
        }, displayConfirmationPanel: { (title: String, message: String, callback: VoidBlock?) in
            OPViewUtils.displayAlertWithMessage(message: message, withTitle: title, addCancelAction: true, withConfirmation: callback)
            
        }, displayError: { error in
            guard let error = error else {
                return
            }
            OPErrorContainer.displayError(error: error)
        }))
    }()
    
}
