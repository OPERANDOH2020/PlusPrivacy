//
//  UIRadialGradientView.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 3/29/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIRadialGradientView: UIView {

    @IBInspectable var InsideColor: UIColor = .appBlue
    @IBInspectable var OutsideColor: UIColor = .appTransparentDarkBlue
    private var gradientCenter: CGPoint = CGPoint(x: 0, y: 0)
    private var radius: CGFloat = 0.0
    private var pulsarConfig: UIRadialGradientViewPulsarConfiguration?
    private var pulsarTimer: Timer?
    
    override func draw(_ rect: CGRect) {
        guard let pulsarConfig = pulsarConfig else { return }
        self.addRadialGradient(fromColors: [InsideColor.cgColor, OutsideColor.cgColor], gradientCenter: gradientCenter, radius: pulsarConfig.getRadius())
    }
    
    func setup(center: CGPoint, pulsarConfiguration pulsarConfig: UIRadialGradientViewPulsarConfiguration? = nil) {
        self.gradientCenter = CGPoint(x: self.center.x, y: center.y)
        self.pulsarConfig = pulsarConfig
    }
    
    func startPulsar() {
        guard let _ = pulsarConfig else { return }
        pulsarTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UIRadialGradientView.updatePulsar), userInfo: nil, repeats: true)
    }
    
    func stopPulsar() {
        pulsarTimer?.invalidate()
    }
    
    func updatePulsar() {
        self.setNeedsDisplay()
    }
}

class UIRadialGradientTableView: UITableView {
    
    @IBInspectable var InsideColor: UIColor = .appBlue
    @IBInspectable var OutsideColor: UIColor = .appTransparentDarkBlue
    var colors: [CGColor] = []
    private var gradientCenter: CGPoint = CGPoint(x: 0, y: 0)
    private var radius: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        self.addRadialGradient(fromColors: colors, gradientCenter: gradientCenter, radius: radius)
    }
    
    func setup(colors: [CGColor], center: CGPoint, endRadius: CGFloat) {
        self.gradientCenter = center
        self.radius = endRadius
        self.colors = colors
    }
}
