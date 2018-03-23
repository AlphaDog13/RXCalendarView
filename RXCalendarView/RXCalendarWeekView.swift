//
//  RXCalendarWeekView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/16.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXCalendarWeekView: UIView {

    var labelDic: [String: UILabel] = [String : UILabel]()
    
    let weekDays = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    
    ///MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        for i in 0..<7 {
            let label = UILabel()
            label.text = weekDays[i]
            label.textColor = .darkGray
            label.font = .systemFont(ofSize: 15)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            labelDic["label\(i)"] = label
        }
        layout()
    }
    
    ///MARK: - Layout
    open func layout() {
        var vStr: String = "H:|"
        for i in 0..<7 {
            vStr.append("-0-[label\(i)]")
            
            let label = labelDic["label\(i)"]!
            addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            if i > 0 {
                let lastLabel = labelDic["label\(i-1)"]!
                addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: lastLabel, attribute: .width, multiplier: 1, constant: 0))
            }
        }
        vStr.append("-0-|")
        let yCons = NSLayoutConstraint.constraints(withVisualFormat: vStr, options: .directionLeftToRight, metrics: nil, views: labelDic)
        addConstraints(yCons)
    }
    
    ///MARK: - Action

}
