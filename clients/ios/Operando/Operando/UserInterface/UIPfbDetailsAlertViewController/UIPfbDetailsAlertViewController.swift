//
//  UIPfbDetailsAlertViewController.swift
//  Operando
//
//  Created by Costin Andronache on 10/18/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit


extension UIViewController{
    
    var topMostPresentedControllerOrSelf: UIViewController {
        
        if let selfPresented = self.presentedViewController {
            return selfPresented.topMostPresentedControllerOrSelf
        }
        return self
    }
    
}

class UIPfbDetailsAlertViewController: UIViewController {
    @IBOutlet weak var blackBackgroundView: UIView!
    @IBOutlet weak var pfbDetailsView: UIPfbDetailsView!
    
    var whenViewWillAppear: VoidBlock?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pfbDetailsView.attachPopUpAnimationWithDuration(0.3)
        self.whenViewWillAppear?()
        
    }
    
    
    static func displayWith(deal: PfbDeal, andCallbacks cbs: UIPfbDisplayingViewCallbacks?){
        let vc = UINavigationManager.pfbDealDetailsAlertViewController
        weak var weakVC = vc
        
        vc.whenViewWillAppear = {
            weakVC?.pfbDetailsView.setupWith(model: deal, andCallbacks: UIPfbDetailsViewCallbacks(whenPressedClose: { 
                weakVC?.dismiss(animated: true, completion: nil)
                }, pfbDisplayingViewCallbacks: cbs))
        }
        
        UIApplication.shared.delegate?.window??.rootViewController?.topMostPresentedControllerOrSelf.present(vc, animated: true, completion: nil)
    }
    
}
