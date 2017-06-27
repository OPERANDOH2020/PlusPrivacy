//
//  UIMainViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/17/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UIMainVCStoryboardId = "UIMainVCStoryboardId"

protocol UIMainScreenVCDelegate {
    func openQuestionnaire()
    func displayInfo()
}

class UIMainViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var delegate: UIMainScreenVCDelegate?

    // MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var setupPrivacyButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet var contentView: UIRadialGradientView!
    @IBOutlet weak var activityContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    // MARK: - @IBActions
    @IBAction func didTapSetupPrivacyButton(_ sender: Any) {
        delegate?.openQuestionnaire()
    }
    
    @IBAction func didTapInfoButton(_ sender: Any) {
        delegate?.displayInfo()
    }
    
    // MARK: - Private Methods
    private func setupControls() {
        self.navigationController?.navigationBar.barTintColor = .appDarkBlue
        activityIndicator.startAnimating()
        setupPrivacyButton.layer.borderWidth = 1
        setupPrivacyButton.layer.borderColor = UIColor.appYellow.cgColor
        setupPrivacyButton.layer.cornerRadius = 5.0
        setupPrivacyButton.backgroundColor = .appDarkBlue
        setupPrivacyButton.isEnabled = false
        activityLabel.textColor = .white
        contentView.backgroundColor = .appDarkBlue
        separatorLabel.textColor = .appYellow
        contentView.setup(center: logoImageView.center,
                          pulsarConfiguration: UIRadialGradientViewPulsarConfiguration(minRadius: logoImageView.bounds.width,
                                                                                       maxRadius: 2 * logoImageView.bounds.width,
                                                                                       stepsNo: 100))
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        contentView.startPulsar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        contentView.stopPulsar()
    }
    
    // MARK: - Public Methods
    func setup(delegate: UIMainScreenVCDelegate) {
        self.delegate = delegate
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func canStartWorkflow(allowed: Bool) {
        self.activityIndicator.stopAnimating()
        self.activityContainer.isHidden = true
        if allowed {
            self.setupPrivacyButton.isEnabled = true
        } else {
            UIAlertViewController.presentOkAlert(from: self, title: "Information", message: "Could not fetch Privacy Wizard configuration. Please come back later.")
        }
    }
}
