//
//  UIIdentitiesListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

let kMakeDefaultLocalizableKey = "kMakeDefaultLocalizableKey"
let kDeleteLocalizableKey = "kDeleteLocalizableKey"

typealias IdentityIndexCallback = ((_ item: String, _ index: Int ) -> Void)

struct UIIdentitiesListCallbacks
{
    let whenPressedToDeleteItemAtIndex: IdentityIndexCallback?
    let whenActivatedItem: ((_ item: String) -> Void)?
    
}



class UIIdentitiesListView: RSNibDesignableView, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate
{
    
    private var identitiesList: [String] = []
    private var callbacks: UIIdentitiesListCallbacks?
    private var currentDefaultIdentity: String = ""
    private var currentDefaultIdentityIndex: Int {
        return self.identitiesList.index(of: self.currentDefaultIdentity) ?? -1
    }
    
    @IBOutlet var tableView: UITableView?
    
    override func commonInit() {
        super.commonInit()
        self.setupTableView(tableView: self.tableView)
    }
    
    private func setupTableView(tableView: UITableView?)
    {
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let nib = UINib(nibName: UIIdentityCell.identifierNibName, bundle: nil);
        
        tableView?.register(nib, forCellReuseIdentifier: UIIdentityCell.identifierNibName);
        tableView?.rowHeight = 50;
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
    }
    
    func setupWith(initialList: [String], defaultIdentityIndex: Int?, andCallbacks callbacks: UIIdentitiesListCallbacks?)
    {
        self.callbacks = callbacks
        
        guard let first = initialList.first else {
            return
        }
        
        self.identitiesList = initialList
        
        if let defaultIdentityIndex = defaultIdentityIndex {
            let defaultIdentity = initialList[defaultIdentityIndex]
            if defaultIdentityIndex != 0 {
                self.identitiesList.remove(at: defaultIdentityIndex)
                self.identitiesList.remove(at: 0)
                
                self.identitiesList.insert(defaultIdentity, at: 0)
                self.identitiesList.insert(first, at: defaultIdentityIndex)
            }
            self.currentDefaultIdentity = defaultIdentity
        }
        
        self.tableView?.reloadData()
    }
    
    
    func appendAndDisplayNew(item: String)
    {
        self.identitiesList.append(item)
        self.tableView?.insertRows(at: [IndexPath(row: self.identitiesList.count-1, section: 0)], with: .automatic)
    }
    
    func deleteItemAt(index: Int)
    {
        self.identitiesList.remove(at: index)
        self.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func displayAsDefault(identity: String)
    {
        self.currentDefaultIdentity = identity
        self.tableView?.reloadData()
        
    }
    
    //MARK: tableView delegate and dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.identitiesList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UIIdentityCell.identifierNibName) as! UIIdentityCell
        
        
        let style: UIIdentityCellStyle = (indexPath.row == self.currentDefaultIdentityIndex) ? .selected : .normal
        
        cell.setupWithIdentity(identity: self.identitiesList[indexPath.row], style: style)
        cell.delegate = self
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UIIdentityCell else {
            return
        }
        
        cell.showSwipe(MGSwipeDirection.rightToLeft, animated: true)
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell!, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [Any]!
    {
        guard direction == MGSwipeDirection.rightToLeft,
              let indexPath = self.tableView?.indexPath(for: cell) else {
            return []
        }
        
        weak var weakSelf = self
        let identity = self.identitiesList[indexPath.row]
        
        let deleteButton = MGSwipeButton(title: Bundle.localizedStringFor(key: kDeleteLocalizableKey), backgroundColor: UIColor.red) { swipeCell -> Bool in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                guard let maybeChangedIndexPath = weakSelf?.tableView?.indexPath(for: swipeCell!) else {
                    return
                }
                weakSelf?.callbacks?.whenPressedToDeleteItemAtIndex?(identity, maybeChangedIndexPath.row)
            })
        
            return true
        }
        
        let defaultButton = MGSwipeButton(title: Bundle.localizedStringFor(key: kMakeDefaultLocalizableKey), backgroundColor: UIColor.operandoCyan) { swipeCell -> Bool in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                weakSelf?.callbacks?.whenActivatedItem?(identity)
            })
            
            
            return true
        }
        
        if identity == self.currentDefaultIdentity {
            return [deleteButton!]
        }
        
        return [defaultButton!, deleteButton!]
    }
}
