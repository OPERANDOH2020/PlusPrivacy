//
//  UIWebViewTab.swift
//  Operando
//
//  Created by Costin Andronache on 3/17/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import WebKit

fileprivate let kIconsMessageHandler = "iconsMessageHandler"




class UIWebViewTab: RSNibDesignableView{
    
    @IBOutlet weak var addressBarView: UIView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressTF: UITextField!
    
    lazy private(set) var logic: UIWebViewTabLogic = {
        let outlets: UIWebViewTabLogicOutlets = UIWebViewTabLogicOutlets(contentView: self.contentView, goButton: self.goButton, addressTF: self.addressTF, activityIndicator: self.activityIndicator, addressBarView: self.addressBarView)
        
        return UIWebViewTabLogic(outlets: outlets)
    }()
    

    //MARK: - public methods and initializer
    
    override func commonInit() {
        super.commonInit()
        self.styleGoButton()
    }
    
    private func styleGoButton(){
        let title: NSMutableAttributedString = NSMutableAttributedString(string: "Go")
        let range: NSRange = NSMakeRange(0, 2);
        let color: UIColor = UIColor(colorLiteralRed: 0, green: 169.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        
        title.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: range)
        title.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        title.addAttribute(NSUnderlineColorAttributeName, value: color, range: range)
        title.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        
        self.goButton.setAttributedTitle(title, for: UIControlState.normal)
    }
}
