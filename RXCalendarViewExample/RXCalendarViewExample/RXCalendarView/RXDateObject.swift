//
//  RXDateObject.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/20.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXDateObject: NSObject {
    
    @objc open var dayStr: String = "" //日期
    @objc open var dateStr: String = "" //yyyy-MM-dd
    @objc open var isToday: Bool = false
    @objc open var isInCurrentMonth: Bool = true
    @objc open var isSign: Bool = false
    
    convenience init(date: String, day: String, inCurrentMonth: Bool = true, today: Bool = false) {
        self.init()
        dateStr = date
        dayStr = day
        isToday = today
        isInCurrentMonth = inCurrentMonth
    }

}
