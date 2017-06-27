//
//  SCDDetailsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

public typealias VoidBlock = () -> Void

class SCDDetailsViewController: UIViewController {

    @IBOutlet weak var scdDetailsView: SCDDetailsView!
    @IBOutlet weak var titleBarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var appTitleLabel: UILabel!
    private var backCallback: VoidBlock?
    
    func setupWith(scd: SCDDocument, titleBarHeight: CGFloat, backCallback: VoidBlock?) {
        let _ = self.view
        self.scdDetailsView.setupWith(scd: scd)
        self.backCallback = backCallback
        self.appTitleLabel.text = scd.appTitle;
        self.titleBarHeightConstraint.constant = titleBarHeight
    }
    

    @IBAction func didPressExitButton(_ sender: Any) {
        self.backCallback?()
    }

}
