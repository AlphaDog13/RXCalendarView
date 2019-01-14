//
//  RXCalendarProtocol.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/4/24.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import Foundation
import UIKit

@objc(RXCalendarDataSource)
public protocol RXCalendarDataSource {
    func signDateInMonth(view: RXCalendarView) -> [Dictionary<String, Any>]
    func rxCalendarSelectColor() -> UIColor
    func rxCalendarSignColor() -> UIColor
    func rxCalendarNotInMonthColor() -> UIColor
}

@objc(RXCalendarDelegate)
public protocol RXCalendarDelegate {
    func calendarAction(_ dayInfo: RXDateObject)
    func didScrollToNextMonth(_ monthInfo: RXMonthObject)
}

extension RXCalendarDelegate {
    
    func calendarAction(_ dayInfo: RXDateObject) {
        
    }
    
}

extension RXCalendarDataSource {
    
    func signDateInMonth(view: RXCalendarView) -> [Dictionary<String, Any>] {
        return []
    }
    
}
