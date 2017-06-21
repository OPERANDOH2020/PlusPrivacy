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
    let whenUserPressedSearchWithString: ((searchString: String) -> Void)?
}

class UIBrowsingNavigationBar: RSNibDesignableView, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    private var callbacks: UIBrowsingNavigationBarCallbacks?
    
    override func commonInit() {
        super.commonInit()
        searchBar.delegate = self
    }
    
    @IBAction func didPressBackButton(sender: AnyObject)
    {
        self.callbacks?.whenUserPressedBack?()
    }
    
    
    @IBAction func didPressSearchButton(sender: AnyObject)
    {
        self.searchBarSearchButtonClicked(self.searchBar)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if let searchText = searchBar.text
        {
            self.callbacks?.whenUserPressedSearchWithString?(searchString: searchText)
        }
        
        searchBar.endEditing(true)
    }
    
    
    
    
    func setupWithCallbacks(callbacks: UIBrowsingNavigationBarCallbacks?)
    {
        self.callbacks = callbacks;
    }
}
