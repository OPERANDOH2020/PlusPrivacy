//
//  NSDate+Utilities.swift
//  Operando
//
//  Created by Costin Andronache on 6/17/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import Foundation


extension NSDate
{
    @nonobjc static var formatter: DateFormatter? = nil
    
    func prettyPrinted() -> String
    {
        if(NSDate.formatter == nil)
        {
            NSDate.formatter = DateFormatter();
            NSDate.formatter?.dateFormat = "dd MMMM yyyy";
        }
        
        return NSDate.formatter!.string(from: self as Date);
    }
}
