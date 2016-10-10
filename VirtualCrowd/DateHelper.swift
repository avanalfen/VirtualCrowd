//
//  DateHelper.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/10/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

class DateHelper {
    static var calendar: NSCalendar {
        return NSCalendar.current as NSCalendar
    }
    
    static var thisMorningAtMidnight: NSDate? {
        var components = calendar.components([.month, .day, .year], from: Date())
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        return calendar.date(from: components) as NSDate?
    }
    
    static var tomorrowMorningAtMidnight: NSDate? {
        var components = calendar.components([.month, .day, .year], from: Date())
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        guard let date = calendar.date(from: components) else {return nil}
        return NSDate(timeInterval: 24*60*60, since: date)
    }
}
