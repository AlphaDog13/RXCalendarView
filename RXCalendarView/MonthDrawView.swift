//
//  MonthDrawView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/5/25.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

class MonthDrawView: UIView {
    
    //MARK: - Property
    var itemArr = [RXDateObject]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let con = UIGraphicsGetCurrentContext()!
        con.setLineWidth(1.0);
        
        var dateX: CGFloat = 0
        var dateY: CGFloat = 0
        let dateSide: CGFloat = self.bounds.width/7
        let textColor = UIColor.black
        let font = UIFont.systemFont(ofSize: 11)
        
        for (index, rxDateObject) in itemArr.enumerated() {
            if rxDateObject.isInCurrentMonth {
                dateX = dateSide * CGFloat(index % 7)
                dateY = dateSide * CGFloat(index / 7)
                let str: NSString = rxDateObject.dayStr as NSString
                let textSize = str.size(withAttributes: [NSAttributedStringKey.font: font,  NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): textColor])
                let spaceX = (dateSide - textSize.width)/2
                let spaceY = (dateSide - textSize.height)/2
                str.draw(in: CGRect(x: dateX + spaceX, y: dateY + spaceY, width: dateSide, height: dateSide), withAttributes: [NSAttributedStringKey.font: font,  NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): textColor])
            }
        }
        UIGraphicsEndImageContext()
    }

}
