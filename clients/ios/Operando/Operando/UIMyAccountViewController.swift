//
//  UIMyAccountViewController.swift
//  Operando
//
//  Created by RomSoft on 12/21/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct UIMyAccountViewControllerOutlets {
    let tableView: UITableView?
    
    static let allNil: UIMyAccountViewControllerOutlets = UIMyAccountViewControllerOutlets(tableView: nil)
}

struct UIMyAccountViewControllerLogicCallbacks {

}

class UIMyAccountViewControllerLogic: NSObject, UITableViewDelegate, UITableViewDataSource {
    let outlets: UIMyAccountViewControllerOutlets
    let logicCallbacks: UIMyAccountViewControllerLogicCallbacks?
    
    init(outlets: UIMyAccountViewControllerOutlets, logicCallbacks: UIMyAccountViewControllerLogicCallbacks?) {
        self.outlets = outlets;
        self.logicCallbacks = logicCallbacks
        super.init()
        self.setupTableView()
    }
    
    private func setupTableView(){
        //register cells
        
    }

}

class UIMyAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private(set) lazy var logic: UIMyAccountViewControllerLogic = {
        
        let outlets: UIMyAccountViewControllerOutlets = UIMyAccountViewControllerOutlets(tableView: self.tableView)
        let callBacks: UIMyAccountViewControllerLogicCallbacks = UIMyAccountViewControllerLogicCallbacks()
        
        return UIMyAccountViewControllerLogic(outlets: outlets, logicCallbacks: callBacks)
         
    }()
    
}
