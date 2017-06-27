//
//  EULATextBuilder.swift
//  Operando
//
//  Created by Costin Andronache on 1/10/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

class EULATextBuilder: NSObject {

    
    private static let privacyLevelShortNames: [PrivacyLevelType: String] = [.LocalOnly: "Local-Only", .AggregateOnly: "Only-Aggregate", .DPCompatible: "DP-Compatible", .SelfUseOnly: "Self-Use Only",
                                                                .SharedWithThirdParty: "ThirdParty-Shared", .Unspecified: "Unspecified-Usages"]
    
    
    
    
    private static let privacyLevelDescriptions: [PrivacyLevelType: String] = [.LocalOnly: "The data collected under this privacy level is used locally only.",
                                                                  .AggregateOnly: "Under this privacy level, bulks of data are sent to the vendor of the app, in an anonymised method (i.e. via https) and they may link the data to your account/ id if any.",
                                                                  .DPCompatible: "Bulks of data are sent securely (i.e via https) to the vendor of the app, in a manner that guarantees the data does not link back to your account/id if any.",
                                                                  .SelfUseOnly: "De discutat cu Sinica",
                                                                  .SharedWithThirdParty: "The data is shared with a list of of specfied third parties",
                                                                  .Unspecified: "The vendor of the app does not disclose the manner in which this data is used."]
    
    
    
    
    
    private static let userControlsDescription: [Bool: String] = [true: "As a user, you have control if data is collected from this sensor and/or when.",
                                                                  false: "You do not have control when or how data is collected from this sensor."]
    
    static func generateEULAFrom(scd: SCDDocument) -> NSAttributedString {
        let ms = NSMutableAttributedString()
        
        ms.append(EULATextBuilder.buildIntro(for: scd))
        ms.append(NSAttributedString(string: "\n\n"))
        ms.append(EULATextBuilder.buildDownloadDataPart(for: scd))
        ms.append(NSAttributedString(string: "\n\n"))
        ms.append(EULATextBuilder.buildSensorsPart(for: scd));
        ms.append(EULATextBuilder.buildAccessFrequencyPart(from: scd))
        ms.append(NSAttributedString(string: "\n\n"))
        ms.append(EULATextBuilder.buildUserControlPart(from: scd))
        
        return ms;
    }
    
    
    private static func buildIntro(for scd: SCDDocument) -> NSAttributedString {
        
        let attrString = NSAttributedString(string: "By using \(scd.appTitle) you agree to the following terms of usage of your data that may or may not affect your privacy.")
        
        return attrString
    }
    
    private static func buildDownloadDataPart(for scd: SCDDocument) -> NSAttributedString {
        guard scd.accessedHosts.count > 0 else {
            return NSAttributedString(string: "")
        }
        
        var story: String = "The app downloads data from the following third party sources:\n";
        for urlSource in scd.accessedHosts {
            story.append("\n" + urlSource)
        }
        
        story.append("\n\nDownloading data may be based on your input, for example a search keyword that you type in a text field. You should check the app's Privacy Policy to see whether this data is tracked and / or how it is used.")
        
        return NSAttributedString(string: story)
    }
    
    
    private static func buildSensorsPart(for scd: SCDDocument) -> NSAttributedString {
        guard scd.accessedInputs.count > 0 else {
            return NSAttributedString(string: "")
        }
        
        
        var story: String = ""
        
        let aggregatedSensors = EULATextBuilder.agreggateBasedOnPrivacyLevel(sensors: scd.accessedInputs)
        
        for i in [PrivacyLevelType.LocalOnly, PrivacyLevelType.SelfUseOnly, PrivacyLevelType.DPCompatible,
                  PrivacyLevelType.AggregateOnly, PrivacyLevelType.SharedWithThirdParty, PrivacyLevelType.Unspecified].reversed() {
            if let sensorsAtI = aggregatedSensors[i], sensorsAtI.count > 0 {
                var sensorsNames: String = ""
                sensorsAtI.forEach {sensorsNames.append("\(InputType.namesPerInputType[$0.inputType] ?? ""), ")}
                story.append("The following sensor");
                if sensorsAtI.count > 1 { story.append("s, ")} else {story.append(", ")}
                story.append(sensorsNames)
                if sensorsAtI.count > 1 { story.append("are ") } else {story.append("is ")}
                
                story.append(" located under the privacy level PL\(i), that is \"\(EULATextBuilder.privacyLevelShortNames[i] ?? "")\". ")
                story.append(EULATextBuilder.privacyLevelDescriptions[i] ?? "")
                
                if i == .SharedWithThirdParty {
                    story.append("\nThese are listed as follows:\n\n")
                    sensorsAtI.forEach {
                        story.append("For \(InputType.namesPerInputType[$0.inputType] ?? "")\n\n")
                        story.append(EULATextBuilder.buildLevel5ThirdPartiesText(from: $0))
                    }
                }
                
                story.append("\n");
            }
        }
        
        return NSAttributedString(string: story)
    }
    
    
    
    
    private static func buildLevel5ThirdPartiesText(from sensor: AccessedInput) -> String {
        guard sensor.privacyDescription.thirdParties.count > 0 else {
            return "-There are no third parties specified for this sensor-"
        }
        var story = ""
        sensor.privacyDescription.thirdParties.forEach { tp in
            
            story.append("\(tp.name)\n")
            story.append("\(tp.url)\n\n")
        }
        
        return story
    }
    
    private static func agreggateBasedOnPrivacyLevel(sensors: [AccessedInput]) -> [PrivacyLevelType: [AccessedInput]] {
        var result: [PrivacyLevelType: [AccessedInput]] = [:]
        
        for type in [PrivacyLevelType.AggregateOnly, PrivacyLevelType.DPCompatible, PrivacyLevelType.LocalOnly,
                     PrivacyLevelType.Unspecified, PrivacyLevelType.SharedWithThirdParty, PrivacyLevelType.SelfUseOnly] {
            
                        result[type] = [];
        }
        
        for sensor in sensors {
            result[sensor.privacyDescription.privacyLevel]?.append(sensor)
        }
        
        return result
    }
    
    
    private static func buildAccessFrequencyPart(from document: SCDDocument) -> NSAttributedString {
        var story = ""
        
        var sensorsPerAccessFrequency = EULATextBuilder.aggregateBasedOnAccessFrequensy(sensors: document.accessedInputs)
        
        for af in [AccessFrequencyType.Continuous, AccessFrequencyType.ContinuousIntervals, AccessFrequencyType.SingularSample] {
            if let afArray = sensorsPerAccessFrequency[af], afArray.count > 0 {
                story.append("\n\nThe following sensor")
                if afArray.count > 1 {story.append("s, ")} else {story.append(", ")}
                for sensor in afArray {
                    story.append(InputType.namesPerInputType[sensor.inputType] ?? "")
                    story.append(", ");
                }
                
                if afArray.count > 1 {story.append("have ")} else {story.append("has ")}
                story.append("an access frequency of type \"\(af)\". ")
                story.append(AccessFrequencyType.accessFrequenciesDescriptions[af] ?? "");
            }
        }
        

        return NSAttributedString(string: story)
    }
    
    private static func aggregateBasedOnAccessFrequensy(sensors: [AccessedInput]) -> [AccessFrequencyType: [AccessedInput]] {
        var result: [AccessFrequencyType: [AccessedInput]] = [:]
        for af in [AccessFrequencyType.Continuous, AccessFrequencyType.ContinuousIntervals, AccessFrequencyType.SingularSample] {
            result[af] = []
        }
        
        sensors.forEach { sensor in
            result[sensor.accessFrequency]?.append(sensor)
        }
        
        return result
    }
    
    
    private static func buildUserControlPart(from document: SCDDocument) -> NSAttributedString {
        var perUserControl = EULATextBuilder.aggregateBasedOnUserControl(sensors: document.accessedInputs)
        var story = ""
        let noControlSensors = perUserControl[false] ?? []
        
        if noControlSensors.count > 0 {
            story.append("You do not have control when data is queried or how often, ")
            if noControlSensors.count > 1 {
                story.append("for the following: ")
                for (index, sensor) in noControlSensors.enumerated() {
                    story.append(InputType.namesPerInputType[sensor.inputType] ?? "")
                    if index < noControlSensors.count - 1 {
                        story.append(",")
                    }
                    story.append(" ")
                }
                story.append(".")
            } else {
                guard let first = noControlSensors.first else {
                    return NSAttributedString(string: story)
                }
                story.append("for the \(InputType.namesPerInputType[first.inputType] ?? "") sensor.")
            }
        }
        
        
        
        return NSAttributedString(string: story)
    }
    
    
    
    private static func aggregateBasedOnUserControl(sensors: [AccessedInput]) -> [Bool: [AccessedInput]] {
        var result: [Bool: [AccessedInput]] = [:]
        
        result[true] = []
        result[false] = []
        
        sensors.forEach {
            result[$0.userControl]?.append($0)
        }
        
        return result
    }
    
}
