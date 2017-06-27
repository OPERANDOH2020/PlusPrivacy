//
//  UIIdentityManagementViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


let kNewSIDGeneratedLocalizableKey = "kNewSIDGeneratedLocalizableKey"
let kDoYouWantToDeleteSIDLocalizableKey = "kDoYouWantToDeleteSIDLocalizableKey"
let kAddNewIdentityLocalizableKey = "kAddNewIdentityLocalizableKey"
let kNoIncompleteFieldsLocalizableKey = "kNoIncompleteFieldsLocalizableKey"
let kNoIdentitiesAtTheMomentLocalizableKey = "kNoIdentitiesAtTheMomentLocalizableKey"

let kMaxNumOfIdentities: Int = 20


class UIIdentityManagementViewController: UIViewController
{
    private var realIdentity: String = ""
    private var identitiesRepository: IdentitiesManagementRepository?
    private var currentNumOfIdentities: Int = 0 {
        didSet{
            self.updateUIBasedOnNumOfIdentities(self.currentNumOfIdentities)
        }
    }
    
    @IBOutlet weak var identitiesListView: UIIdentitiesListView?
    @IBOutlet weak var addNewIdentityButton: UIButton?
    @IBOutlet weak var numOfIdentitiesLeftLabel: UILabel!
    @IBOutlet weak var realIdentityView: UIRealIdentityView!
    
    
    func setupWith(identitiesRepository: IdentitiesManagementRepository?) {
        let _  = self.view
        self.identitiesRepository = identitiesRepository
        self.loadCurrentIdentitiesWith(repository: identitiesRepository)
    }
    
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewIdentity(_ sender: AnyObject) {
        self.addNewIdentity()
    }
    
    
    //MARK: helper
    
    private func updateUIBasedOnNumOfIdentities(_ num: Int){
        self.numOfIdentitiesLeftLabel.text = "You can add \(kMaxNumOfIdentities - num) more identities"
        if num == kMaxNumOfIdentities {
            self.addNewIdentityButton?.isUserInteractionEnabled = false
            self.addNewIdentityButton?.alpha = 0.6
        } else {
            self.addNewIdentityButton?.isUserInteractionEnabled = true
            self.addNewIdentityButton?.alpha = 1.0
        }
    }
    
    private func loadCurrentIdentitiesWith(repository: IdentitiesManagementRepository?)
    {
        repository?.getRealIdentityWith(completion: { realIdentity, _ in
            self.realIdentity = realIdentity
            self.realIdentityView.setupWith(identity: realIdentity)
        })
        
        ProgressHUD.show(kConnecting, autoDismissAfter: 3.0);
        repository?.getCurrentIdentitiesListWith(completion: { (identities, error) in
            ProgressHUD.dismiss()
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            self.currentNumOfIdentities = identities.identitiesList.count
            self.identitiesListView?.setupWith(initialList: identities.identitiesList, defaultIdentityIndex: identities.indexOfDefaultIdentity ,andCallbacks: self.callbacksFor(identitiesListView: self.identitiesListView))
            
            if identities.indexOfDefaultIdentity == nil {
                // this means that the default identity is the real identity
                self.realIdentityView.changeDisplay(to: .defaultIdentity, animated: true)
            }
        })
    }
    
    
    
    private func callbacksFor(identitiesListView: UIIdentitiesListView?) -> UIIdentitiesListCallbacks{
        weak var weakSelf = self
        
        return UIIdentitiesListCallbacks(whenPressedToDeleteItemAtIndex: { item, index in
            weakSelf?.delete(identity: item, atIndex: index)
          }, whenActivatedItem: { item in
             weakSelf?.setAsDefault(identity: item)
        })
        
    }
    
    private func delete(identity: String, atIndex index: Int){
        
        OPViewUtils.displayAlertWithMessage(message: Bundle.localizedStringFor(key: kDoYouWantToDeleteSIDLocalizableKey), withTitle: identity, addCancelAction: true) {
        
            ProgressHUD.show(kConnecting, autoDismissAfter: 5.0)
            self.identitiesRepository?.remove(identity: identity, withCompletion: { nextDefaultIdentity, error  in
                ProgressHUD.dismiss()
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                if nextDefaultIdentity.characters.count == 0 {
                    OPErrorContainer.displayError(error: OPErrorContainer.unknownError)
                    return
                }
                
                self.identitiesListView?.deleteItemAt(index: index)
                
                if nextDefaultIdentity == self.realIdentity {
                    // must animate the new custom view
                } else {
                    self.identitiesListView?.displayAsDefault(identity: nextDefaultIdentity)
                }
                
                self.currentNumOfIdentities -= 1
            })
        }
    }
    
    private func setAsDefault(identity: String)
    {
        ProgressHUD.show(kConnecting, autoDismissAfter: 5.0)
        self.identitiesRepository?.updateDefaultIdentity(to: identity, withCompletion: { success, error  in
            ProgressHUD.dismiss()
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            
            if !success {
                OPErrorContainer.displayError(error: OPErrorContainer.unknownError)
                return
            }
            
            let state: UIRealIdentityViewDisplayState = identity != self.realIdentity ? .nonDefault : .defaultIdentity
            self.realIdentityView.changeDisplay(to: state, animated: true)
            self.identitiesListView?.displayAsDefault(identity: identity)
            
        })
    }
    
    
    private func addNewIdentity(){
        UIAddIdentityAlertViewController.displayAndAddIdentityWith(identitiesRepository: self.identitiesRepository) { identity in
            self.identitiesListView?.appendAndDisplayNew(item: identity)
            self.currentNumOfIdentities += 1
        }
        
    }
    
}
