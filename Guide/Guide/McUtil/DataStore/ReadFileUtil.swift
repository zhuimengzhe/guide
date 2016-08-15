
import UIKit

class ReadFileUtil: NSObject {
    class func readJsonWithName(name: String) -> NSDictionary?{
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "json")
        let data:NSData = NSData(contentsOfFile: path!)!
        let dic : NSDictionary? = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
        return dic
    }
}
