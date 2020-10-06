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
    
    
    // ----------------------------------------------------
    // MARK: - --------- CLICK LUNCH EXTENSION Methods ---------
    // ----------------------------------------------------
    
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    static func checkDateIsBetweenTime(startTime strStartTime: String, endTIme: String, currentDate: Date, strTimZone : String = "") -> Bool {
        //date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        // Get current time and format it to compare
        //        var currentTime = currentDate

        //1. Get current date whuch is in UTC
        //2. Compare with dateString which u got from server
        //2.1 Convert date string to UTC with provided time zone
        //3 Compare

        var currentTime = dateFormatter.date(from: self.localToUTC(date: dateFormatter.string(from: currentDate), fromFormat: "HH:mm a", toFormat: "yyyy-MM-dd HH:mm:ss", strTimeZone: "\(TimeZone.current.identifier)")) ?? Date()

        if(strTimZone.trimmingCharacters(in: .whitespacesAndNewlines).count != 0)
        {
            currentTime = dateFormatter.date(from: self.localToUTC(date: dateFormatter.string(from: currentDate), fromFormat: "HH:mm a", toFormat: "yyyy-MM-dd HH:mm:ss", strTimeZone: strTimZone)) ?? Date()

        }


        let currentTimeStr = dateFormatter.string(from: currentTime)
        currentTime = dateFormatter.date(from: currentTimeStr)!
        if(strTimZone.trimmingCharacters(in: .whitespacesAndNewlines).count != 0)
        {
            dateFormatter.timeZone = TimeZone(identifier: strTimZone)
        }
        //        modifyTimeToCurrentDate(time: strStartTime)
        guard let dtStartTime =  modifyTimeToCurrentDate(time: strStartTime)//dateFormatter.date(from: strStartTime)
            else
        {
            return false
        }
        guard let dtCloseTime = dateFormatter.date(from: endTIme) else {
            return false
        }
        
        if currentTime >= dtStartTime && currentTime <= dtCloseTime {
            return true
        }
        return false
    }
    
    static func checkDateIsPast(startTime : String = "", endTIme: String, currentDate: Date, strTimeZone : String = "") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = .current
        let strCurrentTime = self.localToUTC(date: dateFormatter.string(from: currentDate), fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd HH:mm:ss", strTimeZone: strTimeZone)


        let dtFormater = DateFormatter()
        dtFormater.dateFormat = "hh:mm a"

        let currentTime = dateFormatter.date(from: strCurrentTime)!
        let timeInString =  dtFormater.string(from: currentTime)


        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: 0)

        guard let currentDateAndTime = modifyTimeToCurrentDate(time: timeInString) else { return false}
        return !currentDateAndTime.isBetween(modifyTimeToCurrentDate(time: startTime) ?? Date(), and: modifyTimeToCurrentDate(time: endTIme) ?? Date())
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func isBetweenAdded30Minutes(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }


    static func modifyTimeToCurrentDate(time: String) -> Date? {

        // ----------------------------------------
        let Cdate = Date()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let result = dateFormatter1.string(from: Cdate)
        //        print("Current date \(result)")
        let datetocompare = "\(result)" + " " + "\(time)"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd hh:mm a"

        dateFormatter2.calendar = NSCalendar.current
        dateFormatter2.timeZone = TimeZone.current

        guard let dtCloseTime = dateFormatter2.date(from: datetocompare) else {
            return nil
        }
        //----------------------------------------
        dateFormatter2.dateFormat = "yyyy-MM-dd hh:mm a"
        print("\ndtCloseTime: \(dateFormatter2.string(from: dtCloseTime))\n")
        return dtCloseTime
    }


    static func localToUTC(date:String, fromFormat: String, toFormat: String, strTimeZone : String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: strTimeZone)
        dateFormatter.dateFormat = toFormat

        return dateFormatter.string(from: dt!)
    }

    static func localToUTC1(date:String, fromFormat: String, toFormat: String, strTimeZone : String) -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.calendar = NSCalendar.current
        //        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: strTimeZone)
        dateFormatter.dateFormat = toFormat

        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        print("\ndt: \(dateFormatter.string(from: dt))\n")
        
        return dt//dateFormatter.string(from: dt!)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func ToLocalStringWithFormat(dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: Date())
        
        return timeStamp
    }
}
