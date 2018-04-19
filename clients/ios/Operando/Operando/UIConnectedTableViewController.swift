//
//  UIConnectedTableViewController.swift
//  Operando
//
//  Created by RomSoft on 4/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit
import WebKit

struct UIConnectedTableViewControllerCallbacks {
    
    let showPermissions: ConnectedAppPermissions?
}


class UIConnectedTableViewController: UITableViewController, WKNavigationDelegate, WKUIDelegate{
    
    private var selectedIndexPath: IndexPath?
    private var webView: WKWebView = WKWebView(frame: .zero)
    private var dataSource: [ConnectedApp] = []
    
    private var loadAppsUrl = {}
    private var isLoggedInApp = false
    private var callbacks: UIConnectedTableViewControllerCallbacks?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ConnectedAppCell", bundle: nil), forCellReuseIdentifier: ConnectedAppCell.identifier)
        tableView.register(UINib(nibName: "ConnectedAppExpandedCell", bundle: nil), forCellReuseIdentifier: ConnectedAppExpandedCell.identifier)
        tableView.separatorStyle = .none
        self.webView.isHidden = true
        webView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
        
        loadAppsUrl = {
            let socialMediaUrl = ACPrivacyWizard.shared.selectedScope.getAppsListUrl()
            self.webView.loadWebViewToURL(urlString: socialMediaUrl)
            self.isLoggedInApp = true
            self.loadAppsUrl = {}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(webView)
        ProgressHUD.show()
    }
    
    func setupFor(type: ACPrivacyWizardScope?,callbacks: UIConnectedTableViewControllerCallbacks){
        
        if let type = type {
            
            ACPrivacyWizard.shared.selectedScope = type
        }
        
        let socialMediaUrl = ACPrivacyWizard.shared.selectedScope.getNetworkUrl()
        
        self.webView.loadWebViewToURL(urlString: socialMediaUrl)
        
        if  ACPrivacyWizard.shared.selectedScope == .twitter {
            self.webView.customUserAgent = MozillaUserAgentId
        }
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.callbacks = callbacks
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let selectedIndex = self.selectedIndexPath,
            selectedIndex == indexPath {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ConnectedAppExpandedCell.identifier) as? ConnectedAppExpandedCell
            cell?.setupWith(app: dataSource[indexPath.row], callbacks: self.callbacks!)
            return cell!
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConnectedAppCell.identifier) as? ConnectedAppCell else {
                return UITableViewCell()
            }
            
            cell.setupWith(app: dataSource[indexPath.row])
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedIndexPath == indexPath {
            return
        }
        
        self.selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndexPath == indexPath {
            return 189
        }
        return 87
    }
    
    func getApps() {
        
        self.webView.loadJQuerry(completion: {
            
            self.webView.loadJSFile(scriptName: "RegexUtils", withCompletion: { (_, regexUtilsInseretionError) in
                
                let scriptName = ACPrivacyWizard.shared.selectedScope.getNetworks().first! + "_apps"
                
                self.webView.loadJSFile(scriptName: scriptName, withCompletion: { (data, isloggedError) in
                    
                })
            })
        })
    }
    
    func checkIfLoggedIn(_ completionHandler: @escaping CallbackWithBool ){
        let isLoggedScript =  ACPrivacyWizard.shared.selectedScope.getNetworks().first! + "_is_logged"
        
        self.webView.loadJSFile(scriptName: isLoggedScript, withCompletion: { (islogged, isloggedError) in
            
            if let islogged = islogged as? String,
                islogged == "true" {
                completionHandler(true)
            }
            else {
                completionHandler(false)
            }
        })
    }
    
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler()
        print("MESSAGE: " + message)
        
        if let data = message.data(using: String.Encoding.utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let messageDict = jsonObject as? NSDictionary
        {
            print("MESSAGE DICT: " + messageDict.debugDescription)
            
            self.getConnectedApps(dict: messageDict)
        }
    }
    
    private func getConnectedApps(dict: NSDictionary) {

        self.dataSource = dict.toConnectedApps()
        ProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    // MARK: - WebView Delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.isLoggedInApp == true {
            
            ProgressHUD.show()
            self.getApps()
            return
        }

        checkIfLoggedIn { (isLogged) in
            if isLogged == true {
                print("LOGGED IN")
                self.webView.isHidden = true
                self.loadAppsUrl()
            }
            else {
                print("NOT LOGGED IN")
                ProgressHUD.dismiss()
                self.webView.isHidden = false
            }
        }
    }
}

