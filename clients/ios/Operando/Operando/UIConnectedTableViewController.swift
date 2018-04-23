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

class UIConnectedTableViewController: UITableViewController, WKNavigationDelegate, WKUIDelegate, ConnectedAppExpandedCellDelegate{
    
    private var selectedIndexPath: IndexPath?
    private var webView: WKWebView = WKWebView(frame: .zero)
    private var dataSource: [ConnectedApp] = []
    
    private var loadAppsUrl = {}
    private var isLoggedInApp = false
    private var removeApp: String?
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
        
        if  ACPrivacyWizard.shared.selectedScope == .twitter {
            self.webView.customUserAgent = MozillaUserAgentId
        }
        
        self.webView.loadWebViewToURL(urlString: socialMediaUrl)
        
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
            cell?.delegate = self
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
    
    // MARK: - JS Utilis
    
    func getApps() {
        
        self.webView.loadJQuerry(completion: {
            
            self.webView.loadJSFile(scriptName: "RegexUtils", withCompletion: { (_, regexUtilsInseretionError) in
                
                let scriptName = ACPrivacyWizard.shared.selectedScope.getNetworks().first! + "_apps"
                
                self.webView.loadJSFile(scriptName: scriptName, withCompletion: { (data, isloggedError) in
                    
                })
            })
        })
    }
    
    private func removeApp(appID: String){
        
        let newData = self.dataSource.filter({ (app) -> Bool in
            if app.appId == appID {
                return false
            }
            
            return true
        })
        
        self.dataSource = newData
        self.tableView.reloadData()
        ProgressHUD.dismiss()
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
    
    func insertUnistallAppJS(appID:String, completion:@escaping VoidBlock){
        
        let script =  "remove_" + ACPrivacyWizard.shared.selectedScope.getNetworks().first! + "_app"
        
        self.webView.loadJSFile(scriptName: "RegexUtils", withCompletion: { (_, regexUtilsInseretionError) in
            self.webView.loadAndExecuteScriptNamed(scriptName: script, stringToReplace: "LOCAL_APP_ID", with: appID) { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                completion()
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
            //            print("MESSAGE DICT: " + messageDict.debugDescription)
            
            if let type = messageDict.object(forKey: "messageType") as? String {
                
                if type == "statusMessageType" {
                    
                    self.getConnectedApps(dict: messageDict)
                }
                else if type == "statusDoneMessageType" {
                    
                    if let removeApp = removeApp {
                        self.removeApp(appID: removeApp)
                        self.removeApp = nil
                    }
                }
            }
        }
    }
    
    private func getConnectedApps(dict: NSDictionary) {
        
        if dict.toConnectedApps().count == 0 {
            return
        }
        
        self.dataSource = dict.toConnectedApps()
        ProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    // MARK: - WebView Delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if let appID = self.removeApp {
            self.insertUnistallAppJS(appID: appID) {
                self.removeApp = appID
            }
            return
        }
        
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
    
    // MARK: - ConnectedAppExpandedCellDelegate
    
    func unistallApp(appID: String) {
        ProgressHUD.show()
        self.removeApp = appID
        
        if  ACPrivacyWizard.shared.selectedScope == .facebook {
            self.webView.customUserAgent = MozillaUserAgentId2
            let socialMediaUrl = ACPrivacyWizard.shared.selectedScope.getAppsListUrl()
            self.webView.loadWebViewToURL(urlString: socialMediaUrl)
        }
        else {
            self.webView.reload()
        }  
    }
}

