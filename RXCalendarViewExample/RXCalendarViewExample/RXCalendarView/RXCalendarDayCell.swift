//
//  RXCalendarDayCell.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/19.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXCalendarDayCell: UICollectionViewCell {
    
    var dataObject: RXDateObject = RXDateObject() {
        didSet {
            if dataObject.isInCurrentMonth {
                titleLabel.textColor = .black
                
                if dataObject.isToday {
                    titleLabel.textColor = .white
                    titleLabel.backgroundColor = .orange
                } else {
                    titleLabel.textColor = .black
                    titleLabel.backgroundColor = .clear
                }
                
                if dataObject.isSign {
                    titleLabel.textColor = .red
                }
            } else {
                titleLabel.textColor = .gray
            }
            titleLabel.text = "\(dataObject.dateDayStr)"
        }
    }
    
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    //MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        addSubview(titleLabel)
        layout()
    }
    
    //MARK: - Layout
    open func layout() {
        ///titleLabel
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
