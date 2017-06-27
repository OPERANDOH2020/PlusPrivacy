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
    
    static let identityManagementStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: .operandoDarkGreen, title: Bundle.localizedStringFor(key: kIdentitiesManagementLocalizableKey), image: UIImage(named: "identitiesIcon"))
    
    static let privacyForBenefitsStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoRed, title: Bundle.localizedStringFor(key: kPrivacyForBenefitsLocalizableKey), image: UIImage(named: "dealsIcon"))
    
    static let privateBrowsingStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoOrange, title: Bundle.localizedStringFor(key: kPrivateBrowsingLocalizableKey), image: UIImage(named: "browsingIcon"))
    
    static let notificationsStyle: UIDashboardButtonStyle = UIDashboardButtonStyle(backgroundColor: UIColor.operandoLightGreen, title: Bundle.localizedStringFor(key: kNotificationsLocalizableKey), image: UIImage(named: "notificationsIcon"))
    
}

struct UIDashboardButtonModel {
    let style: UIDashboardButtonStyle?
    let notificationsRequestCallbackIfAny: NumOfNotificationsRequestCallback?
    let onTap: VoidBlock?
}

class UIDashboardButton: RSNibDesignableView {

    private var model: UIDashboardButtonModel?
    
    @IBOutlet weak var numOfNotificationsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func commonInit() {
        super.commonInit()
        self.backgroundColor = UIColor.clear
    }
    
    
    func setupWith(model: UIDashboardButtonModel?){
        
        self.model = model
        self.numOfNotificationsLabel.isHidden = true
        self.contentView?.backgroundColor = model?.style?.backgroundColor
        self.titleLabel.text = model?.style?.title
        self.imageView.image = model?.style?.image
        

        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        
    }
    
    
    func updateNotificationsCountLabel() {
        model?.notificationsRequestCallbackIfAny? { count in
            self.numOfNotificationsLabel.isHidden = false
            self.numOfNotificationsLabel.text = "\(count)"
        }
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
