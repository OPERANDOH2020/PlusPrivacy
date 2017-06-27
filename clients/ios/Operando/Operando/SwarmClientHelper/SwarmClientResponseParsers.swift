//
//  SwarmClientResponseParsers.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


struct IdentitiesListResponse {
    let identitiesList: [String]
    let indexOfDefaultIdentity: Int?
    static let defaultEmptyResponse = IdentitiesListResponse(identitiesList: [], indexOfDefaultIdentity: -1)
}


struct Domain
{
    let id: String
    let name: String
    
    static let defaultEmpty = Domain(id: "", name: "")
}

struct PfbDealUpdate {
    let voucher: String?
    let subscribed: Bool
    
    static let emptyUnsubscribed = PfbDealUpdate(voucher: nil, subscribed: false)
}

class PfbDeal
{
    private(set) var serviceId: Int
    private(set) var benefit: String?
    private(set) var identitifer: String?
    private(set) var description: String?
    private(set) var logo: String?
    private(set) var voucher: String?
    private(set) var website: String?
    private(set) var subscribed: Bool
    
    //
    var imageName: String? = nil
    //
    
    init?(dict: [String: Any]){
        guard let serviceId = dict["serviceId"] as? Int,
              let subscribed = dict["subscribed"] as? Bool else {
            return nil
        }
        self.serviceId = serviceId
        self.subscribed = subscribed
        
        self.benefit = dict["benefit"] as? String
        self.description = dict["description"] as? String
        self.logo = dict["logo"] as? String
        self.voucher = dict["voucher"] as? String
        self.website = dict["website"] as? String
        self.identitifer = dict["identifier"] as? String
        
    }
    
    func updateWith(update: PfbDealUpdate){
        self.voucher = update.voucher
        self.subscribed = update.subscribed
        
    }
    
    static var withAllFieldsEmpty: PfbDeal {
        return PfbDeal(dict: ["serviceId": 1, "subscribed": true])!
    }
    
    
}

enum NotificationAction: String {
    case identitiesMangament = "identity"
    case privacyForBenefits = "privacy-for-benefits"
    case privateBrowsing = "privateBrowsing"
    case socialNetworkPrivacy = "social-network-privacy"
}

struct OPNotification{
    
    static let actionTitlePerType: [NotificationAction: String] = [NotificationAction.identitiesMangament: "Go to Identities",
                                                       NotificationAction.privacyForBenefits: "Go to Privacy For Benefits",
                                                       NotificationAction.privateBrowsing: "Go to Private Browsing"]
    
    struct Action {
        let title: String?
        let actionKey: NotificationAction
    }
    
    let id: String
    let title: String
    let description: String
    
    let actions: [Action]
    
    
    init?(notificationsSwarmReplyDict: [String: Any]){
        
        guard let id = notificationsSwarmReplyDict["notificationId"] as? String,
              let title = notificationsSwarmReplyDict["title"] as? String,
              let description = notificationsSwarmReplyDict["description"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        
        if let actionName = notificationsSwarmReplyDict["action_name"] as? String,
            let validActionName = NotificationAction(rawValue: actionName) {
            
            if validActionName == .socialNetworkPrivacy {
                return nil // SNP is not implemented yet
            }
            
            self.actions = [Action(title: OPNotification.actionTitlePerType[validActionName], actionKey: validActionName)]
        } else {
            self.actions = []
        }
    }
    
}


class SwarmClientResponseParsers
{
    static let kSwarmClientResponseParserErrorDomain = "com.operando.swarmClientReponseParser"
    
    static func parseErrorIfAny(from dataDict: [String: Any]) -> NSError?
    {
        if let errorMessageInEnglish = dataDict["error"] as? String{
            return NSError(domain: kSwarmClientResponseParserErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessageInEnglish])
        }
        
        guard let errorDict = dataDict["error"] as? [String: Any],
              let messageType = errorDict["message"] as? String else {
            return nil
        }
        
        if let errorCode = localizableCodesPerErrorMessage[messageType] {
            return NSError(domain: OPErrorContainer.kOperandoDomain, code: errorCode, userInfo: nil)
        }
        
        return OPErrorContainer.unknownError
    }
    
    static func parseIdentitiesList(from dataDict: [String: Any]) -> IdentitiesListResponse?
    {
        guard var identitiesArray = dataDict["identities"] as? [ [String: Any] ] else {
            return nil
        }
        
        let indexOfRealIdentity = identitiesArray.index { item -> Bool in
            guard let isReal = item["isReal"] as? Bool,
                isReal == true else {
                    return false
            }
            return true
        }
        
        if let indexOfRealIdentity = indexOfRealIdentity {
            identitiesArray.remove(at: indexOfRealIdentity)
        }
        
        var indexOfDefaultOne: Int?
        var identities: [String] = []
        
        for (index, dict) in identitiesArray.enumerated(){
            guard let email = dict["email"] as? String,
                  let isDefault = dict["isDefault"] as? Bool else {
                return nil
            }
            if isDefault { indexOfDefaultOne = index}
            identities.append(email)
        }
        
        return IdentitiesListResponse(identitiesList: identities, indexOfDefaultIdentity: indexOfDefaultOne)
    }
    
    static func parseDomainsList(from dataDict: [String: Any]) -> [Domain]?
    {
        guard let domainsArray = dataDict["domains"] as? [ [String: Any] ] else{
            return nil
        }
        
        var domains: [Domain] = []
        
        for dict in domainsArray{
            guard let id = dict["id"] as? String, let name = dict["name"] as? String else {
                return nil
            }
            
            domains.append(Domain(id: id, name: name))
        }
        
        return domains
    }
    
    static func parseGeneratedIdentity(from dataDict: [String: Any]) -> String?
    {
        guard let emailDict = dataDict["generatedIdentity"] as? [String: Any],
              let email = emailDict["email"] as? String
        else
        {
            return nil
        }
        
        return email
    }
    
    
    static func parsePfbDeals(from dataDict: [String: Any]) -> [PfbDeal]?
    {
        guard let dealsArray = dataDict["deals"] as? [ [String: Any] ] else {
            return nil
        }
        
        var deals: [PfbDeal] = []
        
        for dict in dealsArray{
            if let pfbDeal = PfbDeal(dict: dict) {
                deals.append(pfbDeal)
            }
        }
        
        return deals
    }
    
    static func parseVoucherForSubscribedDeal(from dataDict: [String: Any]) -> String? {
        guard let dealDict = dataDict["deal"] as? [String: Any],
              let voucher = dealDict["voucher"] as? String else {
                return nil
        }
        
        return voucher
    }
    
    static func parseUserInfo(from dataDict: [String: Any]) -> UserInfo? {
        guard let resultDict = dataDict["result"] as? [String: Any],
              let userInfo = UserInfo(dict: resultDict) else {
            return nil
        }
        
        return userInfo
    }
    
    static func parseRegisterUserSuccessStatus(from dataDict: [String: Any]) -> Bool {
        guard let _ = dataDict["deliveryResult"] as? [String: Any] else {
                return false
        }

        return true
    }
    
    static func parseNonDismissedNotificationsArray(from dataDict: [String: Any]) -> [OPNotification]? {
        guard let notificationsArray = dataDict["notifications"] as? [[String: Any]] else {
            return nil
        }
        
        var notifications: [OPNotification] = []
        for notificationDict in notificationsArray {
            if let notification = OPNotification(notificationsSwarmReplyDict: notificationDict) {
                notifications.append(notification)
            }
        }
        
        return notifications
    }
    
    
    static func parseNextDefaultIdentity(from dataDict: [String: Any]) -> String? {
        guard let identityDict = dataDict["default_identity"] as? [String: Any],
              let identity = identityDict["email"] as? String else {
               return nil
        }
        
        return identity
    }
    
    static func parseAddIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "createIdentity_success", in: dataDict)
    }
    
    static func parseDeleteIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "deleteIdentity_success", in: dataDict)
    }
    
    static func parseUpdateSubstituteIdentitySuccessStatus(from dataDict: [String: Any]) -> Bool?
    {
        return parseMetaCurrentPhaseEqualTo(item: "defaultIdentityUpdated", in: dataDict)
    }
    
    
    static func parseDealUnsubscribedSuccessStatus(from dataDict: [String: Any]) -> Bool? {
        return parseMetaCurrentPhaseEqualTo(item: "dealUnsubscribed", in: dataDict)
    }
    
    static func parseSubscribeToDealSuccessStatus(from dataDict: [String: Any]) -> Bool?{
        return parseMetaCurrentPhaseEqualTo(item: "dealAccepted", in: dataDict)
    }
    
    static func parseLogoutSucceedSuccessStatus(from dataDict: [String: Any]) -> Bool? {
        return parseMetaCurrentPhaseEqualTo(item: "logoutSucceed", in: dataDict)
    }
    
    static func parseResetPasswordSuccessStatus(from dataDict: [String: Any]) -> Bool? {
        return parseMetaCurrentPhaseEqualTo(item: "newPasswordWasSet", in: dataDict)
    }
    
    static func parseNotificationDismissedSuccessStatus(from dataDict: [String: Any]) -> Bool? {
        return parseMetaCurrentPhaseEqualTo(item: "notificationDismissed", in: dataDict)
    }
    
    static private func parseMetaCurrentPhaseEqualTo(item: String, in dataDict: [String: Any]) -> Bool?
    {
        guard let metaDict = dataDict["meta"] as? [String: Any],
            let currentPhaseStatus = metaDict["currentPhase"] as? String else
        {
            return nil
        }
        
        if currentPhaseStatus == item
        {
            return true
        }
        
        return nil
    }
    
}
