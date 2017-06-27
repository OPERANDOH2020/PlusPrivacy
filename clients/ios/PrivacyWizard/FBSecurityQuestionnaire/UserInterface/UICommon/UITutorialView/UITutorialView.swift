//
//  UITutorialView.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 4/4/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

protocol UITutorialViewDelegate: class {
    func didFinishTutorial()
}

struct UITutorialViewCroppingConfiguration {
    var origin: CGPoint
    var width: CGFloat
    var height: CGFloat
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.origin = origin
        self.width = width
        self.height = height
    }
}

class UITutorialView: UIView {
    
    // MARK: - Properties
    weak var delegate: UITutorialViewDelegate?
    var pointingImageView: UIImageView?
    var croppingCenter: CGPoint?
    
    // MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    // MARK: - @IBActions
    @IBAction func didTapOkButton(_ sender: Any) {
        delegate?.didFinishTutorial()
    }

    // MARK: - Static Methods
    static func create(withTitle title: String, frame: CGRect, backgroundColor: UIColor, croppingConfiguration cropConfig: UITutorialViewCroppingConfiguration, delegate: UITutorialViewDelegate) -> UITutorialView {
        let tutorialView = UINib(nibName: "UITutorialView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UITutorialView
        
        
        tutorialView.titleLabel.text = title
        let overlay = UIView.getCroppedOverlay(withBackgroundColor: backgroundColor, alpha: 0.9, bounds: frame, cropRectFrom: cropConfig.origin, width: cropConfig.width, height: cropConfig.height)
        tutorialView.insertSubview(overlay, at: 0)
        tutorialView.addPointingImage(at: CGPoint(x: cropConfig.origin.x, y: cropConfig.origin.y + cropConfig.height))
        tutorialView.delegate = delegate
        tutorialView.croppingCenter = cropConfig.origin
        tutorialView.bounceImage()
        
        return tutorialView
    }
    
    // MARK: - Public Methods
    func addPointingImage(at point: CGPoint) {
        pointingImageView = self.getPointingImage(at: point)
        self.addSubview(pointingImageView!)
    }
    
    func bounceImage() {
        guard let _ = pointingImageView else { return }
        UIView.animate(withDuration: 1, animations: {
            self.pointingImageView!.center = CGPoint(x: (self.pointingImageView?.center.x)! - 10, y: (self.pointingImageView?.center.y)! + 10)
        }) { (completed) in
            UIView.animate(withDuration: 1, animations: {
                self.pointingImageView!.center = CGPoint(x: (self.pointingImageView?.center.x)! + 10, y: (self.pointingImageView?.center.y)! - 10)
            }) { (completed) in
                self.bounceImage()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
        self.titleLabel.textColor = .white
        okButton.layer.cornerRadius = okButton.bounds.width / 2
        okButton.backgroundColor = .appTransparentDarkBlue
        okButton.setTitleColor(.white, for: .normal)
    }
}
