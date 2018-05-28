//
//  RXCalendarContainerView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/16.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

@objc(RXCalendarScrollDirection)
public enum RXCalendarScrollDirection: Int {
    case scrollHorizonal = 0
    case scrollVertical
}

open class RXCalendarContainerView: UIView {
    
    @objc weak open var dataSource: RXCalendarDataSource? {
        didSet {
            guard let _ = calendarContainer.containerView else {
                return calendarContainer.containerView = self
            }
        }
    }

    @objc weak open var delegate: RXCalendarDelegate? {
        didSet {
            guard let _ = calendarContainer.containerView else {
                return calendarContainer.containerView = self
            }
        }
    }
    
    @objc var scrollDirection: RXCalendarScrollDirection = RXCalendarScrollDirection.scrollHorizonal
    
    //MARK: - Control
    lazy var weekView: RXCalendarWeekView = {
        let view = RXCalendarWeekView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var calendarContainer: RXCalendarScrollView = {
        let view = RXCalendarScrollView(frame: CGRect.zero, scrollDirection: scrollDirection)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    ///MARK: - Init
    @objc public convenience init(frame: CGRect, month: String = currentMonth(), scrollDirection: RXCalendarScrollDirection) {
        self.init(frame: frame)
        RXCalendarSingleton.shared.initMonth = month
        self.scrollDirection = scrollDirection
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        let dateFormatter_D: DateFormatter = DateFormatter.init()
        dateFormatter_D.dateFormat = "yyyy-MM-dd"
        RXCalendarSingleton.shared.selectedDateStr =  dateFormatter_D.string(from: Date())
        
        addSubview(weekView)
        addSubview(calendarContainer)
        layout()
    }
    
    ///MARK: - Layout
    open func layout() {
        ///weekView
        addConstraint(NSLayoutConstraint(item: weekView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: weekView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: weekView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        weekView.addConstraint(NSLayoutConstraint(item: weekView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        
        ///calendarContainer
        addConstraint(NSLayoutConstraint(item: calendarContainer, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarContainer, attribute: .top, relatedBy: .equal, toItem: weekView, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarContainer, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarContainer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    ///MARK: - Func
    
    
    //MARK: - Action
    static public func currentMonth() -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: Date())
    }
    
    @objc open func reloadCalendar() {
        calendarContainer.midCalendar.reload()
    }
    
}

extension RXCalendarContainerView: RXCalendarCellDelegate, RXCalendarCellDataSource {
    
    //MARK: - RXCalendarCellDataSource
    func signDateInCurrentMonth(view: RXCalendarView) -> [String] {
        if let arr = dataSource?.signDateInMonth(view: view) {
            return arr
        }
        return []
    }
    
    func selectColor(view: RXCalendarView) -> UIColor {
        if let color = dataSource?.rxCalendarSelectColor() {
            return color
        }
        return .orange
    }
    
    func signColor(view: RXCalendarView) -> UIColor {
        if let color = dataSource?.rxCalendarSignColor() {
            return color
        }
        return .red
    }
    
    func dayNotInMonthColor(view: RXCalendarView) -> UIColor {
        if let color = dataSource?.rxCalendarNotInMonthColor() {
            return color
        }
        return .gray
    }
    
    //MARK: - RXCalendarCellDelegate
    func calendarCellAction(cellInfo: RXDateObject) {
        delegate?.calendarAction(cellInfo)
    }
    
    func scrollToNextMonth(monthInfo: RXMonthObject) {
        delegate?.didScrollToNextMonth(monthInfo)
    }
    
}
