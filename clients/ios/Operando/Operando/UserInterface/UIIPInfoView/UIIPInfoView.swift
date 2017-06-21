//
//  UIIPInfoView.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIPInfoView: RSNibDesignableView
{
    
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
    
    func displayInfo(info: IPInfoProtocol)
    {
        let NA = "N/A"
        self.organizationLabel.text = info.organization ?? NA
        self.cityLabel.text = info.city ?? NA
        self.locationLabel.text = info.locationCoordinates ?? NA
        self.hostnameLabel.text = info.hostname ?? NA
        self.countryLabel.text = info.country ?? NA
        self.regionLabel.text = info.region ?? NA
       
    }
}
