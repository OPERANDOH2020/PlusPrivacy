//
//  SwarmClientHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//
//
//   WARNING: 
//   If you call a method from within the completion block of another method, you must wrap the second call
//   in a DispatchQueue.whateverQueueYouAreCalling.async{}
// 

import Foundation
import SwarmClient

typealias ServerResponseHandler = (_ data: [Any]) -> Void

//func print(_ items: Any ...){
//    
//}

class SwarmClientHelper: NSObject, SwarmClientProtocol,
                        IdentitiesManagementRepository,
                        PrivacyForBenefitsRepository,
                        UsersRepository,
                        UserInfoRepository,
                        NotificationsRepository
{
    static let ServerURL = "https://plusprivacy.com:8080";
    let swarmClient = SwarmClient(connectionURL: SwarmClientHelper.ServerURL);
    
    var whenThereWasAnError: ((_ error: NSError?) -> Void)?
    var whenThereWasAnErrorInCreatingTheSocket: ((_ error: NSError?) -> Void)?
    var whenSockedDidDisconnect: VoidBlock?
    
    private var handlersPerSwarmingName: [SwarmName: ServerResponseHandler] = [:]
    private var errorCallbacks: [CallbackWithError] = []
    
    private var whenAskedForRealIdentityWithCompletion: ((((String, NSError?) -> Void)?) -> Void)?
    
    let workingQueue: DispatchQueue = DispatchQueue.main
    
    override init() {
        super.init()
        self.swarmClient.delegate = self
    }
    
    //MARK: UsersRepository
    
    func loginWith(email: String, password: String, withCompletion completion: UserOperationCallback?)
    {

        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(error, .empty)
            }
            
            
            self.handlersPerSwarmingName[.login] = { dataArray in
                guard let dict = dataArray.first as? [String: Any] else {
                    completion?(OPErrorContainer.errorInvalidServerResponse, .empty)
                    return
                }
                
//                print(dict)
                guard let identityModel = UserIdentityModel(swarmClientLoginReply: dict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(error, .empty)
                    return
                }
                
                self.whenAskedForRealIdentityWithCompletion = { identityCompletion in
                    identityCompletion?(identityModel.email, nil)
                }
                
                completion?(nil, identityModel)
                
            }
        }
        
        swarmClient.startSwarm(SwarmName.login.rawValue, phase: SwarmPhase.start.rawValue, ctor: LoginConstructor.userLogin.rawValue, arguments: [email as AnyObject, password as AnyObject])
    }
    
    func getRealIdentityWith(completion: ((String, NSError?) -> Void)?) {
        self.whenAskedForRealIdentityWithCompletion?(completion)
    }
    
    func logoutUserWith(completion: ((NSError?) -> Void)?) {
        
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(error)
                return
            }
            
            
            self.handlersPerSwarmingName[.login] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let successStatus = SwarmClientResponseParsers.parseLogoutSucceedSuccessStatus(from: dataDict),
                          successStatus == true else {
                          let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.unknownError
                          completion?(error)
                          return
                            
                }
                
                completion?(nil)
                
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.login.rawValue, phase: SwarmPhase.start.rawValue, ctor: LoginConstructor.userLogout.rawValue, arguments: [])
    }
    
    func resetPasswordFor(email: String, completion: CallbackWithError?) {
        workingQueue.async {
            
            self.guestGuestLoginWith(callbackInCaseOfError: completion) {
                self.resetPasswordFor(email: email, callbackInCaseOfError: completion){
                    self.logoutUserWith(completion: { error in
                        if let error = error {
                            completion?(error)
                            return
                        }
                        
                        self.swarmClient.disconnectAndReconnectWith(completion: { failReason in
                            
                            if let failReason = failReason {
                                let error = NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: failReason]);
                                completion?(error)
                                return
                            }
                            
                            completion?(nil)
                        })
                    })
                }
            }
        }
    }
    
    
    private func resetPasswordFor(email: String, callbackInCaseOfError: CallbackWithError?, whenDone: VoidBlock?){
        workingQueue.async {
            self.whenThereWasAnError = { error in
                callbackInCaseOfError?(error)
            }
            
            self.handlersPerSwarmingName[.user] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    callbackInCaseOfError?(OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let _ = SwarmClientResponseParsers.parseResetPasswordSuccessStatus(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.unknownError
                    callbackInCaseOfError?(error)
                    return
                }
                
                whenDone?()
            }
        }
        
        
        self.swarmClient.startSwarm(SwarmName.user.rawValue, phase: SwarmPhase.start.rawValue, ctor: EmailConstructor.resetPassword.rawValue, arguments: [email as AnyObject])
    }
    
    func registerNewUserWith(email: String, password: String, withCompletion completion: CallbackWithError?){
        workingQueue.async {
            let registrationInfo = RegistrationInfo(email: email, password: password)
            
            self.guestGuestLoginWith(callbackInCaseOfError: completion) {
            self.registerUserWith(registrationInfo: registrationInfo, callbackInCaseOfError: completion) {
            self.logoutUserWith(completion: { error in
                if let error = error {
                    completion?(error)
                    return
                }
                
                self.swarmClient.disconnectAndReconnectWith(completion: { failReason in
                    
                    if let failReason = failReason {
                        let error = NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: failReason]);
                        completion?(error)
                        return
                    }
                    
                    completion?(nil)
                    
              })
            })
          }
        }
      }
    }
    
    private func guestGuestLoginWith(callbackInCaseOfError: CallbackWithError?, whenAllIsOk: VoidBlock?){
        
        workingQueue.async {
            self.loginWith(email: "guest@operando.eu", password: "guest") { error, identityModel in
                if let error = error {
                    callbackInCaseOfError?(error)
                    return
                }
                
                whenAllIsOk?()
                
            }
        }
    }
    
    private func registerUserWith(registrationInfo: RegistrationInfo, callbackInCaseOfError: CallbackWithError?, whenAllIsOk: VoidBlock?){
        workingQueue.async {
          
                self.whenThereWasAnError = { error in
                    callbackInCaseOfError?(error)
                }
            
                self.handlersPerSwarmingName[.register] = { dataArray in
                    guard let dict = dataArray.first as? [String: Any] else {
                        callbackInCaseOfError?(OPErrorContainer.errorInvalidServerResponse)
                        return
                    }
                    
                    
                    if let error = SwarmClientResponseParsers.parseErrorIfAny(from: dict) {
                        callbackInCaseOfError?(error)
                        return
                    }
                    
                    
                    whenAllIsOk?()
                    
                }
            }
            
            let params: [String: Any] = ["email": registrationInfo.email, "password": registrationInfo.password, "repeat_password": registrationInfo.password]
            self.swarmClient.startSwarm(SwarmName.register.rawValue, phase: SwarmPhase.start.rawValue, ctor: RegisterConstructor.registerNewUser.rawValue, arguments: [params as AnyObject])
    
    }
    
    private func killSocketAndReconnect(with callback: CallbackWithError?){
        
        workingQueue.async {
            self.swarmClient.disconnectAndReconnectWith(completion: { reason in
                if let reason = reason {
                    let error = NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: reason])
                    callback?(error)
                    return
                }
                
                callback?(nil)
            })
        }
    }
    
    //MARK: UserInfoRepository
    
    func getCurrentUserInfo(in completion: UserInfoCallback?)
    {
        workingQueue.async {
            self.handlersPerSwarmingName[.user] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(.defaultEmpty, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                
                guard let userInfo = SwarmClientResponseParsers.parseUserInfo(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.unknownError
                    completion?(.defaultEmpty, error)
                    return
                }
                completion?(userInfo, nil)
            }
            
            self.whenThereWasAnError = { error in
                completion?(UserInfo.defaultEmpty, error)
                return
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.user.rawValue, phase: SwarmPhase.start.rawValue, ctor: UserConstructor.info.rawValue, arguments: [])
    }
    
    func changeCurrent(password: String, to newPassword: String, withCompletion completion: ((NSError?) -> Void)?) {
        workingQueue.async {
            
            self.handlersPerSwarmingName[.email] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                if let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) {
                    completion?(error)
                    return
                }

                completion?(nil)
            }
            
            self.whenThereWasAnError = { error in
                completion?(error)
            }
        }
        
        
        self.swarmClient.startSwarm(SwarmName.user.rawValue, phase: SwarmPhase.start.rawValue, ctor: UserConstructor.changePassword.rawValue, arguments: [password as AnyObject, newPassword as AnyObject])
    }
    
    //MARK: IdentitiesManagementRepository
    
    func getCurrentIdentitiesListWith(completion: ((_ identitiesListResponse: IdentitiesListResponse, _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(.defaultEmptyResponse, error)
            }
            
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(.defaultEmptyResponse, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let identitiesList = SwarmClientResponseParsers.parseIdentitiesList(from: dataDict) else
                {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(.defaultEmptyResponse, error)
                    return
                }
                
                completion?(identitiesList, nil)
            }
            
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.getMyIdentities.rawValue, arguments: [])
    }
    
    func getCurrentListOfDomainsWith(completion: ((_ domainsList: [Domain], _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?([], error)
            }
            
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?([], OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                guard let domainsList = SwarmClientResponseParsers.parseDomainsList(from: dataDict) else
                {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?([], error)
                    return
                }
                
                completion?(domainsList, nil)
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.listDomains.rawValue, arguments: [])
    }
    
    func generateNewIdentityWith(completion: ((_ generatedIdentity: String, _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?("", error)
            }
            
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?("", OPErrorContainer.errorInvalidServerResponse)
                    return
                    
                }
                guard let generatedIdentity = SwarmClientResponseParsers.parseGeneratedIdentity(from: dataDict) else
                {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?("", error)
                    return
                }
                
                completion?(generatedIdentity, nil)
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.generateIdentity.rawValue, arguments: [])
    }
    
    func add(identity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(false, error)
            }
            
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(false, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                guard let successStatus = SwarmClientResponseParsers.parseAddIdentitySuccessStatus(from: dataDict) else{
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(false, error)
                    return
                }
                
                completion?(successStatus, nil)
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.createIdentity.rawValue, arguments: [["email": identity] as AnyObject ])
    }
    
    func remove(identity: String, withCompletion completion: ((_ nextDefaultIdentity: String, _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?("", error)
            }
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?("", OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let nextDefaultIdentity = SwarmClientResponseParsers.parseNextDefaultIdentity(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?("", error)
                    return
                }
                
                completion?(nextDefaultIdentity, nil)
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.removeIdentity.rawValue, arguments: [["email": identity] as AnyObject ])
    }
    
    func updateDefaultIdentity(to newIdentity: String, withCompletion completion: ((_ success: Bool, _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(false, error)
            }
            
            
            self.handlersPerSwarmingName[.identity] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(false, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let successStatus = SwarmClientResponseParsers.parseUpdateSubstituteIdentitySuccessStatus(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(false, error)
                    return
                }
                
                completion?(successStatus, nil)
            }
            
        }
    
        
        self.swarmClient.startSwarm(SwarmName.identity.rawValue, phase: SwarmPhase.start.rawValue, ctor: IdentityConstructor.updateDefaultSubstituteIdentity.rawValue, arguments: [ ["email": newIdentity] as AnyObject ])
    }
    
    //MARK: Privacy for benefits
    
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?([], error)
            }
            
            self.handlersPerSwarmingName[.pfb] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?([], OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let pfbDeals = SwarmClientResponseParsers.parsePfbDeals(from: dataDict) else{
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?([], error)
                    return
                }
                
                completion?(pfbDeals, nil)
            }
        }
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.getAllDeals.rawValue, arguments: [])

    }
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    {
        workingQueue.async {
            self.whenThereWasAnError = { error in
                completion?(PfbDealUpdate.emptyUnsubscribed, error)
            }
            
            
            self.handlersPerSwarmingName[.pfb] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(PfbDealUpdate.emptyUnsubscribed, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                guard let voucher = SwarmClientResponseParsers.parseVoucherForSubscribedDeal(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(PfbDealUpdate.emptyUnsubscribed, error)
                    return
                }
                
                completion?(PfbDealUpdate(voucher: voucher, subscribed: true), nil)
            }
        }
        
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.acceptPfbDeal.rawValue, arguments: [ serviceId as AnyObject ] )
    }
    
    
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    {
        
        workingQueue.async {
            
            self.whenThereWasAnError = { error in
                completion?(PfbDealUpdate.emptyUnsubscribed, error)
            }
            
            
            self.handlersPerSwarmingName[.pfb] = { dataArray in
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(PfbDealUpdate.emptyUnsubscribed, OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                guard let successStatus = SwarmClientResponseParsers.parseDealUnsubscribedSuccessStatus(from: dataDict)
                else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(PfbDealUpdate.emptyUnsubscribed, error)
                    return
                }
                
                guard successStatus == true else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                    completion?(PfbDealUpdate.emptyUnsubscribed, error)
                    return
                }
                
                completion?(PfbDealUpdate.emptyUnsubscribed, nil)
            }
            
        }
        
        
        self.swarmClient.startSwarm(SwarmName.pfb.rawValue, phase: SwarmPhase.start.rawValue, ctor: PFBConstructor.unsubscribeDeal.rawValue, arguments: [ serviceId as AnyObject ] )
    }
    
    
    
    //MARK: NotificationsRepository
    
    func getAllNotifications(in completion: (([OPNotification], NSError?) -> Void)?) {
        workingQueue.async {
            
            self.whenThereWasAnError = { error in
                completion?([], error)
            }
            
            self.handlersPerSwarmingName[.notification] = { dataArray in
                
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?([], OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let notifications = SwarmClientResponseParsers.parseNonDismissedNotificationsArray(from: dataDict) else {
                    let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.unknownError
                    completion?([], error)
                    return
                }
                
                completion?(notifications, nil)
            }
            
        }
        
        self.swarmClient.startSwarm(SwarmName.notification.rawValue, phase: SwarmPhase.start.rawValue, ctor: NotificationConstructor.getNotifications.rawValue, arguments: [])
    }
    
    func dismiss(notification: OPNotification, withCompletion completion: CallbackWithError?) {
        workingQueue.async {
            self.whenThereWasAnError = completion
            
            self.handlersPerSwarmingName[.notification] = { dataArray in
                
                guard let dataDict = dataArray.first as? [String: Any] else {
                    completion?(OPErrorContainer.errorInvalidServerResponse)
                    return
                }
                
                guard let successStatus = SwarmClientResponseParsers.parseNotificationDismissedSuccessStatus(from: dataDict),
                          successStatus == true
                    else {
                        let error = SwarmClientResponseParsers.parseErrorIfAny(from: dataDict) ?? OPErrorContainer.errorInvalidServerResponse
                        completion?(error)
                        return
                }
                
                completion?(nil)
            }
            
        }
        
        self.swarmClient.startSwarm(SwarmName.notification.rawValue, phase: SwarmPhase.start.rawValue, ctor: NotificationConstructor.dismissNotification.rawValue, arguments: [notification.id as AnyObject, true as AnyObject])
    }
    
    //MARK: SwarmClientProtocol
    
    func didFailedToCreateSocket(_ error: NSError){
        self.whenThereWasAnErrorInCreatingTheSocket?(error)
    }
    
    func socketDidDisconnect() {
        self.whenSockedDidDisconnect?()
    }
    
    func didReceiveData(_ data: [Any]){
        guard let swarmName = SwarmClientHelper.swarmingNameIfAny(from: data) else {
            return
        }
        
        self.handlersPerSwarmingName[swarmName]?(data)
        
        self.removeCallbacksForSwarmCalls()
    }
    
    func didFailOperationWith(reason: String) {
        let error = NSError(domain: SwarmClientErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: reason])
        self.whenThereWasAnError?(error)
        self.removeCallbacksForSwarmCalls()
    }
    
    //internal 
    
    private static func swarmingNameIfAny(from data: [Any]) -> SwarmName? {
        guard let first = data.first as? [String: Any],
        let metaDict = first["meta"] as? [String: Any],
        let swarmingName = metaDict["swarmingName"] as? String,
        let swarmNameResult = SwarmName(rawValue: swarmingName) else {
            return nil
        }
        
        return swarmNameResult
    }
    
    private func removeCallbacksForSwarmCalls(){
        self.handlersPerSwarmingName[.login] = nil
        self.whenThereWasAnError = nil
    }
}
