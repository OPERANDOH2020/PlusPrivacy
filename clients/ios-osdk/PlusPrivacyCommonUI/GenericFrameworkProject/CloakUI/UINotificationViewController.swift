//
//  UINotificationViewController.swift
//  SIMAP
//
//  Created by Costin Andronache on 4/14/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

let UINotificationViewControllerIdentifier = "UINotificationViewController"
public class UINotificationViewController: UIViewController {

    @IBOutlet weak var notificationViewTopSpaceCn: NSLayoutConstraint!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    fileprivate var whenViewWillAppear: (() -> ())?
    
    var onClose: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    
    fileprivate func setNotificationMessage(_ message: String, backgroundColor color: UIColor?, atDistanceFromTop distance: CGFloat)
    {
        let _ = self.view
        
        if let color = color {
            self.notificationView.backgroundColor = color;
        }
        
        self.notificationLabel.text = message;
        self.notificationViewTopSpaceCn.constant = distance
        self.notificationView.setNeedsLayout()
        self.notificationLabel.layoutIfNeeded()
    }
    
    fileprivate func fadeOutNotificationViewWithCompletion(_ completion: ((_ finished: Bool) -> ())?)
    {
        UIView.animate(withDuration: 2.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: { 
            self.notificationView.alpha = 0.0;
            }, completion: completion);
    }
    
    
    fileprivate class func presentNotificationWithMessage(
                                            _ message: String,
                                                       inController hostController:UIViewController,
                                                                    atDistanceFromTop topDistance:CGFloat)
    
    {
        
        let storyboard = UIStoryboard(name: "Cloak", bundle: Bundle.commonUIBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: UINotificationViewControllerIdentifier) as! UINotificationViewController
        
        // force view to load 
        vc.setNotificationMessage(message, backgroundColor: nil, atDistanceFromTop: topDistance);
        
        weak var weakVC = vc;
        weak var weakHost = hostController;

        vc.onClose = {
            guard let vcvc = weakVC else {
                return
            }
            weakHost?.ppRemoveChildContentController(vcvc);
            
        }
        
        hostController.ppAddChildContentController(vc);
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.onClose?()
    }
    


 
    
    
    public class func presentBadNotificationMessage(_ message: String,
                                             inController hostController:UIViewController,
                                                          atDistanceFromTop topDistance:CGFloat)
    {
        
        self.presentNotificationWithMessage(message, inController: hostController, atDistanceFromTop: topDistance);

    }

}
