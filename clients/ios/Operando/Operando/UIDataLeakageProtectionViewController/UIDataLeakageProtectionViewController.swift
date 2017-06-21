//
//  UIDataLeakageProtectionViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIDataLeakageProtectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    private var certifiedAppsModels: [CertifiedAppModel] = [];
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.certifiedAppsModels = self.dummyAppModels();
        self.setupTableView(self.tableView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    private func setupTableView(tableView: UITableView?)
    {
        let nib = UINib(nibName: UICertifiedApplicationCell.identifierNibName, bundle: nil);
        
        tableView?.registerNib(nib, forCellReuseIdentifier: UICertifiedApplicationCell.identifierNibName);
        
        tableView?.dataSource = self;
        tableView?.delegate = self;
        tableView?.rowHeight = 54;
    }
    
    private func dummyAppModels () -> [CertifiedAppModel]
    {
        var models = [CertifiedAppModel]();
        
        models.append(CertifiedAppModel(appName: "Photosphere", appVersion: "v1.1.0"))
        
        models.append(CertifiedAppModel(appName: "Big Bang App", appVersion: "v1.0.0"));
        
        models.append(CertifiedAppModel(appName: "Ultra security app", appVersion: "v1.0.0"));
        
        return models;
    }
    
    //MARK: tableView delegate & datasource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.certifiedAppsModels.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCellWithIdentifier(UICertifiedApplicationCell.identifierNibName) as! UICertifiedApplicationCell
        
        let model = self.certifiedAppsModels[indexPath.row];
        cell.setupWithModel(model);
        
        return cell;
    }
}
