//
//  ACSwarmClientHelper+ConnectionCallbacks.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 05/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

extension ACSwarmClientHelper {
    
    public func didFailedToCreateSocket(_ error: NSError) {
        swarmClientActions.whenErrorInCreatingSocket?(error)
    }
    
    public func didReceiveData(_ data: [Any]) {
        print(data)
        swarmClientActions.whenReceivedData?(data)
        removeCallbacksForSwarmCalls()
    }
    
    public func didFailOperationWith(reason: String) {
        swarmClientActions.whenError?(ACErrorContainer.getSwarmClientError(description: reason))
        removeCallbacksForSwarmCalls()
    }
    
    public func socketDidDisconnect(_ data: [Any]) {
        swarmClientActions.whenSocketDidDisconnect?()
    }
}
