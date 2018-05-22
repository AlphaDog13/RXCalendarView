# RXCalendarView

## 内容

- [样例](#样例)
- [需要](#需要)
- [使用](#使用)
- [开始](#开始)
- [License](#license)

## 样例

![](https://github.com/AlphaDog13/RXCalendarView/blob/master/IMB_b83B9q.GIF) 
![](https://github.com/AlphaDog13/RXCalendarView/blob/master/IMB_7fMynP.GIF) 

## 需要

- iOS 8.0+
- Xcode 9.0+
- Swift 3.0+

## 使用

### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
pod 'RXCalendarView', '~> 0.1.0'
end
```

## 开始

### 初始化
```swift
class ViewController: UIViewController, RXCalendarDelegate, RXCalendarDataSource {

lazy var calendarView: RXCalendarContainerView = {
    let view: RXCalendarContainerView = RXCalendarContainerView(frame: CGRect.zero, scrollDirection: RXCalendarScrollDirection.scrollVertical)
    view.dataSource = self
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()

override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(calendarView)
}
```

### DataSource

```swift
func signDateInMonth(view: RXCalendarView) -> [String]  //需标记的日期 [yyyy-MM-dd]
func rxCalendarSelectColor() -> UIColor                 //选中颜色
func rxCalendarSignColor() -> UIColor                   //标记颜色
func rxCalendarNotInMonthColor() -> UIColor             //非当月颜色
```

### Delegate

```swift
func calendarAction(_ dayInfo: RXDateObject)            //选中日期信息
func didScrollToNextMonth(_ monthInfo: RXMonthObject)   //当前月份信息
```

### 相关类

#### RXDateObject
```swift
@objc open var dayStr: String           //dd
@objc open var dateStr: String          //yyyy-MM-dd
@objc open var isToday: Bool            //是否 今日
@objc open var isInCurrentMonth: Bool   //是否 当月日期
@objc open var isSign: Bool             //是否 标记
@objc open var isSelected: Bool         //是否 选中
```

#### RXMonthObject
```swift
@objc open var monthStr: String     //yyyy-MM      
@objc open var monthStartDateStr    //本月开始日期
@objc open var monthEndDateStr      //本月结束日期
@objc open var calendarSize         //单月viewSize
```

## License

RXCalendarView is released under the MIT license. See LICENSE for details.

