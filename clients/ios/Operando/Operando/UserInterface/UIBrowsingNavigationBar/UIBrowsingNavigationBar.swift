//
//  UIBrowsingNavigationBar.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct UIBrowsingNavigationBarCallbacks {
    let whenUserPressedBack: (() -> Void)?
    let whenUserPressedSearchWithString: ((_ searchString: String) -> Void)?
}

class UIBrowsingNavigationBar: RSNibDesignableView, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    private var callbacks: UIBrowsingNavigationBarCallbacks?
    
    override func commonInit() {
        super.commonInit()
        searchBar.delegate = self
    }
    
    @IBAction func didPressBackButton(_ sender: AnyObject)
    {
        self.callbacks?.whenUserPressedBack?()
    }
    
    
    @IBAction func didPressSearchButton(_ sender: AnyObject)
    {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text
        {
            self.callbacks?.whenUserPressedSearchWithString?(searchText)
        }
        
        searchBar.endEditing(true)
    }
    
    
    func setupWithCallbacks(callbacks: UIBrowsingNavigationBarCallbacks?)
    {
        self.callbacks = callbacks;
    }
}
