//
//  UIViewController+Extensions.swift
//  SIMAP
//
//  Created by Costin Andronache on 3/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func addContentController(controller: UIViewController, constrainWithAutolayout useAutoLayout: Bool = true, inOwnViewSubview subview: UIView? = nil)
    {
        self.addChildViewController(controller);
        
        let hostView = subview ?? self.view
        
        if useAutoLayout
        {
            controller.view.translatesAutoresizingMaskIntoConstraints = false;
            UIView.constrainView(view: controller.view, inHostView: hostView!);
        }
        else
        {
            controller.view.translatesAutoresizingMaskIntoConstraints = true;
            controller.view.frame = self.view.bounds;
            hostView!.addSubview(controller.view);
        }
        controller.didMove(toParentViewController: self);
        
        hostView?.setNeedsLayout()
        hostView?.layoutIfNeeded()
    }
    
    func removeContentController(controller: UIViewController)
    {
        controller.willMove(toParentViewController: nil);
        controller.view.removeFromSuperview();
        controller.removeFromParentViewController();
    }
    
    func bringContentControllerInFront(controller: UIViewController)
    {
        self.view.bringSubview(toFront: controller.view);
    }
    
    func moveContentController(contentController: UIViewController, behindContentController frontContentController: UIViewController)
    {
        self.view.insertSubview(contentController.view, belowSubview: frontContentController.view);
    }
    
}
