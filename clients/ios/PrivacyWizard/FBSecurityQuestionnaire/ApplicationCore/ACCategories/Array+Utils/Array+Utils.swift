//
//  Array+Utils.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 03/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

extension Array {
    
    // MARK: - Public Methods
    static func argSort<T: Hashable>(array: Array<T>) -> Array<T> where T: Comparable {
        var args = Array<T>()
        var argsOfValues = Dictionary<T, Array<Int>>()
        
        var index = 0
        for value in array {
            if argsOfValues[value] != nil {
                argsOfValues[value]?.append(index)
            } else {
                argsOfValues[value] = [index]
            }
            index += 1
        }
        
        let sortedArray = sortedHashableArray(array: array)
        
        for value in sortedArray {
            args.append(value)
        }
        
        return args
    }
    
    static func sortedHashableArray<T: Comparable>(array: Array<T>) -> Array<T> {
        let sortedArray = array.sorted { (e1: T, e2: T) -> Bool in
            return e1 < e2
        }
        
        return sortedArray
    }
    
    static func concatenate<T: Hashable>(array1: Array<T>?, array2: Array<T>?) -> Array<T> {
        var result = [T]()
        
        if let array1 = array1 {
            result.append(contentsOf: array1)
        }
        
        if let array2 = array2 {
            result.append(contentsOf: array2)
        }
        
        return result
    }
}
