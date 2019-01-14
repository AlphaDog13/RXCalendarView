//
//  RXCalendarScrollView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/19.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXCalendarScrollView: UIScrollView {
    
    //MARK: - Property
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
    
    var calendarArr = [RXCalendarView]()
    var scrollDirection: RXCalendarScrollDirection = RXCalendarScrollDirection.scrollHorizonal
    
    var monthDate: Date {
        get {
            let month = RXCalendarSingleton.shared.initMonth!
            let dateFormatter: DateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM"
            return dateFormatter.date(from: month)!
        }
    }
    var isFirstLoad: Bool = true
    var todayColor: UIColor?
    var signColor: UIColor?
    
    //MARK: - Control
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
    
    //MARK: - Init
    public convenience init(frame: CGRect, scrollDirection: RXCalendarScrollDirection) {
        self.init(frame: frame)
        self.scrollDirection = scrollDirection
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func setup() {
        delegate = self
        bounces = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCalenderData) , name: NotificationHelper.calendarCellSelect, object: nil)
        
        leftCalendar.dateStr = Date.monthDate(date: monthDate, intervalOfMonth: -1)
        midCalendar.dateStr = Date.monthDate(date: monthDate)
        rightCalendar.dateStr = Date.monthDate(date: monthDate, intervalOfMonth: 1)
        leftCalendar.itemArr = Date.monthDays(date: monthDate, intervalOfMonth: -1)
        midCalendar.itemArr = Date.monthDays(date: monthDate)
        rightCalendar.itemArr = Date.monthDays(date: monthDate, intervalOfMonth: 1)
        
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
            resetCenter()
            moveToMonth(calendarView: calendarArr[1])
        }
    }
    
    fileprivate func resetCenter() {
        if RXCalendarScrollDirection.scrollHorizonal == scrollDirection {
            setContentOffset(CGPoint.init(x: calendarArr[1].frame.origin.x, y: 0), animated: false)
        } else if RXCalendarScrollDirection.scrollVertical == scrollDirection {
            setContentOffset(CGPoint.init(x: 0, y: calendarArr[1].frame.origin.y), animated: false)
        }
    }
    
    open func layout() {
        if RXCalendarScrollDirection.scrollHorizonal == scrollDirection {
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
        } else if RXCalendarScrollDirection.scrollVertical == scrollDirection {
            ///midCalendar
            addConstraint(NSLayoutConstraint(item: calendarArr[1], attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[1], attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
            
            ///topCalendar
            addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .centerX, relatedBy: .equal, toItem: calendarArr[1], attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .bottom, relatedBy: .equal, toItem: calendarArr[1], attribute: .top, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .width, relatedBy: .equal, toItem: calendarArr[1], attribute: .width, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[0], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
            
            ///bottomCalendar
            addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .centerX, relatedBy: .equal, toItem: calendarArr[1], attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .top, relatedBy: .equal, toItem: calendarArr[1], attribute: .bottom, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .width, relatedBy: .equal, toItem: calendarArr[1], attribute: .width, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: calendarArr[2], attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        }
    }
    
    //Public Action
    @objc func reloadCalenderData() {
        for calendar in calendarArr {
            calendar.reloadData()
        }
    }
}

extension RXCalendarScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if RXCalendarScrollDirection.scrollHorizonal == scrollDirection {
            if scrollView.contentOffset.x == 0 {
                removeLastCalendar()
            } else if scrollView.contentOffset.x == calendarArr[2].frame.origin.x {
                removePreCalendar()
            }
            resetConstraints()
        } else if RXCalendarScrollDirection.scrollVertical == scrollDirection {
            if scrollView.contentOffset.y == 0 {
                removeLastCalendar()
            } else if Int(scrollView.contentSize.height/2) < Int(scrollView.contentOffset.y) {
                removePreCalendar()
            }
            resetConstraints()
        }
    }
    
    private func removePreCalendar() {
        let calendar = calendarArr.first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: calendarArr[2].dateStr)
        calendar.dateStr = Date.monthDate(date: date!, intervalOfMonth: 1)
        calendar.itemArr = Date.monthDays(date: date!, intervalOfMonth: 1)
        
        calendarArr.append(calendar)
        calendarArr.remove(at: 0)
    }
    
    private func removeLastCalendar() {
        let calendar = calendarArr.last!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: calendarArr[0].dateStr)
        calendar.dateStr = Date.monthDate(date: date!, intervalOfMonth: -1)
        calendar.itemArr = Date.monthDays(date: date!, intervalOfMonth: -1)
        
        calendarArr.insert(calendar, at: 0)
        calendarArr.remove(at: calendarArr.count - 1)
    }
    
    public func resetConstraints() {
        self.removeConstraints(self.constraints)
        layout()
        setNeedsLayout()
        layoutIfNeeded()
        resetCenter()
        moveToMonth(calendarView: calendarArr[1])
    }
    
    fileprivate func moveToMonth(calendarView: RXCalendarView) {
        let month = calendarView.dateStr
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let dateFormatter_M: DateFormatter = DateFormatter.init()
        dateFormatter_M.dateFormat = "yyyy-MM"
        let thisMonthRange: Range = calendar.range(of: .day, in: .month, for: dateFormatter_M.date(from: month)!)!
        let calendarSize: CGSize = CGSize.init(width: calendarView.bounds.size.width, height: calendarView.bounds.size.height + 40)
        let monthObj: RXMonthObject = RXMonthObject(month: month, startDate: "\(month)-01", endDate: "\(month)-\(thisMonthRange.count)", size:calendarSize)
        
        if monthObj.monthStr == dateFormatter_M.string(from: NSDate() as Date) {
            let nowDate = NSDate()
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = formatter.string(from: nowDate as Date)
            RXCalendarSingleton.shared.selectedDateStr = dateString
        } else {
            RXCalendarSingleton.shared.selectedDateStr = "\(month)-01"
        }
        containerView?.calendarCellAction(cellInfo: RXDateObject(date: RXCalendarSingleton.shared.selectedDateStr!, day: "00"))
        
        containerView?.scrollToNextMonth(monthInfo: monthObj)
    }
    
}
