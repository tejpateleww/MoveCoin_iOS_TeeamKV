//
//  Date + Extension.swift
//  Movecoins
//
//  Created by eww090 on 04/12/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import Foundation


extension Date {
    var midnight: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.startOfDay(for: self)
    }
    var midday: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.date(byAdding: .hour, value: 12, to: self.midnight)!
    }
    
    var yesterday: Date {
           return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
       }
       var tomorrow: Date {
           return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
       }
       var dayAfterTomorrow: Date {
           return Calendar.current.date(byAdding: .day, value: 2, to: toDay)!
       }
       var dayBeforeYesterday: Date {
           return Calendar.current.date(byAdding: .day, value: -2, to: toDay)!
       }
       var toDay: Date {
           return Date()
       }
       var noon: Date {
           return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
       }
       var month: Int {
           return Calendar.current.component(.month,  from: self)
       }
       var isLastDayOfMonth: Bool {
           return tomorrow.month != month
       }
       
       var oneHourLater: Date {
           return Calendar.current.date(byAdding: .hour, value: 1, to: toDay)!
       }
       
       var oneHourBefore: Date {
           return Calendar.current.date(byAdding: .hour, value: -1, to: toDay)!
       }
}
