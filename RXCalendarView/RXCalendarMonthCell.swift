//
//  RXCalendarMonthCell.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/5/23.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

class RXCalendarMonthCell: UICollectionViewCell {
    
    //MARK: - Property
    public var monthStr: String? {
        didSet {
            let dateFormatter: DateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM"
            let date = dateFormatter.date(from: monthStr!)
            monthDrawView.itemArr = Date.monthDays(date: date ?? Date())
            
            let dateArr = monthStr!.components(separatedBy: "-")
            let tempMonthStr: String
            if dateArr[1].hasPrefix("0") {
                tempMonthStr = dateArr[1].replacingOccurrences(of: "0", with: "")
            } else {
                tempMonthStr = dateArr[1]
            }
            titleLabel.text = "\(tempMonthStr)月"
        }
    }
    
    //MARK: - Control
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .red
        return label
    }()
    
    var monthDrawView: MonthDrawView = {
        let view = MonthDrawView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(titleLabel)
        addSubview(monthDrawView)
        layout()
    }
    
    //MARK: - Layout
    func layout() {
        //titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 8))
        let titleLabelW = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80)
        titleLabel.addConstraint(titleLabelW)
        let titleLabelH = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        titleLabel.addConstraint(titleLabelH)
        
        //monthDrawView
        addConstraint(NSLayoutConstraint(item: monthDrawView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: monthDrawView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: monthDrawView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: monthDrawView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    //MARK: - Action
    func cellSize() -> CGSize {
        return bounds.size
    }
    
    //MARK: - Public Action
    
}
