//
//  UISetPrivacyViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit
import WebKit
import PPApiHooksCore

let UISetPrivacyVCStoryboardId = "UISetPrivacyVCStoryboardId"
let MozillaUserAgentId = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
let MozillaUserAgentId2 = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0"

struct UISetPrivacyViewControllerCallbacks {
    
    let doneWithPrivacySettings: VoidBlock
}


public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:(Void)->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
    
    public class func clear() {
        _onceTracker = []
    }
}

class UISetPrivacyViewController: UIViewController, UITutorialViewDelegate {
    
    // MARK: - Properties
    private var whenUserPressedLoggedIn: VoidBlock?
    private var fbSecurityEnforcer: FbWebKitSecurityEnforcer?
    private var isDONE = false
    
    @IBOutlet weak var settingsProgressView: UISettingsProgress!
    private var webView: WKWebView = WKWebView(frame: .zero)
    private var tutorialView: UITutorialView?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webViewHostView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var loggedInButton: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!
    
    
    private var callbacks: UISetPrivacyViewControllerCallbacks?
    
    // MARK: - @IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapLoggedInButton(_ sender: Any) {
        self.whenUserPressedLoggedIn?()
    }
    
    func setupWithCallback(callbacks: UISetPrivacyViewControllerCallbacks) {
        self.callbacks = callbacks
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
        
        PPApiHooks_disableWebKitURLMonitoring();
        
        setupControls()
        self.fbSecurityEnforcer = FbWebKitSecurityEnforcer(webView: self.webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.navigationController?.setNavigationBarHidden(true, animated: true)
               DispatchQueue.clear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.alterUserAgentInDefaults()
        ProgressHUD.show("Loading")
        self.displayStatusView(hidden: false)
        self.fbSecurityEnforcer?.enforceWithCallToLogin(callToLoginWithCompletion: { callbackWhenLogInIsDone in
            ProgressHUD.dismiss()
            //            self.addTutorialView()
            
            self.whenUserPressedLoggedIn = {
                UIAlertViewController.presentOkAlert(from: self, title: "Information", message: "Please wait while we collect some data from the page, which will help us in applying your privacy settings. Sometimes this process might take a few minutes. You can help us by doing some scrolling movements on the page.", submitCallback: { (action) in
                    
                    
                    callbackWhenLogInIsDone?()
                    
                    self.displayStatusView(hidden: false)
                    self.whenUserPressedLoggedIn = nil
                })
            }
        }, whenDisplayingMessage: {
            
            if $0 == "Done" {
                
                print("DONE GOOGLE CICA !123")
                self.settingsProgressView.setPercetange(value: 100)
                self.displayStatusView(hidden: true)
                //                self.navigationController?.popViewController(animated: false)
                self.callbacks?.doneWithPrivacySettings()
                return
            }
            else if $0 == "Done-GOOGLE" {
                
                print("DONE GOOGLE CICA")
                
                self.displayStatusView(hidden: true)
                self.navigationController?.popViewController(animated: true)
                
                DispatchQueue.once {
                    
                    self.callbacks?.doneWithPrivacySettings()
                }
                
                return
            }
            else if $0 == "DONE-POST" {
                
                print("GO TO NEXT STEP")
                switch ACPrivacyWizard.shared.selectedScope {
                    
                case .googleLogin:
                    print("SET TO GOOGLE PREFES")
                    ACPrivacyWizard.shared.selectedScope = .googlePreferences
                    self.fbSecurityEnforcer?.loadAddress()
                    return
                case .googlePreferences:
                    print("SET TO GOOGLE ACTIVITY")
                    ACPrivacyWizard.shared.selectedScope = .googleActivity
                    self.fbSecurityEnforcer?.loadAddress()
                    self.displayStatusView(hidden: true)
                    break
                default:
                    ACPrivacyWizard.shared.selectedScope = .googleLogin
                }
            }
            else if $0.range(of: "DONE PROGRESS") != nil {
                let pat = "DONE PROGRESS item=([0-9]+)?total=([0-9]+)?"
                
                let matches = $0.capturedGroups(withRegex: pat)
                
                
                if let items = Int(matches[0]),
                    let total = Int(matches[1]) {
                    
                    self.settingsProgressView.setProgressBar(item: items, total: total)
                }
                
                print($0)
            }
            else if $0 == "Please log in!" {
                self.settingsProgressView.isHidden = true
                RSCommonUtilities.showOKAlertWithMessage(message: "Please log in!")
                self.displayStatusView(hidden: true)
            }
            else {
                print($0)
                self.settingsProgressView.isHidden = true
                RSCommonUtilities.showOKAlertWithMessage(message: "A problem has ocurred!")
                self.displayStatusView(hidden: true)
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
        
        self.isDONE = false
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
            self.overlayView.isHidden = hidden
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
