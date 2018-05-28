//
//  RXYearCalendarView.swift
//  RXCalendarViewExample
//
//  Created by AlphaDog on 2018/5/23.
//  Copyright © 2018年 AlphaDog. All rights reserved.
//

import UIKit

protocol RXYearCalendarViewDelegate: NSObjectProtocol {
    func yearCalendarAction(_ monthStr: String)
}

class RXYearCalendarView: UICollectionView {
    
    weak var yearCalendarDelegate: RXYearCalendarViewDelegate?
    
    open var yearStr: String = "" {
        didSet {
            resetData()
        }
    }
    open var monthStrArr = [String]()
    
    open var signDateArr: [String]?
    open var selectColor: UIColor?
    open var signColor: UIColor?
    open var dayNotInMonthColor: UIColor?
    
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
        register(RXCalendarMonthCell.self, forCellWithReuseIdentifier: "RXCalendarMonthCell")
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
        monthStrArr.removeAll()
        let tempMonthArr: Array = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        for str in tempMonthArr {
            let tempStr = "\(yearStr)-\(str)"
            monthStrArr.append(tempStr)
        }
        reloadData()
    }
    
    //MARK: - Public Action
    @objc open func reload() {
        resetData()
        reloadData()
    }

}

extension RXYearCalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthStrArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RXCalendarMonthCell = dequeueReusableCell(withReuseIdentifier: "RXCalendarMonthCell", for: indexPath) as! RXCalendarMonthCell
        cell.monthStr = monthStrArr[indexPath.row]
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = floor(self.bounds.size.width / 3 - 8)
        cellHeight = floor(self.superview!.bounds.size.height / 4 - 8)
        return CGSize(width: cellWidth!, height: cellHeight!)
    }
    
    //MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        yearCalendarDelegate?.yearCalendarAction(monthStrArr[indexPath.row])
    }
    
}
