//
//  IMBPrettyDateLabel.swift
//  Imbaggaarm
//
//  Created by Tai Duong on 4/11/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import UIKit
import SwiftDate

class IMBPrettyDateLabel {
    
    static func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        
        formatter.calendar = Calendar.current
        
        return formatter.string(from: duration)!
    }
    
    private static var prettyPrintedDateFormatter: DateFormatter = {
        let temp = DateFormatter()
        temp.calendar = Calendar.current
        temp.dateFormat = "dd • MMMM • yyyy"
        return temp
    }()
    
    private static var fullDateFormatter: DateFormatter = {
        let temp = DateFormatter()
        temp.calendar = Calendar.current
        temp.dateFormat = "dd • MM • yyyy HH:mm:ss"
        return temp
    }()
    
    static func handleGetFormatDateOfPost(datePost: Date, showFullDate: Bool = false) -> String {
        let duration = Date().timeIntervalSince(datePost)
        let result = format(duration: duration)
        
        //print(result)
        if duration < 86400 {
            if duration < 60 {
                return "Vừa xong"
            }
            return result + " trước"
        } else {
            if duration > 86400 * 365 {
                return prettyPrintedDateFormatter.string(from: datePost)
            } else {
                if !showFullDate {
                    return Calendar.current.component(.day
                        , from: datePost).toString() + " tháng " + Calendar.current.component(.month, from: datePost).toString()
                }
                return fullDateFormatter.string(from: datePost)
            }
        }
    }
    
    static func getStringDate(from timeInterval: UInt) -> String {
        
        let date = DateInRegion.init(seconds: TimeInterval(timeInterval), region: .current)
        let hour = date.dateComponents.hour!
        let minute = date.dateComponents.minute!


        let hourStr = String.init(format: "%02d", hour)
        let minuteStr = String.init(format: "%02d", minute)

        let timeStr = hourStr + ":" + minuteStr
        if date.isToday {
            return timeStr
        }

        if date.isYesterday {
            return "Hôm qua, " + timeStr
        }

        if date.compare(.isThisWeek) {
            let wDay = date.weekday
            var weekdayName = ""
            switch WeekDay.init(rawValue: wDay)! {
            case WeekDay.monday:
                weekdayName = "Th 2"
            case WeekDay.tuesday:
                weekdayName = "Th 3"
            case WeekDay.wednesday:
                weekdayName = "Th 4"
            case WeekDay.thursday:
                weekdayName = "Th 5"
            case WeekDay.friday:
                weekdayName = "Th 6"
            case WeekDay.saturday:
                weekdayName = "Th 7"
            case WeekDay.sunday:
                weekdayName = "CN"
            }
            return weekdayName + ", " + timeStr
        }

        // Others
        let day = date.dateComponents.day!
        let month = date.dateComponents.month!

        return day.description + " thg " + month.description

    }
}
