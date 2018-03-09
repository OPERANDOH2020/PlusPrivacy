//
//  NetworkReachability.swift
//  SIMAP
//
//  Created by Cătălin Pomîrleanu on 2/25/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import Foundation;

private enum NetworkReachabilityType: Int {
    case none = 0,  wiFi, wwan, reachable
    
    func description () -> String {
        switch self {
        case .none :
            return "Not Reachable"
        case .wiFi :
            return "WiFi"
        case .wwan :
            return "WWAN"
        case .reachable :
            return "Reachable"
        }
    }
}


class ACNetworkReachability {
    
    // MARK: Private Methods
    fileprivate class func hasInternetConnection(_ type:NetworkReachabilityType) -> Bool {
        let reachabilityStatus = Reachability.forInternetConnection().currentReachabilityStatus()
        switch reachabilityStatus {
        case .ReachableViaWiFi where type == NetworkReachabilityType.wiFi :
            return true
        case .ReachableViaWWAN where type == NetworkReachabilityType.wwan :
            return true
        case .ReachableViaWiFi where type == NetworkReachabilityType.reachable :
            fallthrough
        case .ReachableViaWWAN where type == NetworkReachabilityType.reachable :
            return true
        default:
            return false
        }
    }

    // MARK: Public Methods
    class func hasInternetConnection() -> Bool {
        return ACNetworkReachability.hasInternetConnection(.reachable)
    }
    class func hasInternetConnectionViaWiFi() -> Bool {
        return ACNetworkReachability.hasInternetConnection(.wiFi)
    }
    class func hasInternetConnectionViaWWAN() -> Bool {
        return ACNetworkReachability.hasInternetConnection(.wwan)
    }
}






