//
//  ViewController.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/16.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RXCalendarDelegate, RXCalendarDataSource {
    
    lazy var calendarView: RXCalendarContainerView = {
        let view: RXCalendarContainerView = RXCalendarContainerView()
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setup()
    }
    
    func setup() {
        view.addSubview(calendarView)
        layout()
    }
    
    ///MARK: - Layout
    func layout() {
        ///calendarView
        view.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        calendarView.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width - 40))
        calendarView.addConstraint(NSLayoutConstraint(item: calendarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width))
    }
    
    func calendarAction(_ dayInfo: RXDateObject) {
        print("\(dayInfo.dateStr)")
    }
    
    func signDateInMonth(view: RXCalendarView) -> [String] {
        return ["2018-03-03", "2018-03-11", "2018-03-13", "2018-03-23"]
    }

}

