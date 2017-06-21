//
//  RSNibDesignableView.swift
//  RSCommon
//
//  Created by Costin Andronache on 2/22/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

@IBDesignable
public class RSNibDesignableView: UIView
{
    
    private  var _contentView : UIView?;
    public var contentView : UIView?
    {
        get
        {
            return _contentView;
        }
    }
    
    
    internal func commonInit()
    {
        let myClass : AnyClass = self.classForCoder;
        var nibName : NSString = NSStringFromClass(myClass);
        
        let bundle : NSBundle = NSBundle(forClass: myClass);
        
        if let targetName = bundle.infoDictionary?["CFBundleName"] as? String
        {
            nibName = nibName.stringByReplacingOccurrencesOfString(targetName + ".", withString: "");
        }
        
        let nib = UINib(nibName: nibName as String, bundle: bundle);
        
        _contentView = nib.instantiateWithOwner(self, options: nil).first as? UIView;
        
        if _contentView != nil
        {
            UIView.constrainView(_contentView!, inHostView: self);
        }
        
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
