//
//  UIWebTabsListView.swift
//  Operando
//
//  Created by Costin Andronache on 3/20/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct UIWebTabsListViewCallbacks {
    let whenUserPressedClose: VoidBlock?
    let whenUserAddsNewTab: VoidBlock?
    let whenUserSelectedTabAtIndex: ((_ index: Int) -> Void)?
    let whenUserDeletedTabAtIndex: ((_ index: Int) -> Void)?
}


struct UIWebTabsListViewOutlets {
    let collectionView: UICollectionView?
    let activityIndicator: UIActivityIndicatorView?
    let addButton: UIButton?
    let closeButton: UIButton?
    let containerView: UIView?
    
    static let allNil: UIWebTabsListViewOutlets = UIWebTabsListViewOutlets(collectionView: nil, activityIndicator: nil, addButton: nil, closeButton: nil, containerView: nil)
    
    static var allDefault: UIWebTabsListViewOutlets {
        return UIWebTabsListViewOutlets(collectionView: UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()), activityIndicator: .init(), addButton: .init(), closeButton: .init(), containerView: .init())
    }
}

class UIWebTabsListViewLogic: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let outlets: UIWebTabsListViewOutlets

    
    private var webTabs: [WebTabDescription] = []
    private var callbacks: UIWebTabsListViewCallbacks?
    
    var inBusyState: Bool = false {
        didSet {
            outlets.activityIndicator?.isHidden = !self.inBusyState
            outlets.containerView?.isUserInteractionEnabled = !self.inBusyState
        }
    }
    
    init(outlets: UIWebTabsListViewOutlets) {
        self.outlets = outlets;
        super.init()
        
        self.setupCollectionView(cv: outlets.collectionView)
        outlets.addButton?.addTarget(self, action: #selector(didPressToAdd(_:)), for: .touchUpInside)
        outlets.closeButton?.addTarget(self, action: #selector(didPressClose(_:)), for: .touchUpInside)
        
        outlets.activityIndicator?.isHidden = true
    }
    
    func setupWith(webTabs: [WebTabDescription], callbacks: UIWebTabsListViewCallbacks?){
        self.callbacks = callbacks
        self.webTabs = webTabs
        outlets.collectionView?.reloadData()
    }
    
    
    
    private func setupCollectionView(cv: UICollectionView?) {
        cv?.delegate = self
        cv?.dataSource = self
        let nib = UINib(nibName: UIWebTabCollectionCell.identifierNibName, bundle: nil)
        cv?.register(nib, forCellWithReuseIdentifier: UIWebTabCollectionCell.identifierNibName)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.webTabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIWebTabCollectionCell.identifierNibName, for: indexPath) as? UIWebTabCollectionCell
        
        weak var weakSelf = self
        weak var weakCell = cell
        
        cell?.setupWith(webTabDescription: self.webTabs[indexPath.item], whenClosePressed: {
            guard let strongCell = weakCell, let cellIdxPath = weakSelf?.outlets.collectionView?.indexPath(for: strongCell) else {
                return
            }
            weakSelf?.deleteTabAt(indexPath: cellIdxPath)
        })
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        self.callbacks?.whenUserSelectedTabAtIndex?(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let containerView = self.outlets.containerView else {
            return .zero
        }
        let space: CGFloat = 10 + 10 + 6;
        return CGSize(width: (containerView.frame.width - space) / 2, height: containerView.frame.size.height * 0.4)
    }
    
    private func deleteTabAt(indexPath: IndexPath){
        self.webTabs.remove(at: indexPath.item)
        
        self.outlets.collectionView?.deleteItems(at: [indexPath])
        self.callbacks?.whenUserDeletedTabAtIndex?(indexPath.item)
    }
    
    @IBAction func didPressClose(_ sender: Any) {
        self.callbacks?.whenUserPressedClose?()
    }
    
    @IBAction func didPressToAdd(_ sender: Any) {
        self.callbacks?.whenUserAddsNewTab?()
    }

    
}

class UIWebTabsListView: RSNibDesignableView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private(set) lazy var logic: UIWebTabsListViewLogic = {
        let outlets: UIWebTabsListViewOutlets = UIWebTabsListViewOutlets(collectionView: self.collectionView, activityIndicator: self.activityIndicator, addButton: self.addButton, closeButton: self.closeButton, containerView: self.contentView)
        
        return UIWebTabsListViewLogic(outlets: outlets)
    }()
    
}
