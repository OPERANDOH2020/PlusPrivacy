//
//  UIScanningView.swift
//  Operando
//
//  Created by Costin Andronache on 6/17/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import QuartzCore

class UIScanningView: RSNibDesignableView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scanningImage: UIImageView!
    @IBOutlet weak var scanButton: UIButton!
    
    var whenPressingScanButton: (() -> Void)?
    
    override func commonInit() {
        super.commonInit()
        self.setNormalUIState()
    }
    
    
    @IBAction func didPressScanButton(sender: AnyObject) {
        self.whenPressingScanButton?()
    }
    
    
    func beginScanningState()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.setScanningUIState()
            
        }) { (finished:Bool) in
            self.scanningImage.layer.addAnimation(self.createRotatingAnimation(), forKey: nil);
        }
    }
    
    func endScanningState()
    {
        self.scanningImage.layer.removeAllAnimations()
        self.setNormalUIState()
    }
    
    
    private func setNormalUIState()
    {
        self.scanningImage.alpha = 0.0
        self.messageLabel.alpha = 1.0
        self.scanButton.alpha = 1.0
    }
    
    private func setScanningUIState()
    {
        
        self.scanningImage.alpha = 1.0
        self.scanButton.alpha = 0.0
        self.messageLabel.alpha = 0.0
    }
    
    
    private func createRotatingAnimation() -> CAAnimation
    {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z");
        
        animation.toValue = NSNumber(double: 2 * M_PI)
        animation.duration = 5.2
        animation.cumulative = true
        animation.repeatCount = 100;
        
        return animation;
    }
}
