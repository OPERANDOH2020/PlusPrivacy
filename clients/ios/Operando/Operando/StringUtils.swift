//
//  StringUtils.swift
//  Operando
//
//  Created by RomSoft on 12/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
