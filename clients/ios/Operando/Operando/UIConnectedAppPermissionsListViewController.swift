//
//  UIConnectedAppPermissionsListViewController.swift
//  Operando
//
//  Created by Cristi Sava on 19/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class UIConnectedAppPermissionsListViewController: UITableViewController {
    private var dataSource: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ConnectedAppCell", bundle: nil), forCellReuseIdentifier: ConnectedAppCell.identifier)
        tableView.separatorStyle = .none
    }

    func setupWithPermissions(permissions: [String]){
        self.dataSource = permissions
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConnectedAppCell.identifier) as? ConnectedAppCell else {
            return UITableViewCell()
        }
        
        cell.setupWithPermisions(permission: self.dataSource[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

}
