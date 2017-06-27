//
//  UIPfbDetailsView.swift
//  Operando
//
//  Created by Costin Andronache on 10/18/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


struct UIPfbDisplayingViewCallbacks{
    let whenUserTappedLink: ((_ link: String) -> Void)?
    let whenUserChangedSubscribedStatusFor: ((_ deal: PfbDeal, _ view: UIPfbDisplayingView) -> Void)?
}

struct UIPfbDetailsViewCallbacks {
    let whenPressedClose: VoidBlock?
    let pfbDisplayingViewCallbacks: UIPfbDisplayingViewCallbacks?
}

protocol UIPfbDisplayingView{
    func refreshWithOwnModel()
}

let kBenefitLocalizableKey = "kBenefitLocalizableKey"
let kVoucherLocalizableKey = "kVoucherLocalizableKey"

class UIPfbDetailsView: RSNibDesignableView, UIPfbDisplayingView {

    private var callbacks: UIPfbDetailsViewCallbacks?
    private var model: PfbDeal?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var websiteURLLabel: UILabel!
    @IBOutlet weak var dealDescriptionLabel: UILabel!
    @IBOutlet weak var subscribedStaticLabel: UILabel!
    @IBOutlet weak var benefitOrVoucherStaticLabel: UILabel!
    @IBOutlet weak var benefitOrVoucherLabel: UILabel!
    @IBOutlet weak var subscribedSwitch: UISwitch!
    
    
    
    override func commonInit() {
        super.commonInit()
        self.subscribedSwitch.onTintColor = UIColor.operandoCyan
    }
    
    func setupWith(model: PfbDeal, andCallbacks cbs: UIPfbDetailsViewCallbacks?)
    {
        self.model = model
        self.websiteURLLabel.text = model.website
        self.dealDescriptionLabel.text = model.description
        
        if let urlString = model.logo, let url = URL(string: urlString){
            self.logoImageView.setImageWith(url)
        }
        
        if let imageName = model.imageName {
            self.logoImageView.image = UIImage(named: imageName)
        }
        
        self.changeSubscribedStatus(to: model.subscribed)
        self.callbacks = cbs
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func refreshWithOwnModel() {
        self.changeSubscribedStatus(to: self.model?.subscribed ?? false)
    }
    
    func changeSubscribedStatus(to isSubscribed: Bool){
        
        self.subscribedSwitch.isOn = isSubscribed

        if !isSubscribed{
            self.benefitOrVoucherStaticLabel.text = "Benefit"
            self.benefitOrVoucherLabel.text = self.model?.benefit
        } else {
            self.benefitOrVoucherStaticLabel.text = "Voucher"
            self.benefitOrVoucherLabel.text = self.model?.voucher
        }
        
    }
    
    @IBAction func didTapOnWebsite(_ sender: AnyObject) {
        if let websiteURL = self.websiteURLLabel.text {
            self.callbacks?.pfbDisplayingViewCallbacks?.whenUserTappedLink?(websiteURL)
        }
    }
    
    @IBAction func subscribedSwitchValueChange(_ sender: AnyObject)
    {
        if let deal = self.model{
            self.callbacks?.pfbDisplayingViewCallbacks?.whenUserChangedSubscribedStatusFor?(deal ,self)
            
        }
    }
    
    @IBAction func didPressClose(_ sender: AnyObject) {
        self.callbacks?.whenPressedClose?()
    }
}
