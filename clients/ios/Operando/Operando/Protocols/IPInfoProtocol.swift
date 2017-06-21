//
//  IPInfoProtocol.swift
//  Operando
//
//  Created by Costin Andronache on 6/16/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol IPInfoProtocol
{
    var hostname: String {get}
    var city: String {get}
    var country: String {get}
    var locationCoordinates: String {get}
    var organization: String {get}
    var postalCode: String {get}
    var region: String {get}
}

struct IPInfo: IPInfoProtocol
{
    var hostname: String
    var city: String
    var country: String
    var locationCoordinates: String
    var organization: String
    var postalCode: String
    var region: String
}