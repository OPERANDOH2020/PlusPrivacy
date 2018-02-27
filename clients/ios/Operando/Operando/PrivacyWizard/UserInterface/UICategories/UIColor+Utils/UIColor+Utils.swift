//
//  UIColor+Utilities.swift
//  Operando
//
//  Created by Costin Andronache on 10/19/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

extension UIColor{
    
    private static let maxHex: Float = 255
    
    private static func customColor(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/maxHex, green: green/maxHex, blue: blue/maxHex, alpha: 1.0)
    }
    
    private static func customColor(red: Float, green: Float, blue: Float, alpha: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/maxHex, green: green/maxHex, blue: blue/maxHex, alpha: alpha)
    }
    
    static var appBlue: UIColor {
        return customColor(red: 2, green: 70, blue: 95)
    }
    
    static var appTransparentWhite: UIColor {
        return customColor(red: 255, green: 255, blue: 255, alpha: 0.05)
    }
    
    static var appLightBlue: UIColor {
        return customColor(red: 65, green: 170, blue: 180)
    }
    
    static var appMidBlue: UIColor {
        return customColor(red: 29, green: 40, blue: 63)
    }
    
    static var appTransparentMidBlue: UIColor {
        return customColor(red: 29, green: 40, blue: 63, alpha: 0.5)
    }
    
    static var appDarkBlue: UIColor {
        return customColor(red: 3, green: 12, blue: 36)
    }
    
    static var appTransparentDarkBlue: UIColor {
        return customColor(red: 3, green: 12, blue: 36, alpha: 0.5)
    }
    
    static var appYellow: UIColor {
        return customColor(red: 200, green: 175, blue: 25)
    }
    
    static var appLightYellow: UIColor {
        return customColor(red: 246, green: 244, blue: 233)
    }
    
    static var operandoDarkBlue: UIColor {
        return customColor(red: 44, green: 99, blue: 210)
    }
    
    static var operandoBlue: UIColor {
        return customColor(red: 35, green: 147, blue: 184)
    }
    
    static var operandoMidBlue: UIColor {
        return customColor(red: 36, green: 95, blue: 185)
    }
    
    static var operandoLightBlue: UIColor {
        return customColor(red: 56, green: 115, blue: 205)
    }
    
    static var operandoGreen: UIColor {
        return customColor(red: 9, green: 112, blue: 84)
    }
    
    static var operandoSkyBlue: UIColor {
        return customColor(red: 16, green: 75, blue: 165)
    }
    
    static var operandoSkyMidBlue: UIColor {
        return customColor(red: 39, green: 190, blue: 224)
    }
    
    static var operandoSkyLightBlue: UIColor {
        return customColor(red: 91, green: 189, blue: 215)
    }
    
    static var operandoSkyTransparentLightBlue: UIColor {
        return customColor(red: 91, green: 189, blue: 215, alpha: 0.75)
    }
    
    static var operandoSkyGradientColors: [CGColor] {
        return [UIColor.operandoSkyBlue.cgColor,
        UIColor.operandoSkyBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyLightBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor,
        UIColor.operandoSkyMidBlue.cgColor]
    }
}
