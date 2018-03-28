//
//  UISettingsProgress.swift
//  Operando
//
//  Created by RomSoft on 3/27/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class UISettingsProgress: RSNibDesignableView {

    var hasReachedTheEnd = false
    @IBOutlet weak var progressView: UIView!
    
    func setProgressBar(item: Int,total:Int) {

        setPercetange(value: CGFloat(item)*100.0/CGFloat(total))
    }
    
    func show() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.isHidden = false
            self.hasReachedTheEnd = false
        })
    }
    
    func setPercetange(value: CGFloat ){
        
        if hasReachedTheEnd == true && value > 10 {
            return
        }
        
        
        var value = value
        
        if value >= 100 {
            value = 100
            DispatchQueue.main.async(execute: { () -> Void in
                self.isHidden = true
                self.hasReachedTheEnd = true
            })
            return
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: 1) {
                
                self.isHidden = false
                
                self.progressView.frame = CGRect(x: self.progressView.frame.origin.x, y: self.progressView.frame.origin.y, width: (self.frame.width-30.0) * value/100, height:  self.progressView.frame.height)

            }
            
        })
    }

}
