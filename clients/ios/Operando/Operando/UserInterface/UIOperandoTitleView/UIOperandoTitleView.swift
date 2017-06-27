//
//  UIOperandoTitleView.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIOperandoTitleView: RSNibDesignableView {

    @IBInspectable var titleFontSize: CGFloat = 40.0;
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func commonInit() {
        super.commonInit()
        self.contentView?.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
    }

}
