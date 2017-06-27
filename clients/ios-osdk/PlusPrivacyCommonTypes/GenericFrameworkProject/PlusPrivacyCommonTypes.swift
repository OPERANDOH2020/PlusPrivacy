//
//  PlusPrivacyCommonTypes.swift
//  Operando
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation

@objc
public class BaseStringEnum: NSObject {
    private(set) public var rawValue: String
    internal init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? BaseStringEnum,
            other.rawValue == self.rawValue else {
                return false
        }
        
        return true
    }
    
    public override var hash: Int {
        return self.rawValue.hash
    }
    
    public override var hashValue: Int {
        return self.rawValue.hash
    }
}

@objc
public class AccessFrequencyType: BaseStringEnum {
    public static let SingularSampleRawValue = "singularSample"
    public static let ContinuousRawValue = "continuously"
    public static let ContinuousIntervalsRawValue = "continuousIntervals"
    

    
    override internal init?(rawValue: String){
        guard rawValue == AccessFrequencyType.SingularSampleRawValue ||
              rawValue == AccessFrequencyType.ContinuousRawValue ||
            rawValue == AccessFrequencyType.ContinuousIntervalsRawValue else {
                return nil
        }
        
        super.init(rawValue: rawValue)
    }
    
    public static func createFrom(rawValue: String) -> AccessFrequencyType? {
        return AccessFrequencyType(rawValue: rawValue)
    }
    
    
    public static var Continuous: AccessFrequencyType {
        return AccessFrequencyType(rawValue: ContinuousRawValue)!
    }
    
    public static var SingularSample: AccessFrequencyType {
        return AccessFrequencyType(rawValue: SingularSampleRawValue)!
    }
    
    public static var ContinuousIntervals:AccessFrequencyType {
        return AccessFrequencyType(rawValue: ContinuousIntervalsRawValue)!
    }
    

    
    public static let accessFrequenciesDescriptions: [AccessFrequencyType: String] = [ AccessFrequencyType.Continuous : "The data is collected continuously throughout the lifetime of the app.",
                                                                           AccessFrequencyType.ContinuousIntervals: "The data is collected continuously in time intervals, triggered by certain events (e.g when the you presss Record/Stop or enter in a geofencing area)",
                                                                           AccessFrequencyType.SingularSample: "Only one sample of data is collected at certain times."]

}


@objc
public class InputType: BaseStringEnum {
    public static let LocationRawValue = "loc"
    public static let MicrophoneRawValue = "mic"
    public static let CameraRawValue = "cam"
    public static let GyroscopeRawValue = "gyro"
    public static let AccelerometerRawValue = "acc"
    public static let ProximityRawValue = "prox"
    public static let TouchIDRawValue = "touchID"
    public static let BarometerRawValue = "bar"
    public static let ForceRawValue = "force"
    public static let PedometerRawValue = "pedo"
    public static let MagnetometerRawValue = "magneto"
    public static let ContactsRawValue = "contacts"
    public static let BatteryRawValue = "bat"
 
    private static let rawValuesArray: [String] = [InputType.LocationRawValue,
                                                   InputType.MicrophoneRawValue,
                                                   InputType.CameraRawValue,
                                                   InputType.GyroscopeRawValue,
                                                   InputType.AccelerometerRawValue,
                                                   InputType.ProximityRawValue,
                                                   InputType.TouchIDRawValue,
                                                   InputType.BarometerRawValue,
                                                   InputType.ForceRawValue,
                                                   InputType.PedometerRawValue,
                                                   InputType.MagnetometerRawValue,
                                                   InputType.ContactsRawValue,
                                                   InputType.BatteryRawValue]
    
    internal override init?(rawValue: String) {
        guard InputType.rawValuesArray.contains(rawValue) else {
            return nil 
        }
        
        super.init(rawValue: rawValue)
    }
    
    public static var Location: InputType {
        return InputType(rawValue: LocationRawValue)!
    }
    
    public static var Microphone: InputType {
        return InputType(rawValue: MicrophoneRawValue)!
    }
    
    public static var Camera: InputType {
        return InputType(rawValue: CameraRawValue)!
    }
    
    public static var Gyroscope: InputType {
        return InputType(rawValue: GyroscopeRawValue)!
    }
    
    public static var Accelerometer: InputType {
        return InputType(rawValue: AccelerometerRawValue)!
    }
    
    public static var Proximity: InputType {
        return InputType(rawValue: ProximityRawValue)!
    }
    
    public static var TouchID: InputType {
        return InputType(rawValue: TouchIDRawValue)!
    }
    
    public static var Barometer: InputType {
        return InputType(rawValue: BarometerRawValue)!
    }
    
    public static var Force: InputType {
        return InputType(rawValue: ForceRawValue)!
    }
    
    public static var Pedometer: InputType {
        return InputType(rawValue: PedometerRawValue)!
    }
    
    public static var Magnetometer: InputType {
        return InputType(rawValue: MagnetometerRawValue)!
    }
    
    public static var Contacts: InputType {
        return InputType(rawValue: ContactsRawValue)!
    }
    
    public static var Battery: InputType {
        return InputType(rawValue: BatteryRawValue)!
    }
    
    public static func createFrom(rawValue: String) -> InputType? {
        return InputType(rawValue: rawValue)
    }
    
    
    public static let namesPerInputType: [InputType: String] = [ InputType.Camera : "Camera",
                                                               InputType.Accelerometer : "Accelerometer",
                                                               InputType.Location : "Location",
                                                               InputType.Gyroscope: "Gyroscope",
                                                               InputType.Barometer: "Barometer",
                                                               InputType.Force: "Force touch",
                                                               InputType.Proximity: "Proximity",
                                                               InputType.TouchID: "TouchID",
                                                               InputType.Microphone: "Microphone",
                                                               InputType.Pedometer: "Pedometer",
                                                               InputType.Magnetometer: "Magnetometer",
                                                               InputType.Contacts: "Contacts",
                                                               InputType.Battery: "Battery"];
    
    

}

@objc
public class ThirdParty: NSObject {
    public let name: String
    public let url: String
    
    public init?(dict: [String: Any]) {
        guard let name = dict["name"] as? String,
            let url = dict["url"] as? String  else {
                return nil
        }
        
        self.name = name
        self.url = url
    }
    
}

@objc
public enum PrivacyLevelType: Int {
    case LocalOnly = 1
    case AggregateOnly = 2
    case DPCompatible = 3
    case SelfUseOnly = 4
    case SharedWithThirdParty = 5
    case Unspecified = 6
    
}

@objc
public class PrivacyDescription: NSObject {
    public let privacyLevel: PrivacyLevelType
    public let thirdParties: [ThirdParty]
    
    public init?(dict: [String: Any]) {
        guard let privacyLevelRawValue = dict["privacyLevel"] as? Int,
            let privacyLevel = PrivacyLevelType(rawValue: privacyLevelRawValue)
             else {
                return nil
        }
        
        
        var parties: [ThirdParty] = []
        
        self.privacyLevel = privacyLevel
        if let thirdPartiesDictArray = dict["thirdParties"] as? [[String: Any]] {
            thirdPartiesDictArray.forEach { if let tp = ThirdParty(dict: $0) { parties.append(tp)} }
        }
        
        self.thirdParties = parties
    }
}

@objc
public class AccessedInput: NSObject {
    public let inputType: InputType
    public let privacyDescription: PrivacyDescription
    public let accessFrequency: AccessFrequencyType
    public let userControl: Bool
    
    public init?(dict: [String: Any]) {
        guard let inputTypeRawValue = dict["inputType"] as? String,
            let inputType = InputType.createFrom(rawValue: inputTypeRawValue),
            let pdDict = dict["privacyDescription"] as? [String: Any],
            let privacyDescription = PrivacyDescription(dict: pdDict),
            let accessFrequencyRawValue = dict["accessFrequency"] as? String,
            let accessFrequency = AccessFrequencyType.createFrom(rawValue: accessFrequencyRawValue),
            let userControl = dict["userControl"] as? Bool
            else {
                return nil
        }
        
        self.accessFrequency = accessFrequency
        self.inputType = inputType
        self.privacyDescription = privacyDescription
        self.userControl = userControl
    }
    
    
    public static func buildFromJsonArray(_ array: [[String: Any]]) -> [AccessedInput]? {
        var result: [AccessedInput] = []
        
        for dict in array {
            guard let item = AccessedInput(dict: dict) else {
                return nil
            }
            result.append(item)
        }
        
        return result
    }
}


@objc
public class SCDDocument: NSObject {
    public let appTitle: String
    public let bundleId: String
    public let appIconURL: String?
    
    public let accessedHosts: [String]
    public let accessedInputs: [AccessedInput]
    
    internal init?(scd: [String: Any]) {
        guard let title = scd["title"] as? String,
            let bundleId = scd["bundleId"] as? String,
            let accessedHosts = scd["accessedHosts"] as? [String],
            let accessedSensorsDictArray = scd["accessedInputs"] as? [[String: Any]],
            let accessedSensors = AccessedInput.buildFromJsonArray(accessedSensorsDictArray) else {
                return nil
        }
        
        self.appTitle = title
        self.bundleId = bundleId
        self.accessedInputs = accessedSensors
        self.accessedHosts = accessedHosts
        self.appIconURL = scd["appIconURL"] as? String
    }
    
}
