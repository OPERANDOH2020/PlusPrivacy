//
//  UIIdentityManagementViewController.swift
//  Operando
//
//  Created by Costin Andronache on 4/27/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIIdentityManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    private var identitiesList : [String] = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.identitiesList = self.dummyIdentities();
        self.setupTableView(self.tableView);
    }
    
    
    private func setupTableView(tableView: UITableView?)
    {
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let nib = UINib(nibName: UIIdentityCell.identifierNibName, bundle: nil);
        
        tableView?.registerNib(nib, forCellReuseIdentifier: UIIdentityCell.identifierNibName);
        tableView?.rowHeight = 44;
    }
    
    //MARK: IBActions
    
    @IBAction func didPressToAddNewSID(sender: AnyObject)
    {
        let item = "rr0ky5p1c0@operando7.eu";
        self.addNewItem(item);
        self.displayAlertForItem(item, withTitle: "New SID generated", addCancelAction: false, withConfirmation: nil);
    }
    
    
    //MARK: tableView delegate / datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.identitiesList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIIdentityCell.identifierNibName) as! UIIdentityCell
        
        let index = indexPath.row;
        weak var weakSelf = self;
        
        weak var  weakCell = cell;
        weak var  weakTV = tableView;
        cell.setupWithIdentity(self.identitiesList[index])
        {
            if let tvCell = weakCell, tvCellIndexPath = weakTV?.indexPathForCell(tvCell)
            {
                weakSelf?.deleteItemAtIndex(tvCellIndexPath.row);
            }
        }
        
        return cell;
    }
    
    
    
    //MARK: helper
    
    
    private func displayAlertForItem(item: String, withTitle title: String, addCancelAction:Bool, withConfirmation confirmation: (() -> ())?)
    {
        let alert = UIAlertController(title: title, message: item, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
            confirmation?();
        }
        alert.addAction(okAction);
        
        if addCancelAction
        {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil);
            alert.addAction(cancelAction);
        }
        
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    private func deleteItemAtIndex(index: Int)
    {
        let sid = self.identitiesList[index];
        
        self.displayAlertForItem(sid, withTitle: "Do you want to delete this SID?", addCancelAction: true) {
            if let index = self.identitiesList.indexOf(sid)
            {
                self.identitiesList.removeAtIndex(index);
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade);
            }
        }
    }
    
    
    private func addNewItem(item: String)
    {
        self.identitiesList.append(item);
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.identitiesList.count-1, inSection: 0)], withRowAnimation: .Right);
    }
    
    private func dummyIdentities() -> [String]
    {
        return ["g67ash@operando.eu",
                "jd8skg@operando.eu",
                "9dsfdsg8@operando.eu"];
    }
}
