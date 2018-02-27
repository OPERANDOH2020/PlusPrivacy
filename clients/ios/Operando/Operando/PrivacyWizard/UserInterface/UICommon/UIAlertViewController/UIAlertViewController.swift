//
//  UIAlertViewController.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 2/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class UIAlertViewController: NSObject {
    
    // MARK: - Public Static Methods
    class func presentOkAlert(from viewController: UIViewController, title: String, message: String) {
        presentOkAlert(from: viewController, title: title, message: message, submitCallback: nil)
    }
    
    class func presentOkAlert(from viewController: UIViewController, title: String, message: String, submitCallback: ((UIAlertAction) -> Void)?) {
        presentOptionsAlert(from: viewController, title: title, message: message, actions: [(title: "Ok", callback: submitCallback)])
    }
    
    class func presentOkCancelAlert(from viewController: UIViewController, title: String, message: String, submitCallback: ((UIAlertAction) -> Void)?, cancelCallback: ((UIAlertAction) -> Void)?) {
        presentOptionsAlert(from: viewController, title: title, message: message, actions: [(title: "Cancel", callback: cancelCallback), (title: "Ok", callback: submitCallback)])
    }
    
    class func presentOptionsAlert(from viewController: UIViewController, title: String, message: String, actions: [(title: String, callback: ((UIAlertAction) -> Void)?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: .default, handler: action.callback))
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func presentXLActionController(from viewController: UIViewController, headerTitle: String, actions: [(title: String, subtitle: String, image: UIImage?, callback: (() -> Void)?)]) {
        let actionController = TwitterActionController()
        for action in actions {
            actionController.addAction(Action(ActionData(title: action.title, subtitle: action.subtitle, image: action.image), style: .default, handler: action.callback))
        }
        actionController.headerData = headerTitle
        viewController.present(actionController, animated: true, completion: nil)
    }
}
