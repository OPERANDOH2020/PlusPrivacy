//
//  UIWebTabsListView.swift
//  Operando
//
//  Created by Costin Andronache on 3/20/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit

struct UIWebTabsViewCallbacks {
    let whenUserPressedClose: VoidBlock?
    let whenUserAddsNewTab: VoidBlock?
    let whenUserSelectedTabAtIndex: ((_ index: Int) -> Void)?
    let whenUserDeletedTabAtIndex: ((_ index: Int) -> Void)?
}

class UIWebTabsListView: RSNibDesignableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var webTabs: [WebTabDescription] = []
    private var callbacks: UIWebTabsViewCallbacks?
    
    var inBusyState: Bool = false {
        didSet {
            self.activityIndicator.isHidden = !self.inBusyState
            self.isUserInteractionEnabled = !self.inBusyState
        }
    }
    
    override func commonInit() {
        super.commonInit()
        self.setupCollectionView(cv: self.collectionView)
    }
    
    func setupWith(webTabs: [WebTabDescription], callbacks: UIWebTabsViewCallbacks?){
        self.callbacks = callbacks
        self.webTabs = webTabs
        self.collectionView.reloadData()
    }
    
    
    
    private func setupCollectionView(cv: UICollectionView) {
        cv.delegate = self
        cv.dataSource = self
        let nib = UINib(nibName: UIWebTabCollectionCell.identifierNibName, bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: UIWebTabCollectionCell.identifierNibName)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.webTabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIWebTabCollectionCell.identifierNibName, for: indexPath) as? UIWebTabCollectionCell
        
        weak var weakSelf = self
        weak var weakCell = cell
        
        cell?.setupWith(webTabDescription: self.webTabs[indexPath.item], whenClosePressed: {
            guard let strongCell = weakCell, let cellIdxPath = weakSelf?.collectionView.indexPath(for: strongCell) else {
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
        let space: CGFloat = 10 + 10 + 6;
        return CGSize(width: (self.frame.width - space) / 2, height: self.frame.size.height * 0.4)
    }
    
    private func deleteTabAt(indexPath: IndexPath){
        self.webTabs.remove(at: indexPath.item)
        
        self.collectionView.deleteItems(at: [indexPath])
        self.callbacks?.whenUserDeletedTabAtIndex?(indexPath.item)
    }
    
    @IBAction func didPressClose(_ sender: Any) {
        self.callbacks?.whenUserPressedClose?()
    }
    
    @IBAction func didPressToAdd(_ sender: Any) {
        self.callbacks?.whenUserAddsNewTab?()
    }
}
