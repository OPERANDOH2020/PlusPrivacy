//
//  ProgressHUD.swift
//  Operando
//
//  Created by RomSoft on 11/23/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation

class ProgressHUD {
    
    static func show(){
         HUD.show(.progress)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(120)) {
            print("HIDE HUD")
            HUD.hide()
        }
    }
    
    static func show(_ text: String) {
        
        self.show(text, autoDismissAfter: 5)
    }
    
    static func show(_ text: String, autoDismissAfter: TimeInterval){
        HUD.flash(HUDContentType.label(text), delay: autoDismissAfter)
    }
    
    static func dismiss() {
        HUD.hide(animated: true)
    }
    
}
