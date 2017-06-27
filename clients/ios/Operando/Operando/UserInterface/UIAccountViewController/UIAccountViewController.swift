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

struct UIAccountViewControllerModel{
    let repository: UserInfoRepository?
    let whenUserChoosesToLogout: VoidBlock?
    let whenUserChangesPassword: PasswordChangeCallback?
}

class UIAccountViewController: UIViewController {
    @IBOutlet weak var changePasswordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var changePasswordView: UIChangePasswordView!
    
    private var model: UIAccountViewControllerModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePasswordViewShowButton()
        self.changePasswordView.setupWith(callbacks: self.callbacksFor(changePasswordView: self.changePasswordView))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidePasswordViewShowButton()
    }
    
    func setupWith(model: UIAccountViewControllerModel?){
        let _ = self.view
        self.model = model
        
        model?.repository?.getCurrentUserInfo(in: { info, error in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
                        
        })
        
    }
    
    //MARK: IBActions
    
    @IBAction func didPressChangePasswordButton(_ sender: AnyObject) {
        self.displayPasswordViewHideButton()

    }
    
    @IBAction func didPressSignOut(_ sender: AnyObject) {
        self.model?.whenUserChoosesToLogout?()
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
    
    
    
    
    private func callbacksFor(changePasswordView: UIChangePasswordView) -> UIChangePasswordViewCallbacks? {
        weak var weakPV = changePasswordView
        weak var weakSelf = self
        return UIChangePasswordViewCallbacks(whenConfirmedToChange: { oldPassword, newPassword in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            weakSelf?.model?.whenUserChangesPassword?(oldPassword, newPassword){
                weakPV?.clearEverything()
                weakSelf?.hidePasswordViewShowButton()
            }
            
            }, whenCanceled: {
                weakSelf?.hidePasswordViewShowButton()
        })
    }
    
    
}
