//
//  UISecurityEventTypeView.swift
//  Operando
//
//  Created by Costin Andronache on 6/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let colorsPerSecurityTag: [SecurityEventTag: UIColor] =
    [ SecurityEventTag.Malware : UIColor.redColor(),
      SecurityEventTag.Botnet : UIColor.grayColor(),
      SecurityEventTag.Blacklist: UIColor.blackColor(),
      SecurityEventTag.DNSBL: UIColor.brownColor(),
      SecurityEventTag.MaliciousActivity: UIColor.orangeColor(),
      SecurityEventTag.Phishing: UIColor.greenColor(),
      SecurityEventTag.Spam: UIColor.cyanColor(),
      SecurityEventTag.Unknown: UIColor.darkGrayColor()
]

class UISecurityEventTypeView: RSNibDesignableView
{
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    func displaySecurityEventType(type: SecurityEventTag?)
    {
        self.typeImageView.backgroundColor = colorsPerSecurityTag[type ?? .Unknown]
        
        self.typeLabel.text = type?.rawValue
    }
}
