//
//  ACPollutionManager.swift
//  Operando
//
//  Created by Cristi Sava on 25/04/2018.
//  Copyright © 2018 Operando. All rights reserved.
//

import Foundation

class ACPoluttionManager {
    
    static let shared : ACPoluttionManager = ACPoluttionManager()
    
    var permissionRisks = NSMutableDictionary()
    
    private var permissionColors: [String] = []
    
    func getColorForPermissionsScore(score: Int) -> UIColor {
        
        if score == 0 {
            return UIColor.init(hexString: self.permissionColors[score])
        }
        else if score >= 10 {
             return UIColor.init(hexString: self.permissionColors.last!)
        }
        return UIColor.init(hexString: self.permissionColors[score-1])
    }
    
    func getPermissionColor(permission:String) -> UIColor {

        if let permScore = self.permissionRisks[permission] as? Int {
            return getColorForPermissionsScore(score: permScore)
        }
        else {
            return UIColor.init(hexString: self.permissionColors[3])
        }
    }

    func calculatePollution(permissions: [String]) -> Int {
        
        var over7 = false
        var counter = 0
        var totalScore: Int = 0
        for permission in permissions {
            
            if let permScore = self.permissionRisks[permission] as? Int {
                
                if permScore > 7 {
                    counter = counter + 1
                    over7 = true
                }
               
                totalScore = totalScore + permScore
            }
            
            if over7 == true {
                totalScore = totalScore + 5 * counter
            }
            
            if counter != 0 {
                totalScore = totalScore / counter
            }
        }
        
        if totalScore > 10 {
            totalScore = 10
        }
        
        return totalScore
    }
    
    private init () {
        self.initPermissionRiscks()
        self.initPermissionColors()
    }
    
    private func initPermissionColors() {
        
        self.permissionColors.append("#2dc113")
        self.permissionColors.append("#3366FF")
        self.permissionColors.append("#33FF66")
        self.permissionColors.append("#CCFF66")
        self.permissionColors.append("#FFFF66")
        self.permissionColors.append("#FFFF00")
        self.permissionColors.append("#FFCC00")
        self.permissionColors.append("#FF9900")
        self.permissionColors.append("#FF6600")
        self.permissionColors.append("#FF0000")
    }
    
    private func initPermissionRiscks() {
        permissionRisks.setValue(1,  forKey: "Public");
        permissionRisks.setValue(2,  forKey: "Public profile (required)");
        permissionRisks.setValue(9,  forKey: "Friends list");
        permissionRisks.setValue(9,  forKey: "Birthday");
        permissionRisks.setValue(7,  forKey: "Email address");
        permissionRisks.setValue(10,  forKey: "Post on your behalf");
        permissionRisks.setValue(9,  forKey: "Work history");
        permissionRisks.setValue(7,  forKey: "Education history");
        permissionRisks.setValue(7,  forKey: "Current city");
        permissionRisks.setValue(8,  forKey: "Photos");
        permissionRisks.setValue(8,  forKey: "Videos");
        permissionRisks.setValue(7,  forKey: "Likes");
        permissionRisks.setValue(10,  forKey: "Send Facebook notifications");
        permissionRisks.setValue(9,  forKey: "Custom friends lists");
        permissionRisks.setValue(3,  forKey: "Website");
        permissionRisks.setValue(6,  forKey: "Personal description");
        permissionRisks.setValue(7,  forKey: "Hometown");
        permissionRisks.setValue(9,  forKey: "Religious and political views");
        permissionRisks.setValue(10,  forKey: "Friend list (required)");
        permissionRisks.setValue(7,  forKey: "Email address (required)");
        permissionRisks.setValue(10,  forKey: "Manage your Pages");
        permissionRisks.setValue(7,  forKey: "Show a list of the Pages you manage");
        permissionRisks.setValue(10,  forKey: "Publish as Pages you manage");
        permissionRisks.setValue(9,  forKey: "Timeline posts");
        permissionRisks.setValue(10,  forKey: "Relationships");
        permissionRisks.setValue(7,  forKey: "Books activity");
        permissionRisks.setValue(7,  forKey: "Status updates");
        permissionRisks.setValue(9,  forKey: "Events");
        permissionRisks.setValue(9,  forKey: "Access the groups you manage");
        permissionRisks.setValue(9,  forKey: "Friends");
        permissionRisks.setValue(9,  forKey: "Relationship interests");
        permissionRisks.setValue(9,  forKey: "Groups");
        permissionRisks.setValue(10,  forKey: "Manage your business");
        permissionRisks.setValue(10,  forKey: "Manage your events");
        permissionRisks.setValue(2,  forKey: "Only me");
        permissionRisks.setValue(9,  forKey: "Birthday (required)");
        permissionRisks.setValue(7,  forKey: "Current city (required)");
        permissionRisks.setValue(9,  forKey: "Date of birth");
        
        //google
        permissionRisks.setValue(8,  forKey: "Know the list of people in your circles, your age range, and language");
        permissionRisks.setValue(7,  forKey: "View your email address");
        permissionRisks.setValue(3,  forKey: "View your basic profile info");
        permissionRisks.setValue(7,  forKey: "View your approximate age");
        permissionRisks.setValue(3,  forKey: "View your language preferences");
        permissionRisks.setValue(10,  forKey: "View and manage Google Drive files and folders that you have opened or created with this app");
        permissionRisks.setValue(10,  forKey: "Add itself to Google Drive");
        permissionRisks.setValue(10,  forKey: "Manage your contacts");
        permissionRisks.setValue(6,  forKey: "Manage your game activity for this game");
        permissionRisks.setValue(10,  forKey: "View and manage its own configuration data in your Google Drive");
        permissionRisks.setValue(10,  forKey: "Read, send, delete, and manage your email");
        permissionRisks.setValue(10,  forKey: "Manage your calendars");
        permissionRisks.setValue(8,  forKey: "Know who you are on Google");
        permissionRisks.setValue(10,  forKey: "Full account access");
        permissionRisks.setValue(9,  forKey: "View the names and email addresses of your Google Contacts");
        permissionRisks.setValue(10,  forKey: "View and send chat messages");
        permissionRisks.setValue(10,  forKey: "View and manage any of your documents and files in Google Drive");
        permissionRisks.setValue(10,  forKey: "View and manage the files in your Google Drive");
        permissionRisks.setValue(10,  forKey: "View your Chrome Remote Desktop computers");
        permissionRisks.setValue(2, forKey: "Google Pay Sandbox");
        permissionRisks.setValue(2, forKey: "Google Payments");
        permissionRisks.setValue(2, forKey: "View and manage your Chrome Web Store apps and extensions");
        permissionRisks.setValue(2, forKey: "View your Chrome Web Store apps and extensions");
        
        //twitter
        permissionRisks.setValue(2,  forKey: "read-only");
        permissionRisks.setValue(6,  forKey: "read and write");
        permissionRisks.setValue(10,  forKey: "read, write, and direct messages");
    }
    
}
