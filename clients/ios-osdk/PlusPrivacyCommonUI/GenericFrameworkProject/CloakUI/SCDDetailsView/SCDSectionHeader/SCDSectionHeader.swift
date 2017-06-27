//
//  SCDSectionHeader.swift
//  Operando
//
//  Created by Costin Andronache on 1/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit


@objc
public class SCDSectionHeaderModel: NSObject {
    
    public let enabled: Bool
    public let name: String
    public var expanded: Bool
    
    public init(name: String, expanded: Bool, enabled: Bool) {
        self.name = name;
        self.expanded = expanded;
        self.enabled = enabled;
    }
}


public typealias SectionHeaderCallWithConfirmation = (( (_ confirmation: Bool) -> Void ) -> Void)

@objc
public class SCDSectionHeaderCallbacks: NSObject {
    
    public let callToExpand: SectionHeaderCallWithConfirmation?
    public let callToContract: SectionHeaderCallWithConfirmation?
    
    public init(callToExpand: SectionHeaderCallWithConfirmation?,
                callToContract: SectionHeaderCallWithConfirmation?) {
        self.callToExpand = callToExpand
        self.callToContract = callToContract
        super.init()
    }
    
}

@objc
public class SCDSectionHeader: PPNibDesignableView {
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var expandContractButton: UIButton!
    
    static let identifierNibName = "SCDSectionHeader"
    private var callbacks: SCDSectionHeaderCallbacks?
    private var model: SCDSectionHeaderModel?
    
    public func setupWith(model: SCDSectionHeaderModel?, callbacks: SCDSectionHeaderCallbacks?){
        self.callbacks = callbacks
        self.model = model
        self.sectionTitleLabel.text = model?.name
        self.expandContractButton.isSelected = model?.expanded ?? false
        
        if let enabled = model?.enabled, enabled {
            self.expandContractButton.alpha = 1.0;
        } else {
            self.expandContractButton.alpha = 0.6;
        }
    }
    
    
    @IBAction func didPressButton(_ sender: Any) {
        
        let shouldExpand = !self.expandContractButton.isSelected
        weak var weakSelf = self
        
        if shouldExpand {
            
            self.callbacks?.callToExpand? { confirmExpand in
                guard confirmExpand else {
                    return
                }
                weakSelf?.expandContractButton.isSelected = true
                weakSelf?.model?.expanded = true
            }
            
        } else {
            self.callbacks?.callToContract? { confirmContract in
                guard confirmContract else {
                    return
                }
                
                weakSelf?.expandContractButton.isSelected = false
                weakSelf?.model?.expanded = false
                
            }
        }
    }
}
