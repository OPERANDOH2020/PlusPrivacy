//
//  UIWebTabCollectionCell.swift
//  Operando
//
//  Created by Costin Andronache on 3/20/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

class UIWebTabCollectionCell: UICollectionViewCell {
    static let identifierNibName = "UIWebTabCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    private var whenClosePressed: VoidBlock?
    
    func setupWith(webTabDescription: WebTabDescription,
                   whenClosePressed: VoidBlock?){
        
        self.titleLabel.text = webTabDescription.name
        self.imageView.image = webTabDescription.screenshot
        
        self.whenClosePressed = whenClosePressed
    }
    
    @IBAction func didPressClose(_ sender: Any) {
        self.whenClosePressed?()
    }
}
