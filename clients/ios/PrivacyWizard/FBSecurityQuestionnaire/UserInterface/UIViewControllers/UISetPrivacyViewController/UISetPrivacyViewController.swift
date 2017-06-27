//
//  UISetPrivacyViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit
import WebKit

let UISetPrivacyVCStoryboardId = "UISetPrivacyVCStoryboardId"
let MozillaUserAgentId = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"

class UISetPrivacyViewController: UIViewController, UITutorialViewDelegate {

    // MARK: - Properties
    private var whenUserPressedLoggedIn: VoidBlock?
    private var fbSecurityEnforcer: FbWebKitSecurityEnforcer?
    
    private var webView: WKWebView = WKWebView(frame: .zero)
    private var tutorialView: UITutorialView?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webViewHostView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var loggedInButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIndicatorView: UIActivityIndicatorView!
    
    // MARK: - @IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoggedInButton(_ sender: Any) {
        self.whenUserPressedLoggedIn?()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        loggedInButton.layer.borderWidth = 1
        loggedInButton.layer.borderColor = UIColor.appYellow.cgColor
        loggedInButton.layer.cornerRadius = 5.0
        loggedInButton.backgroundColor = .appDarkBlue
        navigationView.backgroundColor = .appDarkBlue
        statusView.isHidden = true
        
        UIView.constrainView(view: webView, inHostView: self.webViewHostView)
        if #available(iOS 9.0, *) {
            self.webView.customUserAgent = MozillaUserAgentId
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
        self.fbSecurityEnforcer = FbWebKitSecurityEnforcer(webView: self.webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alterUserAgentInDefaults()
        
        ProgressHUD.show("Loading")
        self.fbSecurityEnforcer?.enforceWithCallToLogin(callToLoginWithCompletion: { callbackWhenLogInIsDone in
            ProgressHUD.dismiss()
            self.addTutorialView()
            
            self.whenUserPressedLoggedIn = {
                UIAlertViewController.presentOkAlert(from: self, title: "Information", message: "Please wait while we collect some data from the page, which will help us in applying your privacy settings. Sometimes this process might take a few minutes. You can help us by doing some scrolling movements on the page.", submitCallback: { (action) in
                    
                    self.displayStatusView(hidden: false)
                    callbackWhenLogInIsDone?()
                    self.whenUserPressedLoggedIn = nil
                })
            }
            
        }, whenDisplayingMessage: {
            if $0 == "Done" {
                self.displayStatusView(hidden: true)
                RSCommonUtilities.showOKAlertWithMessage(message: "Your privacy settings have ben secured")
                return
            } else {
                RSCommonUtilities.showOKAlertWithMessage(message: $0)
            }
        }, completion: { error in
            if let error = error {
                RSCommonUtilities.showOKAlertWithMessage(message: error.localizedDescription)
                return
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func alterUserAgentInDefaults()
    {
        let defaultsUserAgent: [String : AnyObject] = ["UserAgent" : MozillaUserAgentId as AnyObject]
        
        UserDefaults.standard.register(defaults: defaultsUserAgent)
        UserDefaults.standard.synchronize()
    }
    
    private func displayStatusView(hidden: Bool) {
        UIView.animate(withDuration: 2) { 
            self.statusView.isHidden = hidden
            if hidden {
                self.statusIndicatorView.stopAnimating()
            } else {
                self.statusIndicatorView.startAnimating()
            }
        }
    }
    
    private func addTutorialView() {
        UIView.animate(withDuration: 1) {
            self.tutorialView = self.createTutorialView()
            self.view.addSubview(self.tutorialView!)
            
            if #available(iOS 9.0, *) {
                self.tutorialView?.translatesAutoresizingMaskIntoConstraints = false
                self.tutorialView?.heightAnchor.constraint(equalToConstant: self.view.bounds.height).isActive = true
                self.tutorialView?.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
                self.tutorialView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                self.tutorialView?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            }
        }
    }
     
    private func createTutorialView() -> UITutorialView {
        let rect = loggedInButton.frame
        return UITutorialView.create(withTitle: "Please log in and then press the pointed button",
                                     frame: view.frame,
                                     backgroundColor: .appDarkBlue,
                                     croppingConfiguration: UITutorialViewCroppingConfiguration(origin: CGPoint(x: rect.minX, y: rect.minY),
                                                                                                width: rect.width,
                                                                                                height: rect.height),
                                     delegate: self)
    }
    
    func didFinishTutorial() {
        tutorialView?.removeFromSuperview()
    }
}
