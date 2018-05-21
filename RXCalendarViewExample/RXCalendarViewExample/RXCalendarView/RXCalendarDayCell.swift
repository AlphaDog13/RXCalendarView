//
//  RXCalendarDayCell.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/19.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

open class RXCalendarDayCell: UICollectionViewCell {
    
    //MARK: - Property
    var isShowBottomPoint: Bool = false
    var selectColor: UIColor?
    var signColor: UIColor?
    var notInMonthColor: UIColor?
    
    var dataObject: RXDateObject = RXDateObject() {
        didSet {
            resetCell()
            if dataObject.isInCurrentMonth {
                cellSign(isSign: dataObject.isSign)
                cellToday(isToday: dataObject.isToday)
                cellSelect(isSelected: dataObject.isSelected)
            } else {
                cellNotInMonth()
            }
            titleLabel.text = "\(dataObject.dayStr)"
        }
    }
    
    //MARK: - Control
    open var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        return label
    }()
    
    open lazy var bottomPointImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .red
        imgView.layer.cornerRadius = 3
        imgView.clipsToBounds = true
        imgView.isHidden = true
        return imgView
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
        addSubview(bottomPointImgView)
        layout()
    }
    
    //MARK: - Layout
    open func layout() {
        ///titleLabel
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -4))
        
        //bottomPointImgView
        bottomPointImgView.addConstraint(NSLayoutConstraint(item: bottomPointImgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 6))
        bottomPointImgView.addConstraint(NSLayoutConstraint(item: bottomPointImgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 6))
        addConstraint(NSLayoutConstraint(item: bottomPointImgView, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: bottomPointImgView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 3))
    }
    
    //MARK: - Action
    open func resetCell() {
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .clear
        bottomPointImgView.isHidden = true
    }
    
    open func cellSign(isSign: Bool) {
        if isSign {
            titleLabel.textColor = signColor
            titleLabel.backgroundColor = .clear
        }
    }
    
    open func cellToday(isToday: Bool) {
        if isToday {
            bottomPointImgView.isHidden = false
        }
    }
    
    open func cellSelect(isSelected: Bool) {
        if isSelected {
            titleLabel.textColor = .white
            titleLabel.backgroundColor = selectColor
        }
    }
    
    open func cellNotInMonth() {
        titleLabel.textColor = notInMonthColor
        titleLabel.backgroundColor = .clear
    }

}
