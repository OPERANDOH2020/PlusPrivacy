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
    @IBOutlet weak var webToolbarView: UIWebToolbarView!
    @IBOutlet weak var webTabsView: UIWebTabsListView!
    @IBOutlet weak var webTabsViewTopCn: NSLayoutConstraint!
    @IBOutlet weak var webTabsHostView: UIView!
    
    private var logic: WebTabsControllerLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTabsViewTopConstraint(to: UIScreen.main.bounds.height)
        weak var weakSelf = self
        self.webTabsView.isHidden = false
        
        
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
        
        
        let model = WebTabsControllerLogicModel(webTabsListView: self.webTabsView, webToolbarViewLogic: self.webToolbarView.logic,
                                                webPool: WebViewTabManagementPool(),
                                                maxNumberOfReusableWebViews: 6)
        
        self.logic = WebTabsControllerLogic(model: model, callbacks: callbacks)
        
        showAlertController()
    }
    
    // MARK: - Alert Box
    
    func showAlertController()
    {
        //simple alert dialog
        let alertController = UIAlertController(title: "Don't show this message again!", message: "PlusPrivacy's Private Browser protects your privacy while you surf the Internet by blocking tacking scripts, 3rd party cookies, location requests and ads.", preferredStyle: UIAlertControllerStyle.alert);
        // Add Action
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
        //show it
        let btnImage    = UIImage(named: "checkmarkDefault")!
        let imageButton : UIButton = UIButton(frame: CGRect(x: 20, y: 15, width: 50, height: 50))
        imageButton.setBackgroundImage(btnImage, for: UIControlState())
        imageButton.addTarget(self, action: #selector(UIPrivateBrowsingViewController.checkBoxAction(_:)), for: .touchUpInside)
        
        imageButton.backgroundColor = .clear
        imageButton.layer.cornerRadius = 5
        imageButton.layer.borderWidth = 1
        imageButton.layer.borderColor = UIColor.black.cgColor
        
        alertController.view.addSubview(imageButton)
        self.present(alertController, animated: false, completion: { () -> Void in
            
        })
    }
    
    
    func checkBoxAction(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            let btnImage    = UIImage(named: "checkmarkDefault")!
            sender.setBackgroundImage(btnImage, for: UIControlState())
        }else {
            sender.isSelected = true
//            let btnImage    = nil
            sender.setBackgroundImage(nil, for: UIControlState())
        }
    }
    
    
    //MARK:

    private func setTabsViewTopConstraint(to value: CGFloat, animated: Bool = false) {
        self.webTabsViewTopCn.constant = value;
        self.view.setNeedsLayout()
        let block: VoidBlock = {
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: block, completion: nil)
        } else {
            block()
        }
    }
    
}
