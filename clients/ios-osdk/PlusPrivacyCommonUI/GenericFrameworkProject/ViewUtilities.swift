//
//  PPNibDesignableView.swift
//  RSCommon
//
//  Created by Costin Andronache on 2/22/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit


public extension UIViewController {
    
    public func ppAddChildContentController(_ controller: UIViewController) {
        self.addChildViewController(controller)
        controller.view.frame = self.view.bounds;
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    public func ppRemoveChildContentController(_ controller: UIViewController){
        controller.willMove(toParentViewController: nil);
        controller.view.removeFromSuperview();
        controller.removeFromParentViewController();
    }
    
}


extension Bundle {
    static var commonUIBundle: Bundle? {
        guard let path = Bundle.main.path(forResource: "PPCommonUIBundle", ofType: "bundle"),
            let bundle = Bundle(path: path) else {
                return nil
        }
        
        return bundle
    }
}

@IBDesignable
public class PPNibDesignableView: UIView
{
    
    private  var _contentView : UIView?;
    public var contentView : UIView? {
        get {
            return _contentView;
        }
    }
    
    
    public func commonInit() {
        let myClass : AnyClass = self.classForCoder;
        var nibName : NSString = NSStringFromClass(myClass) as NSString;
        nibName = nibName.replacingOccurrences(of: "PlusPrivacyCommonUI" + ".", with: "") as NSString;

        let bundle = Bundle.commonUIBundle
                
        let nib = UINib(nibName: nibName as String, bundle: bundle);
        
        _contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView;
        
        if _contentView != nil {
            PPNibDesignableView.constrainView(view: _contentView!, inHostView: self);
        }
    }
    
    static func constrainView(view: UIView, inHostView host:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.removeFromSuperview();
        host.addSubview(view);
        
        let commonVisualFormat = "|[view]|";
        let viewsDictionary = ["view" : view];
        
        let horizontalCns = NSLayoutConstraint.constraints(withVisualFormat: "H:" + commonVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: viewsDictionary);
        
        let verticalCns = NSLayoutConstraint.constraints(withVisualFormat: "V:" + commonVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: viewsDictionary);
        
        let allCns = verticalCns + horizontalCns;
        
        host.addConstraints(allCns);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.commonInit();
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.commonInit();
    }
    
}
