//
//  UIExternalConnectionInfoCell.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIExternalConnectionInfoCell: UITableViewCell
{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ipInfoView: UIIPInfoView!
    @IBOutlet weak var reportedEventsLabel: UILabel!
    
    func displayIPReport(info: IPReportProtocol)
    {
        self.addressLabel.text = info.address;
        self.ipInfoView.displayInfo(info.addressInfo);
        
        if info.numOfSecurityEvents > 0
        {
            self.reportedEventsLabel.text = "Number of reported events: \(info.numOfSecurityEvents)"
        }
        else
        {
            self.reportedEventsLabel.text = "No security events information available";
        }
    }
    
    static var identifierNibName: String
    {
        return "UIExternalConnectionInfoCell";
    }
    
    static var desiredHeight: CGFloat
    {
        return 230;
    }
}
