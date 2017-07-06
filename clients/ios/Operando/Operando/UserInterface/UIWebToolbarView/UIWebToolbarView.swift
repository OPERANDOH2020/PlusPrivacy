//
//  UIWebToolbarView.swift
//  Operando
//
//  Created by Costin Andronache on 3/17/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct UIWebToolbarViewCallbacks {
    let onBackPress: VoidBlock?
    let onForwardPress: VoidBlock?
    let onTabsPress: VoidBlock?
}

struct UIWebToolbarViewOutlets {
    let numOfItemsLabel: UILabel?
    let forwardButton: UIButton?
    let backwardButton: UIButton?
    let tabsButton: UIButton?
}


class UIWebToolbarViewLogic: NSObject {
    private var callbacks: UIWebToolbarViewCallbacks?
    private let outlets: UIWebToolbarViewOutlets?
    
    init(outlets: UIWebToolbarViewOutlets?) {
        self.outlets = outlets;
        super.init()
        
        outlets?.backwardButton?.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        outlets?.forwardButton?.addTarget(self, action: #selector(forwardButtonPressed(_:)), for: .touchUpInside)
        outlets?.tabsButton?.addTarget(self, action: #selector(tabsButtonPressed(_:)), for: .touchUpInside)
    }
    
    func setupWith(callbacks: UIWebToolbarViewCallbacks?) {
        self.callbacks = callbacks;
    }
    
    func changeNumberOfItems(to numOfItems: Int){
        self.outlets?.numOfItemsLabel?.text = "\(numOfItems)"
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.callbacks?.onBackPress?()
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        self.callbacks?.onForwardPress?()
    }
    
    @IBAction func tabsButtonPressed(_ sender: Any) {
        self.callbacks?.onTabsPress?()
    }

}

class UIWebToolbarView: RSNibDesignableView {
    
    private var callbacks: UIWebToolbarViewCallbacks?
    
    @IBOutlet weak var numOfItemsLabel: UILabel?
    @IBOutlet weak var forwardButton: UIButton?
    @IBOutlet weak var backwardButton: UIButton?
    @IBOutlet weak var tabsButton: UIButton?
    
    lazy var logic: UIWebToolbarViewLogic = {
        let outlets: UIWebToolbarViewOutlets = UIWebToolbarViewOutlets(numOfItemsLabel: self.numOfItemsLabel, forwardButton: self.forwardButton, backwardButton: self.backwardButton, tabsButton: self.tabsButton)
        
        return UIWebToolbarViewLogic(outlets: outlets)
    }()
    
}
