//
//  ViewController.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/16.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calendarHeight: CGFloat = UIScreen.main.bounds.width/7*6+40
    var calendarHeightConstraint: NSLayoutConstraint?
    var selectMonth: String?
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2020"
        return label
    }()
    
    lazy var calendarView: RXCalendarContainerView = {
        let view: RXCalendarContainerView = RXCalendarContainerView(frame: CGRect.zero, month: selectMonth!, scrollDirection: RXCalendarScrollDirection.scrollHorizonal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    lazy var yearCalendarView: RXYearScrollView = {
        let view: RXYearScrollView = RXYearScrollView(frame: CGRect.zero, year: "2020", scrollDirection: RXCalendarScrollDirection.scrollHorizonal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.yearScrollViewDelegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setup()
    }
    
    func setup() {
        //RXCalendarContainerView
        
        //RXYearScrollView
        view.addSubview(yearLabel)
        view.addSubview(yearCalendarView)
        
        layout()
    }
    
    ///MARK: - Layout
    func layout() {
        ///RXCalendarContainerView
        
        //RXYearScrollView
        if let _ = yearCalendarView.superview {
            view.addConstraint(NSLayoutConstraint(item: yearLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20))
            view.addConstraint(NSLayoutConstraint(item: yearLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[yearCalendarView]-(16)-|", options: [], metrics: nil, views: ["yearCalendarView" : yearCalendarView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[yearCalendarView]-(16)-|", options: [], metrics: nil, views: ["yearCalendarView" : yearCalendarView]))
        }
    }

}

extension ViewController: RXCalendarDelegate, RXCalendarDataSource {
    
    func signDateInMonth(view: RXCalendarView) -> [String] {
        return ["2018-03-03", "2018-03-11", "2018-03-13", "2018-03-23"]
    }
    
    func rxCalendarSelectColor() -> UIColor {
        return .purple
    }
    
    func rxCalendarSignColor() -> UIColor {
        return .red
    }
    
    func rxCalendarNotInMonthColor() -> UIColor {
        return .gray
    }
    
    func calendarAction(_ dayInfo: RXDateObject) {
        print("\(dayInfo.dateStr)")
    }
    
    func didScrollToNextMonth(_ monthInfo: RXMonthObject) {
        print("\(monthInfo.monthStr) * \(monthInfo.monthStartDateStr) * \(monthInfo.monthEndDateStr) * \(monthInfo.calendarSize)")
        if calendarHeight != monthInfo.calendarSize.height {
            calendarHeight = monthInfo.calendarSize.height
            
            calendarView.removeConstraint(calendarHeightConstraint!)
            calendarHeightConstraint = NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calendarHeight)
            calendarView.addConstraint(calendarHeightConstraint!)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
}

extension ViewController: RXYearScrollViewDelegate {
    
    func yearScrollView(currentYear yearStr: String) {
        yearLabel.text = yearStr
    }
    
    func yearScrollViewSelect(didSelectMonth monthStr: String) {
        print("\(monthStr)")
        selectMonth = monthStr
        yearCalendarView.removeFromSuperview()
        
        view.addSubview(calendarView)
        calendarHeightConstraint = NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calendarHeight)
        view.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        calendarView.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width))
        calendarView.addConstraint(calendarHeightConstraint!)
    }

}

