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
    @nonobjc static var formatter: NSDateFormatter? = nil
    
    func withoutTime() -> NSDate
    {
        let comps = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: self)
        return NSCalendar.currentCalendar().dateFromComponents(comps)!
    }
    
    func prettyPrinted() -> String
    {
        if(NSDate.formatter == nil)
        {
            NSDate.formatter = NSDateFormatter();
            NSDate.formatter?.dateFormat = "dd MMMM yyyy";
        }
        
        return NSDate.formatter!.stringFromDate(self);
    }
}