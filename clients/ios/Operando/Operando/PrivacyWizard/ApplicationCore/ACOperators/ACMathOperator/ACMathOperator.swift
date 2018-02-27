//
//  ACMathOperator.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 03/01/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

import UIKit

class ACMathOperator: NSObject {
    
    // MARK: - Public Methods
    static func multiplyFloat(_ vector: Array<Float>, withMatrix matrix: Array<Array<Float>>) -> Array<Float> {
        var result = Array<Float>()
        
        for _ in 0...vector.count-1 {
            result.append(0)
        }
        
        for i in 0...vector.count-1 {
            for j in 0...vector.count-1 {
                result[i] += vector[j] * matrix[j][i]
            }
        }
        
        return result
    }
    
    static func dimensions<T>(ofMatrix matrix: Array<Array<T>>) -> (rows: Int, columns: Int) {
        let rows = matrix.count
        var columns = 0
        
        if let firstRow = matrix.first {
            columns = firstRow.count
        }
        
        return (rows: rows, columns: columns)
    }
}
