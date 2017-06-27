//
//  RSCommonUtilities.swift
//  SIMAP
//
//  Created by Costin Andronache on 3/11/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit



class RSCommonUtilities: NSObject {
    
    class func currentDeviceIsAnIPad() -> Bool
    {
        return UI_USER_INTERFACE_IDIOM() == .pad;
    }
    
    class func showOKAlertWithMessage(message: String)
    {
        let alert = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "Ok");
        alert.show();
    }
    
}
