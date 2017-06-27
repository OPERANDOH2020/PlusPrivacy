//
//  ACSwarmCallbackContainer.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 07/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

class ACSwarmCallbackContainer: NSObject {
    
    var whenReceivedData: ((_ data: [Any]) -> Void)?
    var whenError: ((_ error: NSError?) -> Void)?
    var whenErrorInCreatingSocket: ((_ error: NSError?) -> Void)?
    var whenSocketDidDisconnect: VoidBlock?
}
