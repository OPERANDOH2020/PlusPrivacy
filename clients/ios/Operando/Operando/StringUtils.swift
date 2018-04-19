//
//  StringUtils.swift
//  Operando
//
//  Created by RomSoft on 12/8/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import Foundation
extension String {
    
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
        func capturedGroups(withRegex pattern: String) -> [String] {
            var results = [String]()
            
            var regex: NSRegularExpression
            do {
                regex = try NSRegularExpression(pattern: pattern, options: [])
            } catch {
                return results
            }
            
            let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
            
            guard let match = matches.first else { return results }
            
            let lastRangeIndex = match.numberOfRanges - 1
            guard lastRangeIndex >= 1 else { return results }
            
            for i in 1...lastRangeIndex {
                let capturedGroupIndex = match.rangeAt(i)
                let matchedString = (self as NSString).substring(with: capturedGroupIndex)
                results.append(matchedString)
            }
            
            return results
        }
    
    
    static func isNullEmptyOrSpace(_ string: String?) -> Bool {
        guard let string = string else { return true }
        return string == "" || string == " "
    }
    
    static func isEmptyOrSpace(_ string: String) -> Bool {
        return string == "" || string == " "
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func camelCaseToWords() -> String {
        
        return unicodeScalars.reduce("") {
            
            if CharacterSet.uppercaseLetters.contains($1) == true {
                
                return ($0 + " " + String($1))
            }
            else {
                
                return $0 + String($1)
            }
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
}
