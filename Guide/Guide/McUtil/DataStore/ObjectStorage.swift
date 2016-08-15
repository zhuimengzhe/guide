
import UIKit

class ObjectStorage: NSObject {//对象归档
   
    class func saveByKey(key: String, object: AnyObject!){
        let homePath = ObjectStorage.getPath()
        dispatch_async(GlobalMainQueue) {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(object, forKey: key)
            archiver.finishEncoding()
            if data.writeToFile(homePath, atomically: true){
                debugPrint("归档成功")
                NSNotificationCenter.defaultCenter().postNotificationName("updateContatcs", object: nil, userInfo: nil)
            }else{
                debugPrint("归档失败")
            }
        }
    }
    
    class func findByKey(key: String)->AnyObject!{
        let homePath = ObjectStorage.getPath()
        if let data = NSMutableData(contentsOfFile: homePath){
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            debugPrint(unarchiver.decodeObjectForKey(key))
            return unarchiver.decodeObjectForKey(key)
        }
        return nil
    }
    
    class func getPath() -> String{//归档根目录
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir:NSString? = dirPaths.first
        return docsDir!.stringByAppendingPathComponent("guidang")
    }
 
    // 归档系统消息
    class func saveSystemInfoByKey(key: String, object: AnyObject!) {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as AnyObject
        let filePath = path.stringByAppendingPathComponent("systemData.archive")
        dispatch_async(GlobalMainQueue) {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(object, forKey: key)
            archiver.finishEncoding()
            if data.writeToFile(filePath, atomically: true) {
                debugPrint("系统消息归档成功")
            }else{
                debugPrint("系统消息归档失败")
            }
        }
    }
    
    // 解档系统消息
    class func getSystemInfoByKey(key: String) -> AnyObject! {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as AnyObject
        let filePath = path.stringByAppendingPathComponent("systemData.archive")
        if let data = NSMutableData(contentsOfFile: filePath){
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            return unarchiver.decodeObjectForKey(key)
        }
        return nil
    }
}
