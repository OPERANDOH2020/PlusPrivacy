//
//  UISecurityEventsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISecurityEventsViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var securityEventsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var ipReport: IPReportProtocol?
    private var reportedSecurityEvents: [SecurityEventProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(self.tableView)
    }
    
    func setupWithIPReport(report: IPReportProtocol)
    {
        let _ = self.view;
        let ip = report.address
        self.ipReport = report;
        
        self.securityEventsLabel.text = "The following security events have been reported for \(ip) by Cymon.io";
        self.tableView.reloadData()
    }
    
    private func setupTableView(tv: UITableView)
    {
        let nib = UINib(nibName: UISecurityEventCell.idenitiferNibName, bundle: nil)
        tv.registerNib(nib, forCellReuseIdentifier: UISecurityEventCell.idenitiferNibName)
        tv.dataSource = self
        tv.delegate = self
        tv.estimatedRowHeight = 170;
    }
    
    private func displayDetailsForSecurityEvent(event: SecurityEventProtocol)
    {
        guard let ip = self.ipReport?.address else {return}
        
        let vc = UINavigationManager.securityEventDetailsViewController;
        vc.displaySecurityEvent(event, forAddress: ip);
        
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: -tableView datasource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportedSecurityEvents.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UISecurityEventCell.idenitiferNibName) as! UISecurityEventCell
        
        
        cell.setupWithSecurityEvent(self.reportedSecurityEvents[indexPath.row]);
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer
        {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
        
        
        self.displayDetailsForSecurityEvent(self.reportedSecurityEvents[indexPath.row]);
    }
}
