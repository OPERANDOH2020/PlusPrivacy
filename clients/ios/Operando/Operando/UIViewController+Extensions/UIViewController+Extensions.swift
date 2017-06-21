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
            UIView.constrainView(controller.view, inHostView: hostView!);
        }
        else
        {
            controller.view.translatesAutoresizingMaskIntoConstraints = true;
            controller.view.frame = self.view.bounds;
            hostView!.addSubview(controller.view);
        }
        controller.didMoveToParentViewController(self);
    }
    
    func removeContentController(controller: UIViewController)
    {
        controller.willMoveToParentViewController(nil);
        controller.view.removeFromSuperview();
        controller.removeFromParentViewController();
    }
    
    func bringContentControllerInFront(controller: UIViewController)
    {
        self.view.bringSubviewToFront(controller.view);
    }
    
    func moveContentController(contentController: UIViewController, behindContentController frontContentController: UIViewController)
    {
        self.view.insertSubview(contentController.view, belowSubview: frontContentController.view);
    }
    
}