//
//  RXCalendarProtocol.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/4/24.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import Foundation

@objc(RXCalendarDelegate)
public protocol RXCalendarDelegate {
    func calendarAction(_ dayInfo: RXDateObject)
    func didScrollToNextMonth(_ monthInfo: RXMonthObject)
}

@objc(RXCalendarDataSource)
public protocol RXCalendarDataSource {
    func signDateInMonth(view: RXCalendarView) -> [String]
}

extension RXCalendarDelegate {
    
    func calendarAction(_ dayInfo: RXDateObject) {
        
    }
    
//    func didScrollToNextMonth(_ monthInfo: RXMonthObject) {
//        
//    }
    
}

extension RXCalendarDataSource {
    
    func signDateInMonth(view: RXCalendarView) -> [String] {
        return []
    }
    
}
