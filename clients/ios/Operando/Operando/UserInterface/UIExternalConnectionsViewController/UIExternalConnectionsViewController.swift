//
//  UIExternalConnectionsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIExternalConnectionsViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var scanningView: UIScanningView!
    var refreshControl: UIRefreshControl?
    //private var connectionReports: [IPReportProtocol] = []
    private var connectionReportsPerDate: [ NSDate : [IPReportProtocol] ] = [:]
    private var connectionDatesSorted: [NSDate] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(self.tableView)
        self.setupScanningView(self.scanningView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.reloadData()
    }
    
    private func setupTableView(tableView: UITableView)
    {
        let nib = UINib(nibName: UIExternalConnectionInfoCell.identifierNibName, bundle: nil);
        tableView.registerNib(nib, forCellReuseIdentifier: UIExternalConnectionInfoCell.identifierNibName);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = UIExternalConnectionInfoCell.desiredHeight;
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(self.refreshControl!)
    }
    
    
    private func displaySecurityEventsScreenIfAny(ipReport: IPReportProtocol)
    {
        guard ipReport.numOfSecurityEvents > 0 else {return}
        let vc = UINavigationManager.securityEventsViewController
        vc.setupWithIPReport(ipReport)
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    private func aggregateReportsPerCreationDate(reports: [IPReportProtocol]) -> [NSDate:[IPReportProtocol]]
    {
        var result: [NSDate : [IPReportProtocol]] = [:]
        
        for report in reports
        {
            let dateWithoutTime = report.createdDate.withoutTime()
            var reportsArray: [IPReportProtocol] = result[dateWithoutTime] ?? [];
            reportsArray.append(report);
            result[dateWithoutTime] = reportsArray;
        }
        
        return result;
    }
    
    private func sortedReportArraysByDate(map: [NSDate : [IPReportProtocol]]) -> [NSDate: [IPReportProtocol]]
    {
        var result = map;
        for (date, var array) in result
        {
            array.sortInPlace({ (a:IPReportProtocol, b:IPReportProtocol) -> Bool in
                return a.createdDate.compare(b.createdDate) == NSComparisonResult.OrderedDescending
            })
            
            result[date] = array
        }
        
        return result
    }
    
    private func sortedKeyDates(map: [NSDate: [IPReportProtocol]]) -> [NSDate]
    {
        return map.keys.sort({ (a:NSDate, b:NSDate) -> Bool in
            return a.compare(b) == NSComparisonResult.OrderedDescending
        })
    }
    
    private func setupScanningView(scanningView: UIScanningView)
    {
        weak var weakSelf = self;
        weak var weakScanningView = scanningView
        
        scanningView.whenPressingScanButton = {
            weakScanningView?.beginScanningState()
            
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 3))
            dispatch_after(delay, dispatch_get_main_queue(), { 
                weakSelf?.reloadData()
            })
        };
        
    }
    
    //MARK: -tableView datasource
    
    func reloadData()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        OPConfigObject.sharedInstance.getCurrentConnectionReportsProvider()?.getAllReportsWithCompletion({ (error, reports) in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
            let connectionReports = reports ?? [];
            self.connectionReportsPerDate = self.aggregateReportsPerCreationDate(connectionReports);
            self.connectionReportsPerDate = self.sortedReportArraysByDate(self.connectionReportsPerDate)
            self.connectionDatesSorted = self.sortedKeyDates(self.connectionReportsPerDate);
            
            self.tableView.reloadData()
            self.tableView.hidden = connectionReports.count == 0
            self.refreshControl?.endRefreshing()
        })
        

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.connectionDatesSorted.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.connectionDatesSorted[section].prettyPrinted()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let array = self.connectionReportsPerDate[self.connectionDatesSorted[section]] else {return 0}
        return array.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIExternalConnectionInfoCell.identifierNibName) as! UIExternalConnectionInfoCell
        
        if let reportsArray = self.connectionReportsPerDate[self.connectionDatesSorted[indexPath.section]]
        {
            cell.displayIPReport(reportsArray[indexPath.row])
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if let reportsArray = self.connectionReportsPerDate[self.connectionDatesSorted[indexPath.section]]
        {
            self.displaySecurityEventsScreenIfAny(reportsArray[indexPath.row]);
        }
        return false;
    }
    
    
    
}
