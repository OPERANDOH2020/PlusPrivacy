//
//  AMRecommendedSettings.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 13/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import UIKit

struct AMRecommendedSettings {
    var conditionalProbabilitiesMatrix: [[Double]]
    var settingsToOptions: [[Int]]
    var optionsToSettings: [Int]
    var initialProbabilities: [Double]
    var settingsToNetwork: [String]
    
    init?(dictionary: [String: Any]) {
        conditionalProbabilitiesMatrix = [[Double]]()
        settingsToOptions = [[Int]]()
        optionsToSettings = [Int]()
        initialProbabilities = [Double]()
        settingsToNetwork = [String]()
        
        if let recommenderParameters = dictionary["recommenderParameters"] as? NSDictionary {
            conditionalProbabilitiesMatrix.append(contentsOf: extractMatrix(fromDictionary: recommenderParameters, key: "conditionalProbabilitiesMatrix"))
            settingsToOptions.append(contentsOf: extractMatrix(fromDictionary: recommenderParameters, key: "settingsToOptions"))
            optionsToSettings.append(contentsOf: extractArray(fromDictionary: recommenderParameters, key: "optionsToSettings"))
            initialProbabilities.append(contentsOf: extractArray(fromDictionary: recommenderParameters, key: "initialProbabilities"))
            settingsToNetwork.append(contentsOf: extractArray(fromDictionary: recommenderParameters, key: "settingToNetwork"))
        }
    }
    
    private func extractMatrix<T>(fromDictionary dictionary: NSDictionary, key: String) -> [[T]] {
        var result = [[T]]()
        
        if let matrix = dictionary[key] as? NSArray {
            for valuesArray in matrix {
                if let valuesArray = valuesArray as? NSArray {
                    var array = [T]()
                    for value in valuesArray {
                        if let value = value as? T {
                            array.append(value)
                        }
                    }
                    result.append(array)
                }
            }
        }
        
        return result
    }
    
    private func extractArray<T>(fromDictionary  dictionary: NSDictionary, key: String) -> [T] {
        var result = [T]()
        
        if let valuesArray = dictionary[key] as? NSArray {
            for value in valuesArray {
                if let value = value as? T {
                    result.append(value)
                }
            }
        }
        
        return result
    }
}
