//
//  UINotAvailableViewController.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/7/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class UINotAvailableViewController: UIViewController {
    
    var whenLoginRequired: (() -> Void)?
    var whenNewAccountRequired: (() -> Void)?

    @IBOutlet weak var contentView: UINotAvailableView!
    
    func setupWithCallbacks(whenLoginRequired: (() -> Void)?, whenNewAccountRequired: (() -> Void)?) {
        self.whenLoginRequired = whenLoginRequired
        self.whenNewAccountRequired = whenNewAccountRequired
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.setupWithCallbacks(whenLoginRequired: whenLoginRequired, whenNewAccountRequired: whenNewAccountRequired)
    }
}
