//
//  UINotAvailableViewController.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/7/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class UINotAvailableViewController: UIViewController {
    
    private var whenLoginRequired: (() -> Void)?
    private var whenNewAccountRequired: (() -> Void)?
    private var activeColor: UIColor?

    @IBOutlet weak var contentView: UINotAvailableView!
    
    func setupWithCallbacks(whenLoginRequired: (() -> Void)?, whenNewAccountRequired: (() -> Void)?) {
        self.whenLoginRequired = whenLoginRequired
        self.whenNewAccountRequired = whenNewAccountRequired
    }
    
    func setupForUI(activeColor: UIColor) {
        self.activeColor = activeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setupWithCallbacks(whenLoginRequired: whenLoginRequired, whenNewAccountRequired: whenNewAccountRequired)
        contentView.setupForUI(activeColor: activeColor)
    }
}
