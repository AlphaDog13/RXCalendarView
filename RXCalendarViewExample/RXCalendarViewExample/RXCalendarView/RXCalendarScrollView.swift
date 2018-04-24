//
//  RXCalendarScrollView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/19.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXCalendarScrollView: UIScrollView {
    
    weak var containerView: RXCalendarContainerView? {
        didSet {
            leftCalendar.cellDelegate = containerView
            midCalendar.cellDelegate = containerView
            rightCalendar.cellDelegate = containerView
            
            leftCalendar.cellDataSource = containerView
            midCalendar.cellDataSource = containerView
            rightCalendar.cellDataSource = containerView
        }
    }
    
    var monthStr: Date = Date()
    
    var isFirstLoad: Bool = true
    
    var leftCalendar: RXCalendarView = {
        let calendar = RXCalendarView(frame: .zero, collectionViewLayout: cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    var midCalendar: RXCalendarView = {
        let calendar = RXCalendarView(frame: .zero, collectionViewLayout: cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    var rightCalendar: RXCalendarView = {
        let calendar = RXCalendarView(frame: .zero, collectionViewLayout: cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    static func cellLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
    
    var calendarArr = [RXCalendarView]()
    
    //MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        delegate = self
        bounces = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        
        leftCalendar.dateStr = Date.monthDate(date: monthStr, intervalOfMonth: -1)
        midCalendar.dateStr = Date.monthDate(date: monthStr)
        rightCalendar.dateStr = Date.monthDate(date: monthStr, intervalOfMonth: 1)
        leftCalendar.itemArr = Date.monthDays(date: monthStr, intervalOfMonth: -1)
        midCalendar.itemArr = Date.monthDays(date: monthStr)
        rightCalendar.itemArr = Date.monthDays(date: monthStr, intervalOfMonth: 1)
        addSubview(leftCalendar)
        addSubview(midCalendar)
        addSubview(rightCalendar)
        calendarArr.append(leftCalendar)
        calendarArr.append(midCalendar)
        calendarArr.append(rightCalendar)
        
        layout()
    }
    
    //MARK: - Layout
    open override var intrinsicContentSize: CGSize {
        var contentSize = superview?.intrinsicContentSize
        contentSize = calendarArr[1].bounds.size
        return contentSize!
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLoad {
            isFirstLoad = false
            setNeedsLayout()
            layoutIfNeeded()
            setContentOffset(CGPoint.init(x: calendarArr[1].frame.origin.x, y: 0), animated: false)
            moveToMonth(calendarView: calendarArr[1])
        }
    }
    
    open func layout() {
        ///midCalendar
        addConstraint(NSLayoutConstraint(item: calendarArr[1], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[1], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        
        ///leftCalendar
        addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .right, relatedBy: .equal, toItem: calendarArr[1], attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .top, relatedBy: .equal, toItem: calendarArr[1], attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .width, relatedBy: .equal, toItem: calendarArr[1], attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        
        ///rightCalendar
        addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .left, relatedBy: .equal, toItem: calendarArr[1], attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .top, relatedBy: .equal, toItem: calendarArr[1], attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .width, relatedBy: .equal, toItem: calendarArr[1], attribute: .width, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
    
}

extension RXCalendarScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            let calendar = calendarArr.last!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let date = dateFormatter.date(from: calendarArr[0].dateStr)
            calendar.dateStr = Date.monthDate(date: date!, intervalOfMonth: -1)
            calendar.itemArr = Date.monthDays(date: date!, intervalOfMonth: -1)
            
            calendarArr.insert(calendar, at: 0)
            calendarArr.remove(at: calendarArr.count - 1)
        } else if scrollView.contentOffset.x == calendarArr[2].frame.origin.x {
            let calendar = calendarArr.first!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let date = dateFormatter.date(from: calendarArr[2].dateStr)
            calendar.dateStr = Date.monthDate(date: date!, intervalOfMonth: 1)
            calendar.itemArr = Date.monthDays(date: date!, intervalOfMonth: 1)
            
            calendarArr.append(calendar)
            calendarArr.remove(at: 0)
        }
        self.removeConstraints(self.constraints)
        resetConstraints()
    }
    
    public func resetConstraints() {
        layout()
        setNeedsLayout()
        layoutIfNeeded()
        setContentOffset(CGPoint.init(x: calendarArr[1].frame.origin.x, y: 0), animated: false)
        moveToMonth(calendarView: calendarArr[1])
    }
    
    fileprivate func moveToMonth(calendarView: RXCalendarView) {
        let month = calendarView.dateStr
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let dateFormatter_M: DateFormatter = DateFormatter.init()
        dateFormatter_M.dateFormat = "yyyy-MM"
        let thisMonthRange: Range = calendar.range(of: .day, in: .month, for: dateFormatter_M.date(from: month)!)!
        let calendarSize: CGSize = CGSize.init(width: calendarView.bounds.size.width, height: calendarView.bounds.size.height + 40)
        let monthObj: RXMonthObject = RXMonthObject(month: month, startDate: "\(month)-1", endDate: "\(month)-\(thisMonthRange.count)", size:calendarSize)
        containerView?.scrollToNextMonth(monthInfo: monthObj)
    }
    
}
