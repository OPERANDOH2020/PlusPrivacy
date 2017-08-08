//
//  AppSCDsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 8/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation

protocol AppSCDsRepository {
    func retrieveAllSCDsFor(deviceId: String, completion: ((_ scds: [[String: Any]]?, _ error: NSError?) -> Void)?)
}
