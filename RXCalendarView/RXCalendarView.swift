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
    func signDateInCurrentMonth(view: RXCalendarView) -> [String]
}

open class RXCalendarView: UICollectionView {
    
    weak var cellDataSource: RXCalendarCellDataSource? {
        didSet {
            signDateArr = cellDataSource?.signDateInCurrentMonth(view: self)
            reloadData()
        }
    }
    weak var cellDelegate: RXCalendarCellDelegate?
    
    var dateStr: String = ""
    
    open var itemArr = [RXDateObject]() {
        didSet {
            signDateArr = cellDataSource?.signDateInCurrentMonth(view: self)
            reloadData()
        }
    }
    
    open var signDateArr: [String]?

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
        register(RXCalendarDayCell.self, forCellWithReuseIdentifier: "RXCalendarDayCell")
        
        backgroundColor = .white
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
        if let arr = signDateArr, arr.count > 0 {
            let cellDate = item.dateStr
            if arr.contains(cellDate) {
                item.isSign = true
            }
        }
        cell.dataObject = item
        
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.size.width/CGFloat(7)
        return CGSize(width: width, height: width)
    }
    
    //MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: RXDateObject = itemArr[indexPath.row]
        cellDelegate?.calendarCellAction(cellInfo: item)
    }
    
}
