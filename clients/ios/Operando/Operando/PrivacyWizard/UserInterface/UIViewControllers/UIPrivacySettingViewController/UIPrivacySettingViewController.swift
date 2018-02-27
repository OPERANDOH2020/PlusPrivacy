//
//  UIPrivacySettingViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UIPrivacySettingVCStoryboardId = "UIPrivacySettingVCStoryboardId"

protocol UIPrivacySettingProtocol {
    func launchFacebookPrivacySetting()
    func launchLinkedInPrivacySetting()
}

class UIPrivacySettingViewController: UIViewController {

    // MARK: - Properties
    var delegate: UIPrivacySettingProtocol?
    private var pulsarTimer: Timer?
    
    // MARK: - @IBActions
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var contentView: UIRadialGradientView!
    
    // MARK: - @IBActions
    @IBAction func didTapBackButtonItem(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapFacebookButton(_ sender: Any) {
        delegate?.launchFacebookPrivacySetting()
    }
    @IBAction func didTapLinkedInButton(_ sender: Any) {
        delegate?.launchLinkedInPrivacySetting()
    }
    
    // MARK: - Private Methods
    private func setupActionButton(button: UIButton, title: String) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appYellow.cgColor
        button.layer.cornerRadius = 5.0
        button.backgroundColor = .appDarkBlue
        button.setTitle(title, for: .normal)
    }
    
    private func setupControls() {
        setupActionButton(button: facebookButton, title: "Facebook")
        setupActionButton(button: linkedInButton, title: "LinkedIn")
        contentView.backgroundColor = .appDarkBlue
        separatorLabel.textColor = .appYellow
        contentView.setup(center: logoImageView.center,
                          pulsarConfiguration: UIRadialGradientViewPulsarConfiguration(minRadius: logoImageView.bounds.width,
                                                                                       maxRadius: 2 * logoImageView.bounds.width,
                                                                                       stepsNo: 100))
        titleLabel.text = "Final Step"
        detailLabel.text = "Apply your privacy settings"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.startPulsar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.stopPulsar()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
