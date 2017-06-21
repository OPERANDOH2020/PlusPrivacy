//
//  UINotificationsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UINotificationsViewController: UIViewController {

    @IBOutlet var notificationViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didChangeDecisionOnNotifications(sender: UISwitch)
    {
        if sender.on
        {
            OPViewUtils.enbleViews(self.notificationViews);
        }
        else
        {
            OPViewUtils.disableViews(self.notificationViews)
        }
    }
    

}
