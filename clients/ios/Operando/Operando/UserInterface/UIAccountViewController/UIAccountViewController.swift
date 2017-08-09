//
//  UIAccountViewController.swift
//  Operando
//
//  Created by Costin Andronache on 10/25/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kChangePasswordViewHeight: CGFloat = 300

typealias PasswordChangeCallback = (_ currentPassword: String, _ newPassword: String, _ successCallback: VoidBlock?) -> Void

struct UIAccountViewControllerCallbacks {
    let whenUserChoosesToLogout: VoidBlock?
    let whenUserChangesPassword: PasswordChangeCallback?
}


struct UIAccountViewControllerOutlets {
    let signOutButton: UIButton?
    let changePasswordViewLogic: UIChangePasswordViewLogic?
}

struct UIAccountViewControllerLogicCallbacks {
    let hidePasswordView: VoidBlock?
    let showPasswordChangingSpinner: VoidBlock?
    let hidePasswordChangingSpinner: VoidBlock?
}

class UIAccountViewControllerLogic: NSObject {
    let outlets: UIAccountViewControllerOutlets
    let logicCallbacks: UIAccountViewControllerLogicCallbacks?
    
    private var callbacks: UIAccountViewControllerCallbacks?
    
    init(outlets: UIAccountViewControllerOutlets, logicCallbacks: UIAccountViewControllerLogicCallbacks?) {
        self.outlets = outlets;
        self.logicCallbacks = logicCallbacks
        super.init()
        
        outlets.signOutButton?.addTarget(self, action: #selector(didPressSignOut(_:)), for: .touchUpInside)
    }
    
    
    func setupWith(callbacks: UIAccountViewControllerCallbacks?){
        self.callbacks = callbacks
        self.outlets.changePasswordViewLogic?.setupWith(callbacks: self.callbacksFor(changePasswordView: self.outlets.changePasswordViewLogic))
    }
    
    private func callbacksFor(changePasswordView: UIChangePasswordViewLogic?) -> UIChangePasswordViewCallbacks? {
        weak var weakPV = changePasswordView
        weak var weakSelf = self
        return UIChangePasswordViewCallbacks(whenConfirmedToChange: { oldPassword, newPassword in
            
            weakSelf?.logicCallbacks?.showPasswordChangingSpinner?()
            
            weakSelf?.callbacks?.whenUserChangesPassword?(oldPassword, newPassword){
                weakSelf?.logicCallbacks?.hidePasswordChangingSpinner?()
                weakPV?.clearEverything()
                weakSelf?.logicCallbacks?.hidePasswordView?()
            }
            
        }, whenCanceled: {
            weakSelf?.logicCallbacks?.hidePasswordView?()
        })
    }
    
    func didPressSignOut(_ sender: AnyObject) {
        self.callbacks?.whenUserChoosesToLogout?()
    }
}

class UIAccountViewController: UIViewController {
    @IBOutlet weak var changePasswordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var changePasswordView: UIChangePasswordView!
    

    private(set) lazy var logic: UIAccountViewControllerLogic = {
        
        let _ = self.view
        let outlets: UIAccountViewControllerOutlets = UIAccountViewControllerOutlets(signOutButton: self.signOutButton, changePasswordViewLogic: self.changePasswordView.logic)
        
        weak var weakSelf = self
        return UIAccountViewControllerLogic(outlets: outlets, logicCallbacks: UIAccountViewControllerLogicCallbacks(hidePasswordView: {
            weakSelf?.hidePasswordViewShowButton()
        }, showPasswordChangingSpinner: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }, hidePasswordChangingSpinner: {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePasswordViewShowButton()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidePasswordViewShowButton()
    }
    

    
    //MARK: IBActions
    
    @IBAction func didPressChangePasswordButton(_ sender: AnyObject) {
        self.displayPasswordViewHideButton()

    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    private func hidePasswordViewShowButton() {
        self.changePasswordViewHeightConstraint.constant = 0
        self.animateLayoutWith { 
            self.changePasswordButton.alpha = 1.0
        }
    }
    
    private func displayPasswordViewHideButton(){
        self.changePasswordViewHeightConstraint.constant = kChangePasswordViewHeight
        self.animateLayoutWith(extra: {
            self.changePasswordButton.alpha = 0.0
        })
    }
    
    private func animateLayoutWith(extra: VoidBlock?){
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            extra?()
            }, completion: nil)
    }
}
