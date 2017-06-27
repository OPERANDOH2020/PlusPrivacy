//
//  PrivacyForBenefitsRepository.swift
//  Operando
//
//  Created by Costin Andronache on 10/15/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation

protocol PrivacyForBenefitsRepository
{
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?)
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?)
    
}

//guard let serviceId = dict["serviceId"] as? Int,
//    let subscribed = dict["subscribed"] as? Bool else {
//        return nil
//}
//self.serviceId = serviceId
//self.subscribed = subscribed
//
//self.benefit = dict["benefit"] as? String
//self.description = dict["description"] as? String
//self.logo = dict["logo"] as? String
//self.voucher = dict["voucher"] as? String
//self.website = dict["website"] as? String
//self.identitifer = dict["identifier"] as? String

class DummyPfbRepository: PrivacyForBenefitsRepository
{
    
    let loremIpsum = "9gag.com will make an exception from its privacy policy agreement by using any of your personally-identifying information one-time, in situations that require transfer of user information to third parties, other than the categories specified below. The third party may use your personally identifying information for their own information, statistics and data aggregation, without the possibility to rent it, sell it or disclose it further to other third parties.\nBelow you can find our regular Privacy Policy Terms of Agreement:\nProtection of Certain Personally-Identifying Information\n9GAG discloses potentially personally-identifying and personally-identifying information only to those of its employees, contractors and affiliated organizations that (i) need to know that information in order to process it on 9GAGís behalf or to provide services available at 9GAGís websites, and (ii) that have agreed not to disclose it to others. Some of those employees, contractors and affiliated organizations may be located outside of your home country; by using 9GAGís websites, you consent to the transfer of such information to them. In addition, in some cases we may choose to buy or sell assets. In these types of transactions, user information is typically one of the business assets that is transferred. Moreover, if 9GAG or substantially all of its assets were acquired, or in the unlikely event that 9GAG goes out of business or enters bankruptcy, user information would be one of the assets that is transferred or acquired by a third party. You acknowledge that such transfers may occur, and that any acquiror of 9GAG may continue to use your personal and non-personal information only as set forth in this policy. Otherwise, 9GAG will not rent or sell potentially personally-identifying and personally-identifying information to anyone.\nOther than to its employees, contractors and affiliated organizations, as described above, 9GAG discloses potentially personally-identifying and personally-identifying information only when required to do so by law, or when 9GAG believes in good faith that disclosure is reasonably necessary to protect the property or rights of 9GAG, third parties or the public at large. If you are a registered user of a 9GAG website and have supplied your email address, 9GAG may occasionally send you an email to tell you about new features, solicit your feedback, or just keep you up to date with whatís going on with 9GAG and its products. If you send us a request (for example via a support email or via one of our feedback mechanisms), we reserve the right to publish it in order to help us clarify or respond to your request or to help us support other users. 9GAG takes all measures reasonably necessary to protect against the unauthorized access, use, alteration or destruction of potentially personally-identifying and personally-identifying information.\nYou should also be aware that if you submit information to chat rooms, forums or message boards such information becomes public information, meaning that you lose any privacy rights you might have with regards to that information. Such disclosures may also increase your chances of receiving unwanted communications."
    
    func getCurrentPfbDealsWith(completion: ((_ deals: [PfbDeal], _ error: NSError?) -> Void)?){
        
        var deals: [PfbDeal] = []
        
        deals.append(PfbDeal(dict: ["serviceId": 1,
                                        "subscribed": false,
                                        "benefit": "\(1) euros",
                                         "description": loremIpsum,
                                         "voucher": "\(1) -------- \(1)",
                                         "logo": "https://maxcdn.icons8.com/Share/icon/androidL/Logos//9gag1600.png",
                                         "website": "https://www.9gag.com"])!)
        
        
        let fbDeal = PfbDeal(dict: ["serviceId": 2,
                                    "subscribed": true,
                                    "benefit": "\(2) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.facebook.com"])!
        
        fbDeal.imageName = "fb";
        deals.append(fbDeal)
        
        let googleDeal = PfbDeal(dict: ["serviceId": 3,
                                    "subscribed": true,
                                    "benefit": "\(3) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.google.com"])!
        
        googleDeal.imageName = "googlePlus";
        deals.append(googleDeal)
        
        let yt = PfbDeal(dict: ["serviceId": 4,
                                    "subscribed": true,
                                    "benefit": "\(2) euros",
            "description": loremIpsum,
            "voucher": "\(2) -------- \(1)",
            "logo": "",
            "website": "https://www.youtube.com"])!
       
        yt.imageName = "youtube"
        deals.append(yt)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion?(deals, nil)
        }
        
    }
    func subscribeFor(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?(PfbDealUpdate(voucher: "555-call-me", subscribed: true), nil)
        }
        
    }
    func unSubscribeFrom(serviceId: Int, withCompletion completion: ((_ update: PfbDealUpdate, _ error: NSError?) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion?(PfbDealUpdate(voucher: nil, subscribed: false), nil)
        }
    }
}
