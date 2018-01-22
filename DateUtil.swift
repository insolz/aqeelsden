//
//  DateUtil.swift
//  Neighbourhoods
//
//  Created by Aqeel on 20/01/2017.
//  Copyright © 2017 Hanan. All rights reserved.
//

import Foundation

open class DateUtil {
    fileprivate static var dateFormatter:DateFormatter? = nil
    open static func getDateFormatter() -> DateFormatter {
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "dd-MM-yyyy"
        }
        return dateFormatter!
    }
    
    open static func getDate(_ date:Date) -> String {
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM, yyyy"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        
        let result = "\(day) \(newDate)"
        return result
//        return day + " " + newDate
    }
    
    open static func getMinutesDifferenceBetween(startDate : Date , endDate : Date) -> Int
    {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.minute], from: startDate, to: endDate)
        return components.minute!
    }
    
    open static func getDateWithMonthAndDay(_ date:Date) -> String
    {
        // Formate
//        let dateFormate = DateFormatter()
        let dateFormate = getDateFormatter()
        dateFormate.dateFormat = "MMM dd, yyyy"
        let dateWithMonthName = dateFormate.string(from: date)
        
        
        let day = DateUtil.getDay(date)
        
        let result = "\(day) \(dateWithMonthName) (\(DateUtil.getTimeFromDate(date)))"
        return result
//        return day + ", " + dateWithMonthName + " - " +
        
    }
    
//    open static func getDeliveryCellTime( _ date : Date) -> String
//    {
//        // Formate
//        let dateFormate = DateFormatter()
//        dateFormate.dateFormat = "MMMM dd, yyyy"
//        let dateWithMonthName = dateFormate.string(from: date)
//        
//        return dateWithMonthName + "   " + DateUtil.getTimeFromDate(date)
//    }
    
    open static func getDay(_ date:Date) -> String
    {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.weekday], from: date)
        let day = anchorComponents.weekday!
        
        switch day {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            print("Error fetching days")
            return "Day"
        }
    }
    
    open static func getsimpleDate(_ date:Date) -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        let string = dateFormate.string(from: date)
        
        return  string
    }
    
//    open static func getEarningTopDate(_ date:Date) -> String {
//        let dateFormate = DateFormatter()
//        dateFormate.dateFormat = "dd-MM-yyyy"
//        let string = dateFormate.string(from: date)
//        
//        return  string
//    }
//    
    open static func getEarningDateFormat(date : Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: date)
    }
    
    open static func dailyEarningDate(date : Date) -> String
    {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMM yyy"
        let string = dateFormate.string(from: date)
        
        return  string
    }
    
    open static func weeklyAndMonthlyDate(startDate : Date , endDate : Date) -> String
    {
    
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMM - "
        let cur = dateFormate.string(from: startDate)
        
        dateFormate.dateFormat = "dd MMM yyyy"
        
        let end = dateFormate.string(from: endDate)
        
        return  cur + end
    }
    
    static func getTimeFromDate(_ date:Date) -> String {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
//        let time = "\(hour):\(minutes):\(seconds)"
//        return (time)
        
        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MMM h:mm a"
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
//        formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    static func getDeliveryTimeFrom(date : Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM      h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        //        formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    static func getDeliveryDate(date : Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        //        formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: date)
        return dateString

    }
}


// Declared in Constants.swift
//extension Double
//{
//    /// Rounds the double to decimal places value
//    func roundTo(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return (self * divisor).rounded() / divisor
//    }
//    
//    func roundedStringValue () -> String
//    {
//        return String(format: "%.4f", self)
//    }
//    
//    func twoDecimalValue() -> String
//    {
//        return String(format: "%.2f", self)
//    }
//}


extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
    
    func isEqualTo ( anotherDate : Date, ignoreTime : Bool) -> Bool
    {
        var comparisonResult : ComparisonResult
        var granularity = Calendar.Component.minute
    
        if (ignoreTime)
        {
            granularity = .day
        }

        comparisonResult  = Calendar.current.compare(self, to: anotherDate, toGranularity: granularity)
        
        if comparisonResult == .orderedSame
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // Time Difference 
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func offsetFullName(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) Years"   }
        if months(from: date)  > 0 { return "\(months(from: date)) Months"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) Weeks"   }
        if days(from: date)    > 0 { return "\(days(from: date)) Days"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) Hrs"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) Mins" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) Sec" }
        return ""
    }
    
    func daysDifference(date : Date) -> Bool
    {
        if days(from: date)  > 0
        {
            return true
        }
        else if days(from: date) < 0
        {
            return false
        }
        else
        {
            return false
        }
    }

    var startOfWeek: Date? {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear  ,.weekOfMonth], from: self))
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    func lastDayOfMonth(now : Date) -> Date
    {
        let calendar = Calendar.current
//        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        let range = calendar.range(of: .day, in: .month, for: now)!
        components.day = range.upperBound - 1
        return calendar.date(from: components)!
    }
    
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
