//
//  UIRibonHeaderView.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 3/29/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

let UIRibonHeaderViewReuseIdentifier = "UIRibonHeaderViewReuseIdentifier"

class UIRibonHeaderView: UIView {

    var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var upArrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        addSubview(upArrowImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = CGRect(x: 0.0, y: 10.0, width: frame.width, height: frame.height - 10.0)
        
        upArrowImageView.frame = CGRect(x: frame.width/2 - 15.0, y: -2.0, width: 30.0, height: 22.0)
        upArrowImageView.contentMode = .scaleToFill
        
        titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: backgroundView.frame.width, height: backgroundView.frame.height)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Dosis-SemiBold", size: 17.0)
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
    }
    
    func setup(withTitle title: String, titleColor color: UIColor, backgroundColor: UIColor) {
        self.titleLabel.text = title
        self.titleLabel.textColor = color
        self.backgroundColor = .clear
        self.backgroundView.backgroundColor = backgroundColor
        self.upArrowImageView.image = UIImage.upArrowImage?.withRenderingMode(.alwaysTemplate)
        self.upArrowImageView.tintColor = backgroundColor
    }
}
