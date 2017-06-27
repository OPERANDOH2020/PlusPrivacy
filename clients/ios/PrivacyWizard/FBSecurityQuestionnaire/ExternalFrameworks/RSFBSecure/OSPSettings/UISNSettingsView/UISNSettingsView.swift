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
        self.setupTableView(tv: self.tableView)
    }
    
    func reloadWithItems(items: [SettingsReadResult])
    {
        self.items = items;
        self.tableView.reloadData()
    }
    
    private func setupTableView(tv: UITableView)
    {
        let nib = UINib(nibName: UISNSettingsTableViewCell.identifierNibName, bundle: nil)
        tv.register(nib, forCellReuseIdentifier: UISNSettingsTableViewCell.identifierNibName)
        tv.delegate = self
        tv.dataSource = self
        
    }
    
    
    
    //TableView delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].siteName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let item = self.items[section]
        return item.resultsPerSettingName.count
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UISNSettingsTableViewCell.identifierNibName) as! UISNSettingsTableViewCell
        
        let item = self.items[indexPath.section]
        let keys = Array(item.resultsPerSettingName.keys)
        let dict = item.resultsPerSettingName[ keys[indexPath.row] ]
        cell.setupWithSNSettingsDict(snSettings: dict ?? [:])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
