//
//  RXMonthObject.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/4/24.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXMonthObject: NSObject {
    
    open var monthStr: String = "" //yyyy-MM
    open var monthStartDateStr: String = ""
    open var monthEndDateStr: String = ""
    open var calendarSize: CGSize = CGSize.zero
    
    convenience init(month: String, startDate: String, endDate: String, size: CGSize = CGSize.zero) {
        self.init()
        monthStr = month
        monthStartDateStr = startDate
        monthEndDateStr = endDate
        calendarSize = size
    }

}
