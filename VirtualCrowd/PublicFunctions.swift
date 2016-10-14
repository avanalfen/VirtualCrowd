//
//  PublicFunctions.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/7/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import Foundation

public func date(date: Date?) -> (time: String, shortStyle: String, mediumStyle: String, longStyle: String, relativeStyle:String, timeR: String) {
    
    var currentDate: Date
    
    if date == nil {
        currentDate = Date()
    } else {
        currentDate = date!
    }
    
    let shortStyle = DateFormatter()
    let mediumStyle = DateFormatter()
    let LongStyle = DateFormatter()
    let timeStyle = DateFormatter()
    let relative = DateFormatter()
    let timeFormatter = DateFormatter()
    
    shortStyle.locale = NSLocale(localeIdentifier: "America/Denver") as Locale!
    mediumStyle.locale = NSLocale(localeIdentifier: "America/Denver") as Locale!
    LongStyle.locale = NSLocale(localeIdentifier: "America/Denver") as Locale!
    
    timeStyle.dateFormat = "HH:mm:ss"
    timeFormatter.timeStyle = .short
    
    shortStyle.dateStyle = DateFormatter.Style.short
    mediumStyle.dateStyle = DateFormatter.Style.medium
    LongStyle.dateStyle = DateFormatter.Style.long
    relative.dateStyle = .medium
    relative.doesRelativeDateFormatting = true
    
    let time = timeStyle.string(from: currentDate)
    let shortStyleDate = shortStyle.string(from: currentDate)
    let mediumStyleDate = mediumStyle.string(from: currentDate)
    let longStyleDate = LongStyle.string(from: currentDate)
    let relativeDate = relative.string(from: currentDate)
    let timeFormat = timeFormatter.string(from: currentDate)
    
    return (time, shortStyleDate, mediumStyleDate, longStyleDate,relativeDate, timeFormat)
}
