//
//  UISNSettingsView.swift
//  Operando
//
//  Created by Costin Andronache on 8/12/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UISNSettingsView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate
{
    
    private var items: [SettingsReadResult] = [];
    
    @IBOutlet var tableView: UITableView!
    
    
    override func commonInit() {
        super.commonInit()
        self.setupTableView(self.tableView)
    }
    
    func reloadWithItems(items: [SettingsReadResult])
    {
        self.items = items;
        self.tableView.reloadData()
    }
    
    private func setupTableView(tv: UITableView)
    {
        let nib = UINib(nibName: UISNSettingsTableViewCell.identifierNibName, bundle: nil)
        tv.registerNib(nib, forCellReuseIdentifier: UISNSettingsTableViewCell.identifierNibName)
        tv.delegate = self
        tv.dataSource = self
        
    }
    
    
    
    //TableView delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].siteName
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let item = self.items[section]
        return item.resultsPerSettingName.count
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UISNSettingsTableViewCell.identifierNibName) as! UISNSettingsTableViewCell
        
        let item = self.items[indexPath.section]
        let keys = Array(item.resultsPerSettingName.keys)
        let dict = item.resultsPerSettingName[ keys[indexPath.row] ]
        cell.setupWithSNSettingsDict(dict ?? [:])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
