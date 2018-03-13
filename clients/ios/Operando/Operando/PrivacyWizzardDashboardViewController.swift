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
}

class PrivacyWizzardDashboardViewController: UIViewController {

    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var linkedinView: UIView!
    @IBOutlet weak var facebookView: UIView!
    
    private var callbacks: PrivacyWizzardDashboardCallbacks?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func setupWithCallback(callbacks: PrivacyWizzardDashboardCallbacks) {
        self.callbacks = callbacks
    }
    
    // MARK: - Actions
    
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
