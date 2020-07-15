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
        cal.timeZone = TimeZone.current  // TimeZone(identifier: "Europe/Paris")!
        return cal.startOfDay(for: self)
    }
    var midday: Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current  // TimeZone(identifier: "Europe/Paris")!
        return cal.date(byAdding: .hour, value: 12, to: self.midnight)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
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
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
    
    func getFormattedDate(dateFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz" // This formate is input formated .
        let str = dateFormatter.string(from: self)
        
        let formateDate = dateFormatter.date(from:str)!
        dateFormatter.dateFormat = dateFormate // Output Formated
        
        print ("Print :\(dateFormatter.string(from: formateDate))")
        return dateFormatter.string(from: formateDate)
    }
}
