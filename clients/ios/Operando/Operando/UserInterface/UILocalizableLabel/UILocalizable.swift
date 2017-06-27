//
//  UILocalizableLabel.swift
//  Operando
//
//  Created by Costin Andronache on 11/1/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UILocalizableLabel: UILabel {
    
    @IBInspectable var localizingKey: String = "" {
        didSet {
            self.text = Bundle.localizedStringFor(key: self.localizingKey)
        }
    }
}


class UILocalizableButton: UIButton {
    @IBInspectable var localizingKey: String = "" {
        didSet {
            self.setTitle(Bundle.localizedStringFor(key: self.localizingKey), for: .normal)
        }
    }
}
