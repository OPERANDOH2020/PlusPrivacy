//
//  UILabel+Utils.swift
//  Operando
//
//  Created by Catalin Pomirleanu on 3/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

extension UILabel {

    func adjustedFontSize() -> CGFloat {
        guard let selfText = self.text else { return self.font.pointSize }
        
        if self.adjustsFontSizeToFitWidth == true {
            var currentFont: UIFont = self.font
            let originalFontSize = currentFont.pointSize
            var currentSize: CGSize = (selfText as NSString).size(attributes: [NSFontAttributeName : currentFont])
            
            while currentSize.width > self.frame.size.width && currentFont.pointSize > (originalFontSize * self.minimumScaleFactor) {
                currentFont = currentFont.withSize(currentFont.pointSize - 1)
                currentSize = (selfText as NSString).size(attributes: [NSFontAttributeName : currentFont])
            }
            
            return currentFont.pointSize
        }
        
        return self.font.pointSize
    }
    
    static func heightForView(text: String, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}
