//
//  UIView+Utilities.swift
//  SIMAP
//
//  Created by Cătălin Pomîrleanu on 2/27/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public class func parentControllerOrItselfForViewController(viewController: UIViewController, excludeAsParent aParent:UIViewController) -> UIViewController
    {
        if let parent = viewController.parentViewController
        {
            if parent != aParent
            {
                return parent;
            }
        }
        
        return viewController;
    }
}


let blackGradientAlphasTopToBottom : [CGFloat] = [0.68, 0.5, 0.3, 0.1];

extension UIView {
    
    public static func constrainView(view: UIView, inHostView host:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.removeFromSuperview();
        host.addSubview(view);
        
        let commonVisualFormat = "|[view]|";
        let viewsDictionary = ["view" : view];
        
        let horizontalCns = NSLayoutConstraint.constraintsWithVisualFormat("H:" + commonVisualFormat, options: .DirectionLeadingToTrailing, metrics: nil, views: viewsDictionary);
        
        let verticalCns = NSLayoutConstraint.constraintsWithVisualFormat("V:" + commonVisualFormat, options: .DirectionLeadingToTrailing, metrics: nil, views: viewsDictionary);
        
        let allCns = verticalCns + horizontalCns;
        
        host.addConstraints(allCns);
    }
    
    public class func findConstraintForView(view: UIView, inHostView host:UIView, possibleAttribute: NSLayoutAttribute, possibleAttributeMargin: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in host.constraints
        {
            if(constraint.firstItem as? NSObject == view || constraint.secondItem as? NSObject == view)
            {
                if(constraint.firstAttribute == possibleAttribute || constraint.firstAttribute == possibleAttributeMargin ||
                    constraint.secondAttribute == possibleAttribute || constraint.secondAttribute == possibleAttributeMargin)
                {
                    return constraint;
                }
            }
        }
        
        return nil;
    }
    
    public static func viewWithBottomBorder(color: UIColor, borderColor: UIColor, size: CGSize) -> UIView {
        let frame = CGRectMake(0, 0, size.width, size.height)
        let view = UIView(frame: frame)
        
        view.backgroundColor = color
        
        let borderView = UIView(frame: CGRect(x: 0, y: view.bounds.height - 4.0, width: view.bounds.width, height: 4.0))
        borderView.backgroundColor = borderColor
        
        view.addSubview(borderView)
        
        return view
    }
    
    
    public var maxY : CGFloat
    {
        get
        {
            return self.frame.size.height + self.frame.origin.y;
        }
    }
    
    public func addBlackGradientBlurredLayerWithAlphaList(alphaList: [CGFloat]) -> CAGradientLayer
    {
        let gradientLayer = CAGradientLayer()
        
        
        gradientLayer.frame = self.bounds;
        
        var colors: [CGColorRef] = [];
        
        for alpha in alphaList
        {
            let colorRef = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).CGColor;
            colors.append(colorRef);
        }
        
        gradientLayer.colors = colors;
        gradientLayer.opacity = 0.8
        self.layer.insertSublayer(gradientLayer, atIndex: 0);
        
        if let filter = CIFilter(name: "CIGaussianBlur")
        {
            
            filter.setDefaults();
            gradientLayer.backgroundFilters = [filter];
        }
        
        
        return gradientLayer;
    }
    
    
    
    public func frameInWindowCoordinates() -> CGRect
    {
        let pointOrigin = self.superview?.convertPoint(self.frame.origin, toView: nil);
        return CGRect(origin: pointOrigin!, size: self.frame.size);
    }
    
    
    
    
    public func attachPopUpAnimationWithDuration(duration: CFTimeInterval)
    {
        let animation = CAKeyframeAnimation(keyPath: "transform");
        
        let scale1 = CATransform3DMakeScale(1.3, 1.3, 1) //CATransform3DMakeScale(0.5, 0.5, 1);
        let scale2 = CATransform3DMakeScale(1.2, 1.2, 1)//CATransform3DMakeScale(1.2, 1.2, 1);
        let scale3 = CATransform3DMakeScale(1.1, 1.1, 1)//CATransform3DMakeScale(0.9, 0.9, 1);
        let scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
        
        let frameValues = [NSValue(CATransform3D: scale1),
            NSValue(CATransform3D:scale2), NSValue(CATransform3D: scale3), NSValue(CATransform3D: scale4)];
        
        animation.values = frameValues;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false;
        animation.duration = duration;
        
        
        animation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.3), NSNumber(float: 0.6), NSNumber(float: 1.0)];
        self.layer.addAnimation(animation, forKey: nil);
    }
    
    class func subviewsOfView(view: UIView, withType type: String) -> [UIView]
    {
        let prefix = "<\(type)"
        var subviewArray = view.subviews.flatMap { subview in self.subviewsOfView(subview, withType: type) }
        
        if view.description.hasPrefix(prefix) {
            subviewArray.append(view)
        }
        
        return subviewArray
    }
}

