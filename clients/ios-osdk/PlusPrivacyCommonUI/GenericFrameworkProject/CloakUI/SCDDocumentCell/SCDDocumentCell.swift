//
//  SCDDocumentCell.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

struct SCDDocumentCellCallbacks {
    let whenUserSelectsAdvanced: VoidBlock?
    let whenRequiresResize: ((_ needsFullSize: Bool) -> Void)?
}

struct SCDDocumentCellState{
    
}

class SCDDocumentCell: UITableViewCell {
    
    static let identifierNibName: String = "SCDDocumentCell"
    private var callbacks: SCDDocumentCellCallbacks?
    private var scdDocument: SCDDocument?
    
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var advancedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var eulaLabel: UILabel!
    
    func setup(with scdDocument: SCDDocument?, inFullSize: Bool, callbacks: SCDDocumentCellCallbacks?){
        
        self.callbacks = callbacks
        self.titleLabel.text = scdDocument?.appTitle
        self.bundleLabel.text = scdDocument?.bundleId
        self.scdDocument = scdDocument
        
        if inFullSize, let document = scdDocument {
            self.disclosureButton.isSelected = true
            self.eulaLabel.attributedText = EULATextBuilder.generateEULAFrom(scd: document)
        } else {
            self.disclosureButton.isSelected = false
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    @IBAction func didPressAdvanced(_ sender: Any) {
        self.callbacks?.whenUserSelectsAdvanced?()
    }
    
    @IBAction func didPressDisclosureButton(_ sender: UIButton) {
        guard let document = self.scdDocument else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
           self.eulaLabel.attributedText = EULATextBuilder.generateEULAFrom(scd: document)
            self.callbacks?.whenRequiresResize?(true)
        } else {
            self.callbacks?.whenRequiresResize?(false)
            self.eulaLabel.attributedText = nil;
        }
    }
}
