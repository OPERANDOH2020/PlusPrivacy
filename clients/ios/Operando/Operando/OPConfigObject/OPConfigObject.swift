//
//  OPConfigObject.swift
//  Operando
//
//  Created by Costin Andronache on 6/8/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import WebKit
import PPCommonUI
import PPCommonTypes


class OPConfigObject: NSObject
{
    static let sharedInstance = OPConfigObject()
    private var currentUserIdentity : UserIdentityModel? = nil
    private let swarmClientHelper : SwarmClientHelper = SwarmClientHelper()
    private var userRepository: UsersRepository?
    private var notificationsRepository: NotificationsRepository?
    private var flowController: UIOPFlowController?
    private var dependencies: Dependencies?
    private var actionsPerNotificationType: [NotificationAction: VoidBlock] = [:]
    private let adBlocker = WebAdBlocker();
    
    private func initPropertiesOnAppStart() {
        
        self.userRepository = self.swarmClientHelper
        self.notificationsRepository = self.swarmClientHelper
        //self.adBlocker.beginBlocking()
        
        weak var weakSelf = self
        
        
        let dependencies = Dependencies(identityManagementRepo:  self.swarmClientHelper,
                                         privacyForBenefitsRepo:  self.swarmClientHelper,
                                         userInfoRepo:            self.swarmClientHelper,
                                         notificationsRepository: self.notificationsRepository,
                                         accountCallbacks: self.createAccountCallbacks(),
                                         userSettingsCallbacks: self.createUserSettingsCallbacks(),
            whenTakingActionForNotification: { weakSelf?.dismiss(notification: $1, andTakeAction: $0) },
            whenRequestingNumOfNotifications: { callback in
                weakSelf?.notificationsRepository?.getAllNotifications(in: { notifications, error in
                    if let error = error {
                        OPErrorContainer.displayError(error: error)
                        callback?(0)
                        return
                    }
                    callback?(notifications.count)
                })
            },
            feedbackFormRepo: self.swarmClientHelper,
            myAccountRepo: self.swarmClientHelper, privacyWizzard: self.swarmClientHelper)
        
        self.flowController = UIOPFlowController(dependencies: dependencies)
        self.dependencies = dependencies
        
        weak var flowCntroler = self.flowController
        self.actionsPerNotificationType = [NotificationAction.identitiesMangament:
            {flowCntroler?.displayIdentitiesManagement()},
                                           NotificationAction.privateBrowsing:
                                            {flowCntroler?.displayPrivateBrowsing()},
                                           NotificationAction.privacyForBenefits:
                                            {flowCntroler?.displayPfbDeals()}]
        
        self.applyAndSaveUserSettings(self.currentUserSettings)
    }
    
    func reconnect() {
        self.swarmClientHelper.killSocketAndReconnect { (error) in
            
            if let error = error {
//                OPErrorContainer.displayError(error: error)
            }
            
        }
    }
    
    
    func applicationDidStartInWindow(window: UIWindow)
    {
        
        self.initPropertiesOnAppStart()
        //self.eraseCredentialsIfFreshAppReinstall()
        self.tryAutomaticLogin()
        self.flowController?.setupBaseHierarchyInWindow(window)
        self.flowController?.displayDashboard()
    }
    //'/registerApplication/$deviceId/$applicationId'
    func open(url: URL) -> Bool {
        return false
    }
    
    
    func applicationWillTerminate(app: UIApplication) {
        if self.currentUserSettings.clearWebsiteDataOnExit {
            let bgTaskIdentifier = app.beginBackgroundTask(expirationHandler: nil)
            OPConfigObject.deleteAllWebsiteDataWith {
                app.endBackgroundTask(bgTaskIdentifier);
            }
        }
    }
    
    private func eraseCredentialsIfFreshAppReinstall() {
        let key = "DoNotEraseCredentials"
        if !UserDefaults.standard.bool(forKey: key) {
            _ = CredentialsStore.deleteCredentials()
        }
        
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func tryAutomaticLogin() {
        guard let credentials = CredentialsStore.retrieveLastSavedCredentialsIfAny(), UIDefaultFeatureProvider.userIsLoggedIn() else { return }
        logiWithInfoAndUpdateUI(LoginInfo(email: credentials.username, password: credentials.password, wishesToBeRemembered: false))
        print("Did automatic login with \(credentials.username) and \(credentials.password)")
    }
    
    private func showAlertControllerWithResendEmail(block:VoidBlock?)
    {
        if let messageStatus = CredentialsStore.getPrivateMessageStatus(),
            messageStatus == true {
            
            return
        }
        
        //simple alert dialog
        let alertController = UIAlertController(title: "", message: "Account is not activated", preferredStyle: UIAlertControllerStyle.alert);
        // Add Action
        
        alertController.addAction(UIAlertAction(title: "Resend activation code",
                                                style: UIAlertActionStyle.cancel,
                                                handler: {(alert: UIAlertAction!) in
                                            
                                                block?()
                                                    
        }))
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        let hostController = UIApplication.shared.delegate?.window??.rootViewController?.topMostPresentedControllerOrSelf
        hostController?.present(alertController, animated: true, completion: nil)
    }
    
    private func logiWithInfoAndUpdateUI(_ loginInfo: LoginInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weak var weakSelf = self
        
        ProgressHUD.show()
        self.userRepository?.loginWith(email: loginInfo.email, password: loginInfo.password) { (error, data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
           
            if let error = error {
                
                if error.localizedDescription == "accountNotActivated" {
                    self.showAlertControllerWithResendEmail(block: {
                    
                        self.userRepository?.resendActionEmail(email: loginInfo.email, completion: { (error) in
                                print(error)
                        })
                        
                    })
                }
                else {
                    DispatchQueue.main.async {
                        OPErrorContainer.displayError(error: error);
                    }
                }
                return
            }
            
            self.userRepository?.registerInZone(withCompletion: { (error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        OPErrorContainer.displayError(error: error);
                    }
                }
                
            })
            
            
//            self.swarmClientHelper.retrieveAllSCDsFor(deviceId: "19DADEBF-FC9B-4016-89E6-C7816C7EEF23") { (scds, error) in
//                print(scds)
//                print(error)
//            }
            
//            if loginInfo.wishesToBeRemembered {
//                if let error = CredentialsStore.saveCredentials(username: loginInfo.email, password: loginInfo.password){
//                    OPErrorContainer.displayError(error: error)
//                }
//            }
            
            
            
            if let error = CredentialsStore.saveCredentials(username: loginInfo.email, password: loginInfo.password){
                OPErrorContainer.displayError(error: error)
            }
            
            
            weakSelf?.afterLoggingInWith(identity: data)
        }
    }
    
    
    private func registerWithInfoAndUpdateUI(_ info: RegistrationInfo){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ProgressHUD.show()
        self.userRepository?.registerNewUserWith(email: info.email, password: info.password) { error in
            ProgressHUD.dismiss()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                OPErrorContainer.displayError(error: error);
                return
            }
            OPViewUtils.displayAlertWithMessage(message: Bundle.localizedStringFor(key: kPleaseConfirmEmailLocalizableKey), withTitle: "", addCancelAction: false, withConfirmation: {
                
                CredentialsStore.saveCredentials(username: info.email, password: info.password)
                
                self.flowController?.displayLoginHierarchy()
            })
            
        }
        
    }
    
    private func afterLoggingInWith(identity: UserIdentityModel){
        self.currentUserIdentity = identity
        UserDefaults.setSynchronizedBool(value: true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        self.flowController?.refreshSideMenu()
        self.flowController?.displayDashboard()
    }
    
    
    private func logoutUserAndUpdateUI(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.userRepository?.logoutUserWith { error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            let _ = CredentialsStore.deleteCredentials()
            UserDefaults.setSynchronizedBool(value: false, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
            
            self.flowController?.hideSideMenu()
            self.flowController?.refreshSideMenu()
            self.flowController?.displayDashboard()
        }
    }
    
    private func dismiss(notification: OPNotification, andTakeAction action: NotificationAction){
        
        self.dependencies?.notificationsRepository?.dismiss(notification: notification) { error in
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            if let action = self.actionsPerNotificationType[action] {
                action()
            } else {
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: "Will be available soon")
            }
        }
    }
    
    private func resetPasswordAndUpdateUIFor(email: String) {
        ProgressHUD.show()
        self.userRepository?.resetPasswordFor(email: email) { error in
            ProgressHUD.dismiss()
            
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            OPViewUtils.showOkAlertWithTitle(title: "", andMessage: Bundle.localizedStringFor(key: Bundle.localizedStringFor(key: kPleaseCheckEmailResetLocalizableKey)))
        }
    }
    
    private func createPasswordChangeCallback() -> PasswordChangeCallback {
        weak var weakSelf = self
        
        return { oldPassword, newPassword, successCallback in
            
            ProgressHUD.show()
            weakSelf?.userRepository?.changeCurrent(password: oldPassword, to: newPassword, withCompletion: { error in
                ProgressHUD.dismiss()
                if let error = error {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                
                OPViewUtils.showOkAlertWithTitle(title: "", andMessage: Bundle.localizedStringFor(key: kPasswordChangedSuccesfullyLocalizableKey))
                if let error = CredentialsStore.updatePassword(to: newPassword) {
                    OPErrorContainer.displayError(error: error)
                    return
                }
                successCallback?()
            })
        }
    }
    
    private func createAccountCallbacks() -> AccountCallbacks {
        
        weak var weakSelf = self

        return AccountCallbacks(loginCallback: { info in
            weakSelf?.logiWithInfoAndUpdateUI(info)
            }, logoutCallback: {
                weakSelf?.logoutUserAndUpdateUI()
            },
               registerCallback: { info in
                weakSelf?.registerWithInfoAndUpdateUI(info)
            },
               forgotPasswordCallback: { email in
                weakSelf?.resetPasswordAndUpdateUIFor(email: email)
        }, passwordChangeCallback: weakSelf?.createPasswordChangeCallback())
    }
    
    private var currentUserSettings: UserSettingsModel {
        guard let savedSettings = UserSettingsModel.createFrom(defaults: UserDefaults.standard) else {
            return UserSettingsModel.defaultSettings
        }
        
        return savedSettings
    }
    
    private func applyAndSaveUserSettings(_ settings: UserSettingsModel){
        settings.writeTo(defaults: UserDefaults.standard)
//        self.adBlocker.adBlockingEnabled = settings.enableAdBlock
//        self.adBlocker.protectionEnabled = !settings.disableWebsiteProtection
        
        self.adBlocker.adBlockingEnabled = false
        self.adBlocker.protectionEnabled = false
    }
    
    private func createUserSettingsCallbacks() -> UserSettingsModelCallbacks {
        return UserSettingsModelCallbacks(retrieveCallback: { [unowned self] () -> UserSettingsModel in
            return self.currentUserSettings
        }, updateCallback: { [unowned self] settings in
            self.applyAndSaveUserSettings(settings)
        })
    }
    
    private static func deleteAllWebsiteDataWith(callback: @escaping VoidBlock) {
        if #available(iOS 9.0, *) {
            let dataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
            WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: callback)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private static func pathForFile(named: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        if let documentsDirectory = paths.first{
            var plistPathNSString = documentsDirectory as NSString
            plistPathNSString = plistPathNSString.appendingPathComponent(named) as NSString;
            return plistPathNSString as String;
        }
        return named
    }
}
