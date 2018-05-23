//
//  RXCalendarSingleton.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/5/16.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

struct NotificationHelper {
    static let calendarCellSelect = Notification.Name("RXCalendarViewCellSelect")
}

class RXCalendarSingleton: NSObject {
    
    var selectedDateStr: String?
    var selectCell: RXCalendarDayCell?
    
    static let shared = RXCalendarSingleton()
    
    private override init() {} 
    
    override func copy() -> Any {
        return self
    }
    
    override func mutableCopy() -> Any {
        return self
    }
    
    func reset() {

    }
    
}
