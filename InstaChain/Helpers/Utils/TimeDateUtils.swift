//
//  TimeUtils.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit


class TimeDateUtils {
    
    static let DATE_TIME_FORMAT_1 = "yyyy-MM-dd'T'HH:mm:ss"
    
    static var formatter = DateFormatter()

    static func getServerStyleDateInString(_ date : Date) -> String{
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
        
    }
    
    static func getServerStyleDateInString(_ dateString : String) -> String{
        let f = DateFormatter()
        f.dateFormat = "MMM dd, yyyy"
        if let date = f.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        print("error in parsing date")
        return ""
        
    }
    
    static func convertStringToDate(date: String, with format:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: date) ?? Date()
    }
    
    
    static  func utcToLocalTime() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.timeZone = NSTimeZone.local
        let date = dateFormatter.date(from: "2017-09-25T01:00:00")// create   date from string
        print(date)
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        print(timeStamp)
    }
    
    static func getClientStyleDateFromServerString(_ dateString : String) -> String{
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        if let date = f.date(from: dateString.components(separatedBy: " ")[0]) {
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date)
        }

        print("error in parsing date \(dateString)")
        return ""
        
    }
    
   
    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    static func getDateFromServerString(_ dateString : String) -> Date{
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        if let date = f.date(from: dateString.components(separatedBy: " ")[0]) {
            return date
        }
        
        return Date()
        
    }

    static func getShortDateInString(_ date : Date) -> String{
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    static func getStringFrom(_ date : Date, mode:UIDatePickerMode) -> String{
        
        switch (mode) {
        case .date:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            break
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            break
        case .dateAndTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            break
        case .countDownTimer:
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            break
        }
        
        
        
        return formatter.string(from: date)
    }
    
    static func getDateFrom(_ date : String, mode:UIDatePickerMode) -> Date{
        
        switch (mode) {
        case .date:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            break
        case .time:
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            break
        case .dateAndTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            break
        case .countDownTimer:
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            break
        }
        
        return formatter.date(from: date) ?? Date()
    }

    
    
    static func getCurrentDateInlong() -> Double{
        return Date().timeIntervalSince1970
    }
    
    // get the time in ago format like 30 mintues ago
    static func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}




