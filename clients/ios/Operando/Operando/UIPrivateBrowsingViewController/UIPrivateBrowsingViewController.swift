//
//  UIPrivateBrowsingViewController.swift
//  Operando
//
//  Created by Costin Andronache on 6/7/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit

let kSearchEngineURL = "https://www.duckduckgo.com"
let queryURLPart = "\(kSearchEngineURL)/?q="

class WebTab {
    var webTabDescription: WebTabDescription?
    var navigationModel: UIWebViewTabNavigationModel?
}

class UIPrivateBrowsingViewController: UIViewController, WKNavigationDelegate
{
    @IBOutlet weak var webTabsView: UIWebTabsListView!
    @IBOutlet weak var webTabsViewTopCn: NSLayoutConstraint!
    @IBOutlet weak var webTabsHostView: UIView!
    
    private var logic: WebTabsControllerLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabsViewTopConstraint(to: UIScreen.main.bounds.height)
        weak var weakSelf = self
        
        
        
        let callbacks: WebTabsControllerLogicCallbacks = WebTabsControllerLogicCallbacks(hideWebViewTabCallback: nil, showWebViewTabCallback: { webViewTab, animated, completion in
            weakSelf?.webTabsHostView.bringSubview(toFront: webViewTab)
            completion?()
            
        }, hideWebTabsView: { _, _, completion in
            weakSelf?.setTabsViewTopConstraint(to: UIScreen.main.bounds.height, animated: true)
            completion?()
            
        }, showWebTabsViewOnTop: { _, _, completion  in
            weakSelf?.setTabsViewTopConstraint(to: 0, animated: true)
            completion?()
            
        }, addNewWebViewTabCallback:{ () -> UIWebViewTab in
            let newTab = UIWebViewTab(frame: .zero)
            if let webTabHostView = weakSelf?.webTabsHostView {
                UIView.constrainView(view: newTab, inHostView: webTabHostView)
            }
            return newTab
        }, presentAlertController: {
            weakSelf?.present($0, animated: true, completion: nil)
        })
        
        
        let model = WebTabsControllerLogicModel(webTabsView: self.webTabsView,
                                                maxNumberOfReusableWebViews: 6,
                                                webPool: WebViewTabManagementPool())
        
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
    }
    
    //MARK:

    private func setTabsViewTopConstraint(to value: CGFloat, animated: Bool = false) {
        self.webTabsViewTopCn.constant = value;
        self.view.setNeedsLayout()
        let block: VoidBlock = {
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: block, completion: nil)
        } else {
            block()
        }
    }
    
}
