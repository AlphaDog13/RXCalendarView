//
//  RXYearScrollView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/5/23.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

@objc(RXYearScrollViewDelegate)
public protocol RXYearScrollViewDelegate {
    func yearScrollViewSelect(didSelectMonth monthStr: String)
    func yearScrollView(currentYear yearStr: String)
}

public class RXYearScrollView: UIScrollView {
    
    //MARK: - Property
    @objc public weak var yearScrollViewDelegate: RXYearScrollViewDelegate?
    var isFirstLoad: Bool = true
    var currentYear: String!
    var scrollDirection: RXCalendarScrollDirection = RXCalendarScrollDirection.scrollHorizonal
    var calendarArr = [RXYearCalendarView]()

    //MARK: - Control
    lazy var leftCalendar: RXYearCalendarView = {
        let calendar = RXYearCalendarView(frame: .zero, collectionViewLayout: RXYearScrollView.cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.yearCalendarDelegate = self
        return calendar
    }()
    
    lazy var midCalendar: RXYearCalendarView = {
        let calendar = RXYearCalendarView(frame: .zero, collectionViewLayout: RXYearScrollView.cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.yearCalendarDelegate = self
        return calendar
    }()
    
    lazy var rightCalendar: RXYearCalendarView = {
        let calendar = RXYearCalendarView(frame: .zero, collectionViewLayout: RXYearScrollView.cellLayout())
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.yearCalendarDelegate = self
        return calendar
    }()

    static func cellLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }
    
    //MARK: - Init
    @objc public convenience init(frame: CGRect, year: String = getCurrentYear(), scrollDirection: RXCalendarScrollDirection) {
        self.init(frame: frame)
        self.currentYear = year
        self.scrollDirection = scrollDirection
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    open func setup() {
        delegate = self
        bounces = false
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        let yearInt: NSInteger = NSInteger(currentYear)!
        leftCalendar.yearStr = "\(yearInt - 1)"
        midCalendar.yearStr = "\(yearInt)"
        rightCalendar.yearStr = "\(yearInt + 1)"
        
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
            moveToYear(calendarView: calendarArr[1])
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
    
    //MARK: - Func
    
    
    //MARK: - Action
    static public func getCurrentYear() -> String {
        let dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: Date())
    }
    
    @objc func reloadCalenderData() {
        for calendar in calendarArr {
            calendar.reloadData()
        }
    }
}

extension RXYearScrollView: UIScrollViewDelegate {
    
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
        let date = Int(calendarArr[2].yearStr)
        calendar.yearStr = "\(date! + 1)"
        
        calendarArr.append(calendar)
        calendarArr.remove(at: 0)
    }
    
    private func removeLastCalendar() {
        let calendar = calendarArr.last!
        let date = Int(calendarArr[0].yearStr)
        calendar.yearStr = "\(date! - 1)"
        
        calendarArr.insert(calendar, at: 0)
        calendarArr.remove(at: calendarArr.count - 1)
    }
    
    public func resetConstraints() {
        self.removeConstraints(self.constraints)
        layout()
        setNeedsLayout()
        layoutIfNeeded()
        resetCenter()
        moveToYear(calendarView: calendarArr[1])
    }
    
    fileprivate func moveToYear(calendarView: RXYearCalendarView) {
        yearScrollViewDelegate?.yearScrollView(currentYear: calendarView.yearStr)
    }
    
}

extension RXYearScrollView: RXYearCalendarViewDelegate {

    func yearCalendarAction(_ monthStr: String) {
        yearScrollViewDelegate?.yearScrollViewSelect(didSelectMonth: monthStr)
    }

}
