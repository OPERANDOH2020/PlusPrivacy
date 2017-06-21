//
//  UISensorMonitoringViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISensorMonitoringViewController: UIViewController {

    @IBOutlet var sensorMonitoringViews: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didChangeDecisionOnMonitoring(sender: UISwitch)
    {
        if sender.on
        {
            OPViewUtils.enbleViews(self.sensorMonitoringViews);
        }
        else
        {
            OPViewUtils.disableViews(self.sensorMonitoringViews);
        }
    }
    
    


}
