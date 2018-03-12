//
//  UIRealIdentityView.swift
//  Operando
//
//  Created by Costin Andronache on 11/9/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIRealIdentityCallbacks {
    
    let setRealIdentityAsDefault: VoidBlock?
}

struct UIRealIdentityViewDisplayState {
    let backgroundColor: UIColor?
    let defaultIdentityAlpha: CGFloat
    let yourRealIdentityTextColor: UIColor?
    let defaultIdentity: Bool?
    
    static let nonDefault: UIRealIdentityViewDisplayState = UIRealIdentityViewDisplayState(backgroundColor: UIColor.operandoYellow, defaultIdentityAlpha: 0.5, yourRealIdentityTextColor: .operandoLightBrown, defaultIdentity: false)
    
    static let defaultIdentity: UIRealIdentityViewDisplayState = UIRealIdentityViewDisplayState(backgroundColor: UIColor.operandoLightBrown, defaultIdentityAlpha: 1.0, yourRealIdentityTextColor: .operandoYellow, defaultIdentity: true)
}

class UIRealIdentityView: RSNibDesignableView {

    @IBOutlet weak var defaultIdentityImageView: UIImageView!
    @IBOutlet weak var realIdentityLabel: UILabel!
    @IBOutlet weak var yourRealIdentityLabel: UILocalizableLabel!
    @IBOutlet weak var defaultEnabledImageView: UIImageView!

    var state: UIRealIdentityViewDisplayState = UIRealIdentityViewDisplayState.nonDefault
    
    var logicCallbacks: UIRealIdentityCallbacks?
    
    override func commonInit() {
        super.commonInit()
        self.changeDisplay(to: .nonDefault)
        self.addObserverOnIdentity()
    }
    
//    override func awakeFromNib() {
//        let adjustedFontSize = realIdentityLabel.adjustedFontSize()
//        if yourRealIdentityLabel.font.pointSize > adjustedFontSize {
//            yourRealIdentityLabel.font = yourRealIdentityLabel.font.withSize(adjustedFontSize - 3.0)
//        }
//    }
    
    func addObserverOnIdentity() {
        realIdentityLabel.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            let adjustedFontSize = realIdentityLabel.adjustedFontSize()
            if yourRealIdentityLabel.font.pointSize > adjustedFontSize {
                yourRealIdentityLabel.font = yourRealIdentityLabel.font.withSize(adjustedFontSize)
            }
        }
    }
    
    func setupWith(identity: String, state: UIRealIdentityViewDisplayState = .nonDefault,logicCallback: UIRealIdentityCallbacks) {
        self.realIdentityLabel.text = identity
        self.changeDisplay(to: state)
        self.logicCallbacks = logicCallback
    }
    
    func changeDisplay(to state: UIRealIdentityViewDisplayState, animated: Bool = false) {
        
        self.state = state
        
        let change = {
            
            if state.defaultIdentity == true {
                self.defaultEnabledImageView.image = #imageLiteral(resourceName: "default_enabled")
            }
            else {
                self.defaultEnabledImageView.image = #imageLiteral(resourceName: "default_disabled")
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: change, completion: nil)
        } else {
            change()
        }
    }
    @IBAction func pressedDefaultIdentityButton(_ sender: Any) {
        logicCallbacks?.setRealIdentityAsDefault?()
    }
}
