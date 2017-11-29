//
//  UIDashboardButton.swift
//  Operando
//
//  Created by Costin Andronache on 10/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIDashboardButtonStyle{
    let backgroundColor: UIColor?
    let title: String?
    let image: UIImage?
    
    static let identityManagementStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: .operandoDarkGreen, title: Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), image: UIImage(named: "ic_group_white"))
    
    static let privacyForBenefitsStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoRed, title: Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), image: UIImage(named: "ic_fingerprint_white"))
    
    static let privateBrowsingStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoOrange, title: Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), image: UIImage(named: "ic_open_in_browser_white"))
    
    static let notificationsStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoLightGreen, title: Bundle.localizedStringFor(key: kNotificationsLocalizableKey), image: UIImage(named: "ic_notifications_white"))
    
}

struct UIDashboardButtonModel {
    let style: UIDashboardButtonStyle?
    let notificationsRequestCallbackIfAny: NumOfNotificationsRequestCallback?
    let onTap: VoidBlock?
}


struct UIDashboardButtonOutlets {
    let numOfNotificationsLabel: UILabel?
    let titleLabel: UILabel?
    let imageView: UIImageView?
    let contentView: UIView?
    
    static let allDefaults: UIDashboardButtonOutlets = UIDashboardButtonOutlets(numOfNotificationsLabel: UILabel(), titleLabel: UILabel(), imageView: UIImageView(), contentView: UIView())
}

class UIDashboardButtonLogic: NSObject {
    
    private var model: UIDashboardButtonModel?

    
    let outlets: UIDashboardButtonOutlets
    init(outlets: UIDashboardButtonOutlets) {
        self.outlets = outlets;
        super.init()
        outlets.numOfNotificationsLabel?.isHidden = true

    }
    
    func setupWith(model: UIDashboardButtonModel?){
        
        self.model = model
        outlets.contentView?.backgroundColor = model?.style?.backgroundColor
        outlets.titleLabel?.text = model?.style?.title
        outlets.imageView?.image = model?.style?.image
    }
    
    func updateNotificationsCountLabel() {
        model?.notificationsRequestCallbackIfAny? { count in
            self.outlets.numOfNotificationsLabel?.isHidden = false
            self.outlets.numOfNotificationsLabel?.text = "\(count)"
        }
    }
}

class UIDashboardButton: RSNibDesignableView {

    
    private var model: UIDashboardButtonModel?
    
    @IBOutlet weak var numOfNotificationsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var logic: UIDashboardButtonLogic = {
        let outlets: UIDashboardButtonOutlets = UIDashboardButtonOutlets(numOfNotificationsLabel: self.numOfNotificationsLabel, titleLabel: self.titleLabel, imageView: self.imageView, contentView: self.contentView)
        
        return UIDashboardButtonLogic(outlets: outlets)
    }()
    
    func setupWith(model: UIDashboardButtonModel?){
        self.model = model
        self.logic.setupWith(model: model)
    }
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.imageView.alpha = 0.6;
        self.titleLabel.alpha = 0.6
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.imageView.alpha = 1.0
        self.titleLabel.alpha = 1.0
        
        DispatchQueue.main.async {
            self.model?.onTap?()
        }
    }
    
}
