//
//  UIRealIdentityView.swift
//  Operando
//
//  Created by Costin Andronache on 11/9/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIRealIdentityViewDisplayState {
    let backgroundColor: UIColor?
    let defaultIdentityAlpha: CGFloat
    let yourRealIdentityTextColor: UIColor?
    
    static let nonDefault: UIRealIdentityViewDisplayState = UIRealIdentityViewDisplayState(backgroundColor: UIColor.operandoYellow, defaultIdentityAlpha: 0.0, yourRealIdentityTextColor: .operandoLightBrown)
    
    static let defaultIdentity: UIRealIdentityViewDisplayState = UIRealIdentityViewDisplayState(backgroundColor: UIColor.operandoLightBrown, defaultIdentityAlpha: 1.0, yourRealIdentityTextColor: .operandoYellow)
}

class UIRealIdentityView: RSNibDesignableView {

    @IBOutlet weak var defaultIdentityImageView: UIImageView!
    @IBOutlet weak var realIdentityLabel: UILabel!
    @IBOutlet weak var yourRealIdentityLabel: UILocalizableLabel!
    
    
    override func commonInit() {
        super.commonInit()
        self.changeDisplay(to: .nonDefault)
    }
    
    
    func setupWith(identity: String, state: UIRealIdentityViewDisplayState = .nonDefault) {
        self.realIdentityLabel.text = identity
        self.changeDisplay(to: state)
    }
    
    func changeDisplay(to state: UIRealIdentityViewDisplayState, animated: Bool = false) {
        let change = {
            self.defaultIdentityImageView.alpha = state.defaultIdentityAlpha
            self.contentView?.backgroundColor = state.backgroundColor
            self.yourRealIdentityLabel.textColor = state.yourRealIdentityTextColor
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: change, completion: nil)
        } else {
            change()
        }
    }
}
