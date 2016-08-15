import UIKit
//MARK:NSDate extension
extension NSDate {
    //一天之前
    public class func OneDayAgo() -> NSDate {
        return NSDate(timeIntervalSinceNow: -24 * 60 * 60)
    }
    //当天的零时
    public class func ZeroHourToday() -> NSDate {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "H"
        let hours = Int(dateFormatter.stringFromDate(now))
        
        dateFormatter.dateFormat = "m"
        let minutes = Int(dateFormatter.stringFromDate(now))
        
        dateFormatter.dateFormat = "s"
        let seconds = Int(dateFormatter.stringFromDate(now))
        
        let timeInterval = -(((hours! * 60 + minutes!) * 60) + seconds!)
        
        return NSDate(timeIntervalSinceNow: NSTimeInterval(timeInterval))
    }
    //今天的几点几时几分
    public class func TodayWith(hours:Int,minutes:Int,seconds:Int) ->NSDate? {
        if (hours > 23 || hours < 0 || minutes > 60 || minutes < 0 || seconds > 60 || seconds < 0) {
            return nil
        }
        return NSDate(timeInterval: NSTimeInterval(((hours * 60 + minutes) * 60) + seconds), sinceDate: NSDate.ZeroHourToday())
    }
    //距离哪天的几天
    public class func DayBy(dayOffset:Int,sinceDate:NSDate) -> NSDate {
        return NSDate(timeInterval: NSTimeInterval(dayOffset * 86400), sinceDate: sinceDate)
    }
    //便利构造函数
    convenience init(year: Int, month: Int, day: Int, hour: Int, minute: Int = 0, second: Int = 0) {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        self.init(timeInterval: 0, sinceDate: NSCalendar.currentCalendar().dateFromComponents(components)!)
    }
    
    convenience init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, hour: 0)
    }
    
    /// **timestamp** 时间戳字符串，纯数字组成
    class func dateFromTimestampString(timestamp: String) -> NSDate! {
        let time = Int(timestamp)!
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        return date
    }
    
    class func currentLocalTimestamp() -> String! {
        return currentTimestamp(timezone: NSTimeZone.systemTimeZone())
    }
    
    class func currentGreenwichTimestamp() -> String! {
        return currentTimestamp(timezone: NSTimeZone(name: "Europe/London")!)
    }
    
    class func currentTimestamp(timezone timezone: NSTimeZone) -> String! {
        let date = NSDate()
        return timestamp(date: date, timezone: timezone)
    }
    
    class func timestamp(date date: NSDate, timezone: NSTimeZone) -> String! {
        let interval = NSTimeInterval(timezone.secondsFromGMTForDate(date))
        let localeDate = date.dateByAddingTimeInterval(interval)
        let timestamp = NSString.localizedStringWithFormat("%ld", Int64(localeDate.timeIntervalSince1970))
        return String(timestamp)
    }
    
    class var currentDateStringWithoutTimeZoneString: String {
        return dateToString(NSDate(), dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    static func dateToString(date: NSDate, dateFormat: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = NSLocale(localeIdentifier: NSCalendarIdentifierGregorian)
        return formatter.stringFromDate(date)
    }
    
    func isToday() -> Bool{// 判断日期是否是今天
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.stringFromDate(self) == format.stringFromDate(NSDate())
    }
    
    func isYestoday() -> Bool{// 判断日期是否是昨天
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.stringFromDate(self) == format.stringFromDate(NSDate().dateByAddingTimeInterval(-24*60*60))
    }
    //获取星座
    func getAstro()->String{
        let m = Int(self.getMonth())
        let d = Int(self.getDay())
        var s = ["魔羯","水瓶","双鱼","牡羊","金牛","双子","巨蟹","狮子","处女","天秤","天蝎","射手","魔羯"]
        var arr = [20,19,21,21,21,22,23,23,23,23,22,22]
        let index = m! - (d < (arr[m!-1]) ? 1 : 0)
        return "\(s[index])座"
    }
    
    func getAge()->Int{
        if self.getMonth() < NSDate().getMonth() || (self.getMonth() == NSDate().getMonth() && self.getDay() <= NSDate().getDay()){
            return Int(NSDate().getYear())! - Int(self.getYear())!
        }else{
            return Int(NSDate().getYear())! - Int(self.getYear())!-1
        }
    }
    
    
    func getYear() -> String{
        let format = NSDateFormatter()
        format.dateFormat = "yyyy"
        return format.stringFromDate(self)
    }
    
    func getMonth() -> String{
        let format = NSDateFormatter()
        format.dateFormat = "MM"
        return format.stringFromDate(self)
    }
    func getDay() -> String{
        let format = NSDateFormatter()
        format.dateFormat = "dd"
        return format.stringFromDate(self)
    }
    
    func showTimeMD() -> String{
        let format = NSDateFormatter()
        format.dateFormat = "MM-dd"
        return format.stringFromDate(self)
    }
    
    func noticeTime() -> String{
        let format = NSDateFormatter()
        if self.isToday(){
            format.dateFormat = "HH:mm"
        }else if self.isYestoday(){
            format.dateFormat = "昨天 HH:mm"
        }else{
            format.dateFormat = "MM-dd"
        }
        return format.stringFromDate(self)
    }
    
    func dateToYmd() -> String{
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.stringFromDate(self)
    }
    
    func dateIsWeek() -> Int{
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        return (days - 3) % 7
    }
}
//MARK:NSTimeInterval extension
extension NSTimeInterval {
    public func toMinSecString() -> String {
        let seconds = Int64(self)
        let minString = seconds / 60 > 0 ? "\(seconds / 60)" : "00"
        let secString = seconds % 60 > 9 ? "\(seconds % 60)" : "0\(seconds % 60)"
        return "\(minString):\(secString)"
    }
}
//MARK:NSObject extension
extension NSObject {
    /**
     在主队列上延迟指定的时间执行闭包的操作，用于更新界面
     
     - parameter seconds: 秒数，类型为Double
     - parameter closure: 闭包，将在主队列上执行
     */
    func delayWithSeconds(seconds: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(seconds * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
//MARK:NSUserDefaults extension
extension NSUserDefaults {
    
    static func defaultsSetValue<T: AnyObject>(value: T?, forKey defaultName: String) -> NSUserDefaults.Type {
        let ud = UserDefaultInstance
        
        switch value {
        case let realValue as Int:
            ud.setInteger(realValue, forKey: defaultName)
        case let realValue as Float:
            ud.setFloat(realValue, forKey: defaultName)
        case let realValue as Double:
            ud.setDouble(realValue, forKey: defaultName)
        case let realValue as Bool:
            ud.setBool(realValue, forKey: defaultName)
        case let realValue as NSURL:
            ud.setURL(realValue, forKey: defaultName)
        default:
            ud.setObject(value, forKey: defaultName)
        }
        
        return self
    }
    
    static func defaultsValueForKey<T>(name: String, inout value: T?) -> NSUserDefaults.Type {
        let ud = UserDefaultInstance
        
        switch T.self {
        case is Int.Type:
            value = ud.integerForKey(name) as? T
        case is Float.Type:
            value = ud.floatForKey(name) as? T
        case is Double.Type:
            value = ud.doubleForKey(name) as? T
        case is Bool.Type:
            value = ud.boolForKey(name) as? T
        case is NSURL.Type:
            value = ud.URLForKey(name) as? T
        case is String.Type:
            value = ud.stringForKey(name) as? T
        case is NSData.Type:
            value = ud.dataForKey(name) as? T
        default:
            value = ud.objectForKey(name) as? T
        }
        return self
    }
}
//MARK:NSBundle extension
extension NSBundle {
    class func pathForResource(name: String, type: String?) -> String? {
        return NSBundle.mainBundle().pathForResource("minus", ofType: ".png")
    }
}
//MARK:NSDictionary extension
extension NSDictionary{
    
    func getIntByKey(key: String) -> Int{
        var returnStr = -101
        if let str = self[key] as? Int{
            returnStr = str
        }
        return returnStr
    }
    
    func getStringByKey(key: String) -> String{
        var returnStr: String = ""
        if let str = self[key] as? String{
            returnStr = str
        }
        return returnStr
    }
    
    func getIntOrStr(key: String) -> String{
        var returnStr: String = ""
        if let str = self[key] as? String{
            returnStr = str
        }
        if let str = self[key] as? Int{
            returnStr = "\(str)"
        }
        return returnStr
    }
    
    func getStringByKeys(keys: [String]) -> String{
        var returnStr: String = ""
        for key in keys{
            if let str = self[key] as? String{
                returnStr = str
            }
        }
        return returnStr
    }
}