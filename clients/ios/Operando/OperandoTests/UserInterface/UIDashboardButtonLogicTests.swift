//
//  UIDashboardButtonLogicTests.swift
//  Operando
//
//  Created by Costin Andronache on 8/3/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import XCTest
@testable import Operando

class UIDashboardButtonLogicTests: XCTestCase {
    
    func test_OnInit_NotificationsLabelIsHidden() {
        let outlets: UIDashboardButtonOutlets = .allDefaults
        let _ = UIDashboardButtonLogic(outlets: outlets)
        XCTAssert(outlets.numOfNotificationsLabel!.isHidden)
        
        
        outlets.numOfNotificationsLabel?.isHidden = false
        let _ = UIDashboardButtonLogic(outlets: outlets)
        XCTAssert(outlets.numOfNotificationsLabel!.isHidden)
    }
    
    
    func test_OnUpdateNotificationsLabel_SetTextCorrectlyLabelShown() {
        _OnUpdateNotificationsLabel_SetTextCorrectlyLabelShown(numOfNotifs: 0)
        _OnUpdateNotificationsLabel_SetTextCorrectlyLabelShown(numOfNotifs: 4)
        _OnUpdateNotificationsLabel_SetTextCorrectlyLabelShown(numOfNotifs: 10)
    }
    
    func _OnUpdateNotificationsLabel_SetTextCorrectlyLabelShown(numOfNotifs: Int){
        let outlets: UIDashboardButtonOutlets = .allDefaults
        let logic: UIDashboardButtonLogic = UIDashboardButtonLogic(outlets: outlets)
        
        let model: UIDashboardButtonModel = UIDashboardButtonModel(style: nil, notificationsRequestCallbackIfAny: { sendNumOfNotifications in
            sendNumOfNotifications?(numOfNotifs)
        }, onTap: nil)
        
        logic.setupWith(model: model)
        
        
        logic.updateNotificationsCountLabel()
        XCTAssert(outlets.numOfNotificationsLabel!.text! == "\(numOfNotifs)")
    }
}
