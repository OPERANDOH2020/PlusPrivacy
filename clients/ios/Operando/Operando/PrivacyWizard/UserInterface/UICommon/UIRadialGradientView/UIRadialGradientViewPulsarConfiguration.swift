//
//  UIRadialGradientViewPulsarConfiguration.swift
//  FBSecurityQuestionnaire
//
//  Created by Catalin Pomirleanu on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

class UIRadialGradientViewPulsarConfiguration: NSObject {
    
    private let minRadius: CGFloat
    private let maxRadius: CGFloat
    private let stepsNo: Int
    private var stepIndex: Int
    private let unitsPerStep: CGFloat
    private var radiusIsIncreasing: Bool
    
    
    init(minRadius: CGFloat, maxRadius: CGFloat, stepsNo: Int) {
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        self.stepsNo = stepsNo
        self.stepIndex = 0
        self.unitsPerStep = maxRadius > minRadius ? (maxRadius - minRadius) / CGFloat(stepsNo) : 0.0
        self.radiusIsIncreasing = true
    }
    
    func getRadius() -> CGFloat {
        if radiusIsIncreasing && stepIndex >= stepsNo {
            radiusIsIncreasing = false
        } else if !radiusIsIncreasing && stepIndex <= 0 {
            radiusIsIncreasing = true
        }
        
        stepIndex = radiusIsIncreasing ? stepIndex + 1 : stepIndex - 1
        return minRadius + CGFloat(stepIndex) * unitsPerStep
    }
    
    func reset() {
        radiusIsIncreasing = true
        stepIndex = 0
    }
}
