//
//  DisclaimerView.swift
//  ScrollableDisclaimerViewAlert
//
//  Created by Kuba on 09/03/2017.
//  Copyright © 2017 HuD. All rights reserved.
//

import UIKit

protocol DisclaimerViewDelegate: class {
    func acceptDisclaimer()
}

class DisclaimerView: UIView {
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var separatorLAbel: UILabel!
    
    let kAnimationDuration = 0.3
    
    // MARK: Delegate
    
    weak var delegate: DisclaimerViewDelegate?
    
    @IBAction func acceptAction(_ sender: Any) {
        delegate?.acceptDisclaimer()
    }
    
    override func draw(_ rect: CGRect) {
        addRadialGradient(fromColors: [UIColor.appBlue.cgColor, UIColor.appMidBlue.cgColor, UIColor.appDarkBlue.cgColor, UIColor.appTransparentDarkBlue.cgColor], gradientCenter: CGPoint(x: 0.0, y: UIScreen.main.bounds.height / 3), radius: 2 * UIScreen.main.bounds.width)
    }
    
    // MARK: Implementation
    
    class func initView() -> DisclaimerView {
        
        let disclaimerView = UINib(nibName: "Disclaimer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DisclaimerView
        return disclaimerView
    }
    
    class func initWith(title: String, content: String, acceptTitle: String = "Dismiss", frame: CGRect = UIScreen.main.bounds, delegate: DisclaimerViewDelegate) -> DisclaimerView {
        
        let disclaimerView = UINib(nibName: "Disclaimer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DisclaimerView
        
        disclaimerView.title.text = title
        disclaimerView.title.textColor = .white
        disclaimerView.content.text = content
        disclaimerView.content.textColor = .white
        disclaimerView.contentView.backgroundColor = .appTransparentMidBlue
        disclaimerView.acceptButton.setTitle(acceptTitle, for: .normal)
        disclaimerView.acceptButton.backgroundColor = .appMidBlue
        disclaimerView.acceptButton.layer.borderWidth = 1
        disclaimerView.acceptButton.layer.borderColor = UIColor.appYellow.cgColor
        disclaimerView.acceptButton.layer.cornerRadius = 5.0
        disclaimerView.acceptButton.setTitleColor(.white, for: .normal)
        disclaimerView.delegate = delegate
        disclaimerView.content.isSelectable = false
        disclaimerView.separatorLAbel.textColor = .appYellow
        
        disclaimerView.frame = frame
        
        disclaimerView.backgroundColor = .appDarkBlue
        disclaimerView.contentView.roundedCorners(withRadius: 5.0)
        disclaimerView.content.backgroundColor = .clear
        
        return disclaimerView
    }
    
    class func initWith(title: String, filePath: String, fileExtension: String, acceptTitle: String = "Dismiss", frame: CGRect = UIScreen.main.bounds, delegate: DisclaimerViewDelegate) -> DisclaimerView {
        
        let disclaimerView = UINib(nibName: "Disclaimer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DisclaimerView
        
        disclaimerView.title.text = title

        if let path = Bundle.main.path(forResource: filePath, ofType: fileExtension) {
            disclaimerView.content.text = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
        }
        
        disclaimerView.acceptButton.setTitle(acceptTitle, for: .normal)
        
        disclaimerView.delegate = delegate
        
        disclaimerView.frame = frame
        
        disclaimerView.acceptButton.borders(for: [.top], color: .init(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1))
        
        disclaimerView.backgroundColor = .lightGray
        
        return disclaimerView
    }
    
    override func layoutSubviews() {
        layer.opacity = 0
        UIView.animate(withDuration: kAnimationDuration) {
            self.layer.opacity = 1
        }
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.layer.opacity = 0
        }) { processing in
            if !processing { super.removeFromSuperview() }
        }
    }
}

// MARK: - Extensions

extension UIView {
    class func addGradient(toView view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let color1 = UIColor.white.cgColor
        let color2 = UIColor.operandoSkyLightBlue.cgColor
        let color3 = UIColor.operandoSkyMidBlue.cgColor
        let color4 = UIColor.operandoSkyBlue.cgColor
        
        gradientLayer.colors = [color1, color2, color2, color2, color3, color3, color3, color4, color4, color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func borders(for edges:[UIRectEdge], width:CGFloat = 1, color: UIColor = .black) {
        
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]
            
            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }
                
                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)
                    
                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"
                    
                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }
                    
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
}
