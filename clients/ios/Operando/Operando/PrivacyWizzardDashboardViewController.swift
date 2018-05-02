//
//  PrivacyWizzardDashboardViewController.swift
//  Operando
//
//  Created by RomSoft on 2/5/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

struct PrivacyWizzardDashboardCallbacks {
    
    let pressedFacebook: VoidBlock
    let pressedLinkedin: VoidBlock
    let pressedTwitter: VoidBlock
    let pressedGoogle: VoidBlock
    let pressedGoToLogoutDashboard: VoidBlock
}

class PrivacyWizzardDashboardViewController: UIViewController {

    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var linkedinView: UIView!
    @IBOutlet weak var facebookView: UIView!
    
    @IBOutlet weak var observationLabel: UILabel!
    private var callbacks: PrivacyWizzardDashboardCallbacks?
    private var observationText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.observationLabel.text = observationText
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gridViews = [twitterView,googleView,linkedinView, facebookView]
        setupGridViews(arrayOfViews: gridViews)
    }
    
    private func setupGridViews(arrayOfViews: [UIView?]) {
        
        for view in arrayOfViews where view != nil{
            
            view!.layer.cornerRadius = facebookView.frame.height/2
            view!.layer.borderWidth = 7
            view!.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func setupWithCallback(callbacks: PrivacyWizzardDashboardCallbacks,observationText: String) {
        self.callbacks = callbacks
        self.observationText = observationText
    }
    
    // MARK: - Actions
    
    @IBAction func goToSocialNetworkAccounts(_ sender: Any) {
        self.callbacks?.pressedGoToLogoutDashboard()
    }
    @IBAction func pressedGoogleButton(_ sender: Any) {
        self.callbacks?.pressedGoogle()
    }
    @IBAction func pressedTwitterButton(_ sender: Any) {
        self.callbacks?.pressedTwitter()
    }
    @IBAction func pressedLinkedinButton(_ sender: Any) {
        self.callbacks?.pressedLinkedin()
    }
    @IBAction func pressedFacebookButton(_ sender: Any) {
        self.callbacks?.pressedFacebook()
    }
}
