//
//  DateExtention.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/20.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import Foundation

extension Date {
    
    static func monthDate(date: Date, intervalOfMonth: NSInteger = 0) -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy"
        var yearInt: NSInteger = NSInteger(dateFormatter.string(from: date))!
        dateFormatter.dateFormat = "MM"
        var monthInt: NSInteger = NSInteger(dateFormatter.string(from: date))!
        if intervalOfMonth > 12 || intervalOfMonth < -12 {
            let interalOfYear = intervalOfMonth/12
            yearInt = yearInt + interalOfYear
        }
        let monthRemainder = intervalOfMonth%12
        if monthInt + monthRemainder > 12 {
            yearInt = yearInt + 1
            monthInt = monthInt + monthRemainder - 12
        } else if monthInt + monthRemainder <= 0 {
            yearInt = yearInt - 1
            monthInt = monthInt + monthRemainder + 12
        } else {
            monthInt = monthInt + monthRemainder
        }
        
        dateFormatter.dateFormat = "yyyy-MM"
        let resultDate = dateFormatter.date(from: "\(yearInt)-\(monthInt)")
        let resultMonth = dateFormatter.string(from: resultDate!)
        
        return resultMonth
    }
    
    static func monthDays(date: Date, intervalOfMonth: NSInteger = 0) -> [RXDateObject] {
        let resultMonth = monthDate(date: date, intervalOfMonth: intervalOfMonth)
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var dayArr = [RXDateObject]()
        
        ///本月第一天对应星期
        let dateFormatter_D: DateFormatter = DateFormatter.init()
        dateFormatter_D.dateFormat = "yyyy-MM-dd"
        let dateFormatter_M: DateFormatter = DateFormatter.init()
        dateFormatter_M.dateFormat = "yyyy-MM"
        let firstDayInWeek = calendar.component(.weekday, from: dateFormatter_D.date(from: "\(resultMonth)-01")!)
        
        ///上月补充日期
        let preMonth = monthDate(date: date, intervalOfMonth: intervalOfMonth - 1)
        let preMonthRange: Range = calendar.range(of: .day, in: .month, for: dateFormatter_M.date(from: preMonth)!)!
        if firstDayInWeek > 1 {
            for i in (preMonthRange.count - firstDayInWeek + 2)...preMonthRange.count {
                dayArr.append(RXDateObject(date: standardDate(preMonth + "-\(i)"), day: "\(i)", inCurrentMonth: false))
            }
        }
        
        ///中间月日期
        let thisMonthRange: Range = calendar.range(of: .day, in: .month, for: dateFormatter_M.date(from: resultMonth)!)!
        let todayDateStr = dateFormatter_D.string(from: Date())
        for i in 1...thisMonthRange.count {
            if todayDateStr == resultMonth + "-\(i)" {
                dayArr.append(RXDateObject(date: standardDate(resultMonth + "-\(i)"), day: "\(i)", today: true))
            } else {
                dayArr.append(RXDateObject(date: standardDate(resultMonth + "-\(i)"), day: "\(i)"))
            }
        }
        
        ///下月补充日期
        let nextMonth = monthDate(date: date, intervalOfMonth: intervalOfMonth + 1)
        let lastDayInWeek = calendar.component(.weekday, from: dateFormatter_D.date(from: "\(resultMonth)-\(thisMonthRange.count)")!)
        if lastDayInWeek < 7 {
            for i in 1...(7 - lastDayInWeek) {
                dayArr.append(RXDateObject(date: standardDate(nextMonth + "-\(i)"), day: "\(i)", inCurrentMonth: false))
            }
        }
        
        return dayArr
    }
    
    static func standardDate(_ date: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultDate = dateFormatter.date(from: date)
        let resultStr = dateFormatter.string(from: resultDate!)
        return resultStr
    }
    
}
