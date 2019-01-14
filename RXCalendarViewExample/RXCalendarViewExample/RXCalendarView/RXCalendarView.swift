//
//  RXCalendarView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/3/19.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

protocol RXCalendarCellDelegate: NSObjectProtocol {
    func calendarCellAction(cellInfo: RXDateObject)
}

protocol RXCalendarCellDataSource: NSObjectProtocol {
    func signDateInCurrentMonth(view: RXCalendarView) -> [Dictionary<String, Any>]
    func selectColor(view: RXCalendarView) -> UIColor
    func signColor(view: RXCalendarView) -> UIColor
    func dayNotInMonthColor(view: RXCalendarView) -> UIColor
}

open class RXCalendarView: UICollectionView {
    
    weak var cellDelegate: RXCalendarCellDelegate?
    weak var cellDataSource: RXCalendarCellDataSource? {
        didSet {
            reload()
        }
    }
    
    open var itemArr = [RXDateObject]() {
        didSet {
            reload()
        }
    }
    
    open var signDateArr: [Dictionary<String, Any>]?
    open var selectColor: UIColor?
    open var signColor: UIColor?
    open var dayNotInMonthColor: UIColor?
    open var cellDateFont: UIFont?
    
    open var cellWidth: CGFloat?
    open var cellHeight: CGFloat?
    
    var dateStr: String = ""

    //MARK: - Init
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        delegate = self
        dataSource = self
        isScrollEnabled = false
        backgroundColor = .white
        register(RXCalendarDayCell.self, forCellWithReuseIdentifier: "RXCalendarDayCell")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !self.bounds.size.equalTo(intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = superview?.intrinsicContentSize
        contentSize = self.contentSize
        return contentSize!
    }
    
    //MARK: - Action
    private func resetData() {
        signDateArr = cellDataSource?.signDateInCurrentMonth(view: self)
        if nil == selectColor {
            selectColor = cellDataSource?.selectColor(view: self)
        }
        if nil == signColor {
            signColor = cellDataSource?.signColor(view: self)
        }
        if nil == dayNotInMonthColor {
            dayNotInMonthColor = cellDataSource?.dayNotInMonthColor(view: self)
        }
    }
    
    //MARK: - Public Action
    @objc open func reload() {
        resetData()
        CATransaction.setDisableActions(true)
        self.reloadData()
        CATransaction.commit()
    }
    
}

extension RXCalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RXCalendarDayCell = dequeueReusableCell(withReuseIdentifier: "RXCalendarDayCell", for: indexPath) as! RXCalendarDayCell
        let item: RXDateObject = itemArr[indexPath.row]
        let cellDate = item.dateStr
        
        cell.selectColor = selectColor
        cell.notInMonthColor = dayNotInMonthColor
        cell.dateFont = cellDateFont
        
        item.isSign = false
        if let arr = signDateArr, arr.count > 0 {
            for dic in arr {
                if dic["date"] as! String == cellDate {
                    item.isSign = true
                    cell.signColor = hexadecimalColor(hexadecimal: dic["color"] as! String)
                    cell.remarkInfoDic = dic
                    break
                }
            }
        }
        
        item.isSelected = false
        if cellDate == RXCalendarSingleton.shared.selectedDateStr {
            item.isSelected = true
        }
        cell.dataObject = item
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = floor(self.bounds.size.width/7)
        if 18 < cellWidth! / 4 * 3 {
            cellHeight = floor(cellWidth! / 4 * 3)
        } else {
            cellHeight = 18
        }
        return CGSize(width: cellWidth!, height: cellHeight!)
    }
    
    //MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: RXDateObject = itemArr[indexPath.row]
        RXCalendarSingleton.shared.selectedDateStr = item.dateStr
        
        NotificationCenter.default.post(name: NotificationHelper.calendarCellSelect, object: nil)
        cellDelegate?.calendarCellAction(cellInfo: item)
    }
    
    func hexadecimalColor(hexadecimal:String) -> UIColor {
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
            return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
    }
}
