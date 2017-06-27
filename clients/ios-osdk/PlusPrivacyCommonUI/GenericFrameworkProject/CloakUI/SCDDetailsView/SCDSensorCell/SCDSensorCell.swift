//
//  SCDSensorCell.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

extension UIColor {
    public static func colorWith(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float) -> UIColor {
        return UIColor(colorLiteralRed: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

class SCDSensorCell: UITableViewCell {
    static let identifierNibName = "SCDSensorCell"
    
    @IBOutlet weak var sensorNameLabel: UILabel!
    @IBOutlet weak var privacyLevelLabel: UILabel!
    

    
    private static let colorsPerPrivacyLevel: [UIColor] = [.colorWith(51, 102, 255, 0.7),
                                                           .colorWith(255, 255, 0, 0.7),
                                                           .colorWith(255, 204, 0, 0.7),
                                                           .colorWith(255, 153, 0, 0.7),
                                                           .colorWith(255, 102, 0, 0.7),
                                                           .colorWith(255, 0, 0, 0.7)];
    
    
    func setupWith(sensor: AccessedInput) {
        let privacyLevel = sensor.privacyDescription.privacyLevel.rawValue
        self.sensorNameLabel.text = InputType.namesPerInputType[sensor.inputType]
        self.privacyLevelLabel.text = "PL\(privacyLevel)"
        if privacyLevel >= 1 && privacyLevel <= SCDSensorCell.colorsPerPrivacyLevel.count {
            self.contentView.backgroundColor = SCDSensorCell.colorsPerPrivacyLevel[privacyLevel - 1]
        }
    }
    
}
