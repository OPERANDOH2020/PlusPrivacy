//
//  UIColor+Utilities.swift
//  Operando
//
//  Created by Costin Andronache on 10/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

extension UIColor{
    
    static var operandoDarkGreen: UIColor {
      return UIColor(colorLiteralRed: 0, green: 164.0/255, blue: 147.0/255, alpha: 1.0)
    }
    
    static var operandoLightGreen: UIColor {
        return UIColor(colorLiteralRed: 163.0/255, green: 169.0/255, blue: 0, alpha: 1.0)
    }
    
    
    static var operandoRed: UIColor {
        return UIColor(colorLiteralRed: 229.0/255, green: 80.0/255, blue: 73.0/255, alpha: 1.0)
    }
    
    
    static var operandoOrange: UIColor {
        return UIColor(colorLiteralRed: 1, green: 180.0/255, blue: 0, alpha: 1.0)
    }
    
    static var operandoYellow: UIColor {
        return UIColor(colorLiteralRed: 250.0/255, green: 186.0/255, blue: 51.0/255, alpha: 1.0)
    }
    
    static var operandoDarkYellow: UIColor {
        return UIColor(colorLiteralRed: 157.0/255, green: 103.0/255, blue: 8.0/255, alpha: 1.0)
    }
    
    static var operandoDarkBrown: UIColor {
        return UIColor(colorLiteralRed: 47.0/255, green: 33.0/255, blue: 0, alpha: 1.0)
    }
    
    static var operandoLightBrown: UIColor {
        return UIColor(colorLiteralRed: 189.0/255.0, green: 124.0/255.0, blue: 7.0/255.0, alpha: 1.0)
    }
    
    static var operandoCyan: UIColor {
        return UIColor(colorLiteralRed: 19.0/255.0, green: 149.0/255.0, blue: 129.0/255.0, alpha: 1.0)
    }
    
    static var operandoRedDismiss: UIColor {
        return UIColor(colorLiteralRed: 198.0/255.0, green: 65.0/255.0, blue: 6.0/255.0, alpha: 1.0)
    }
    
    
    static func colorWith(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Float = 1.0) -> UIColor {
        return UIColor(colorLiteralRed: Float(red)/255.0, green: Float(green)/255.0, blue: Float(blue)/255.0, alpha: alpha);
    }
}
