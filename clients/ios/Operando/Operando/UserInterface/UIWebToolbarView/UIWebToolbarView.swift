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

class UIWebToolbarView: RSNibDesignableView {
    
    private var callbacks: UIWebToolbarViewCallbacks?
    
    @IBOutlet weak var numOfItemsLabel: UILabel!
    
    func changeNumberOfItems(to numOfItems: Int){
        self.numOfItemsLabel.text = "\(numOfItems)"
    }
    
    func setupWith(callbacks: UIWebToolbarViewCallbacks?) {
        self.callbacks = callbacks;
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
