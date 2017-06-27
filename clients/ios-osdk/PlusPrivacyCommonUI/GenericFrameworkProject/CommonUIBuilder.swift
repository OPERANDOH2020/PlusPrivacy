//
//  CommonUIBuilder.swift
//  PlusPrivacyCommonUI
//
//  Created by Costin Andronache on 1/19/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import Foundation
import UIKit
import PPCommonTypes

@objc
public class OneDocumentRepository: NSObject, SCDRepository {
    var scd: SCDDocument
    public init(document: SCDDocument) {
        self.scd = document
    }
    
    public func retrieveAllDocuments(with callback: (([SCDDocument]?, NSError?) -> Void)?) {
        callback?([self.scd], nil)
    }
}

@objc
public class CommonUIBUilder: NSObject {
    @objc
    public static func buildFlow(for repository: SCDRepository, displayModel: CommonUIDisplayModel, whenExiting: VoidBlock?) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Cloak", bundle: Bundle.commonUIBundle)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "UISCDDocumentsViewController") as?
            UISCDDocumentsViewController else {
                return nil
        }
        
        let navgController = UINavigationController(rootViewController: vc)
        navgController.isNavigationBarHidden = true
        
        weak var weakNavgController = navgController
        vc.setup(with: UISCDDocumentsViewControllerModel(repository: repository, displayModel: displayModel),
                 callbacks: UISCDDocumentsViewControllerCallbacks(whenUserSelectsSCD: { doc in
                    guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "SCDDetailsViewController") as? SCDDetailsViewController else {return}
                    
                    detailsVC.setupWith(scd: doc, titleBarHeight: displayModel.titleBarHeight) {
                        weakNavgController?.popViewController(animated: true)
                    }
                    weakNavgController?.pushViewController(detailsVC, animated: true)
                    
                 }, whenUserSelectsToExit: whenExiting))
        return navgController
    }
    
    
}
