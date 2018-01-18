//
//  UIIdentitiesListView.swift
//  Operando
//
//  Created by Costin Andronache on 10/14/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit



typealias IdentityIndexCallback = ((_ item: String, _ index: Int ) -> Void)

struct UIIdentitiesListCallbacks {
    let whenPressedToDeleteItemAtIndex: IdentityIndexCallback?
    let whenActivatedItem: ((_ item: String) -> Void)?
    let copyToClickBoard: ((_ item: String) -> Void)?
}

struct UIIdentitiesListViewOutlets {
    let tableView: UITableView?
}

class UIIdentitiesListViewLogic: NSObject, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
    
    let outlets: UIIdentitiesListViewOutlets
    init(outlets: UIIdentitiesListViewOutlets) {
        self.outlets = outlets;
        super.init()
        self.setupTableView(tableView: outlets.tableView)
    }
    
    private(set) var identitiesList: [String] = []
    private var callbacks: UIIdentitiesListCallbacks?
    private var currentDefaultIdentity: String = ""
    
    private var currentDefaultIdentityIndex: Int {
        return self.identitiesList.index(of: self.currentDefaultIdentity) ?? -1
    }
    

    private func setupTableView(tableView: UITableView?) {
        tableView?.delegate = self;
        tableView?.dataSource = self;
        let nib = UINib(nibName: UIIdentityCell.identifierNibName, bundle: nil);
        
        tableView?.register(nib, forCellReuseIdentifier: UIIdentityCell.identifierNibName);
        tableView?.rowHeight = 50;
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
    }
    
    func setupWith(initialList: [String], defaultIdentityIndex: Int?, andCallbacks callbacks: UIIdentitiesListCallbacks?) {
        self.callbacks = callbacks
        self.identitiesList = initialList
        self.swapDefaultIdentityWithFirst(defaultIdentityIndex: defaultIdentityIndex, initialList: initialList)
        outlets.tableView?.reloadData()
    }
    
    
    private func swapDefaultIdentityWithFirst(defaultIdentityIndex: Int?, initialList: [String]){
        
        if let defaultIdentityIndex = defaultIdentityIndex {
            
            guard let first = initialList.first else {
                return
            }
            
            let defaultIdentity = initialList[defaultIdentityIndex]
            if defaultIdentityIndex != 0 {
                self.identitiesList.remove(at: defaultIdentityIndex)
                self.identitiesList.remove(at: 0)
                
                self.identitiesList.insert(defaultIdentity, at: 0)
                self.identitiesList.insert(first, at: defaultIdentityIndex)
            }
            self.currentDefaultIdentity = defaultIdentity
        }


    }
    
    func appendAndDisplayNew(item: String) {
        self.identitiesList.append(item)
        outlets.tableView?.insertRows(at: [IndexPath(row: self.identitiesList.count-1, section: 0)], with: .automatic)
    }
    
    func deleteItemAt(index: Int) {
        self.identitiesList.remove(at: index)
        outlets.tableView?.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func displayAsDefault(identity: String) {
//        guard self.identitiesList.contains(identity) else {
//            return
//        }
        self.currentDefaultIdentity = identity
        outlets.tableView?.reloadData()
        
    }
    
    //MARK: tableView delegate and dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == self.currentDefaultIdentityIndex {
            
            return 70
        }
        
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func swipeTableCell(_ cell: MGSwipeTableCell!, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [Any]! {
        guard direction == MGSwipeDirection.rightToLeft,
            let indexPath = outlets.tableView?.indexPath(for: cell) else {
                return []
        }
        
        weak var weakSelf = self
        let identity = self.identitiesList[indexPath.row]
        
        let deleteButton = MGSwipeButton(title: Bundle.localizedStringFor(key: kDeleteLocalizableKey), backgroundColor: UIColor.red) { swipeCell -> Bool in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                guard let maybeChangedIndexPath = weakSelf?.outlets.tableView?.indexPath(for: swipeCell!),
                let maybeChangedIdentity = weakSelf?.identitiesList[maybeChangedIndexPath.row]  else {
                    return
                }
                weakSelf?.callbacks?.whenPressedToDeleteItemAtIndex?(maybeChangedIdentity, maybeChangedIndexPath.row)
            })
            
            return true
        }
        
        let copyToClickBoard = MGSwipeButton(title: Bundle.localizedStringFor(key: kMakeLocalizableKey), backgroundColor: UIColor.identitiesBlue()) { swipeCell -> Bool in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                weakSelf?.callbacks?.copyToClickBoard?(identity)
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
        
        return [defaultButton!,copyToClickBoard,deleteButton!]
    }
    
}

class UIIdentitiesListView: RSNibDesignableView {
    @IBOutlet var tableView: UITableView?
    
    private(set) lazy var logic: UIIdentitiesListViewLogic = {
       return UIIdentitiesListViewLogic(outlets: UIIdentitiesListViewOutlets(tableView: self.tableView))
    }()
}
