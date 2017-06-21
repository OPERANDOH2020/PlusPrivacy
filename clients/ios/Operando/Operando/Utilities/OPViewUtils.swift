//
//  OPAlertUtils.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation
import UIKit

class OPViewUtils
{
    class func disableViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 0.6;
            view.userInteractionEnabled = false;
        }
    }
    
    class func enbleViews(views: [UIView])
    {
        for view in views
        {
            view.alpha = 1.0;
            view.userInteractionEnabled = true;
        }
    }
    
    class func showOkAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok");
        alert.show();
    }
}