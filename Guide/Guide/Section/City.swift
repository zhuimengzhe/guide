
import UIKit

class City: NSObject {
    
    var name: String!
    var pinyin: String!
    
    init(dict: NSDictionary) {
        self.name = dict.getStringByKey("name")
        self.pinyin = dict.getStringByKey("py")
    }
    
    func getPyCaptain()->String?{
        if self.pinyin == nil || self.pinyin.length == 0 {
            return nil
        }
        return self.pinyin?.subStringToI(1).uppercaseString
    }
}
