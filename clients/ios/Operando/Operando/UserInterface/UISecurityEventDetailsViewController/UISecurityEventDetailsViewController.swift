//
//  UISecurityEventDetailsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISecurityEventDetailsViewController: UITableViewController {

    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var securityEventTypeView: UISecurityEventTypeView?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var detailsURLLabel: UILabel?
    
    
    private var securityEvent: SecurityEventProtocol?
    
    
    func displaySecurityEvent(event: SecurityEventProtocol, forAddress address: String)
    {
        let _ = self.view
        
        self.securityEvent = event
        self.addressLabel?.text = address
        self.descriptionLabel?.text = event.description
        self.detailsURLLabel?.text = event.detailsURL
        self.titleLabel?.text = event.title
        self.securityEventTypeView?.displaySecurityEventType(event.securityEventTag)
        
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func didTapOnDetailsURLLabel(sender: AnyObject)
    {
        guard let urlString = self.securityEvent?.detailsURL else {return}
        guard let url = NSURL(string: urlString) else {return}
        
        if UIApplication.sharedApplication().canOpenURL(url)
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}
