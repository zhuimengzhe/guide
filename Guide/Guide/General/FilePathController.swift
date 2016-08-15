
import UIKit
let FilePathInstance = FilePathController()
class FilePathController: NSObject {
    
    /**
     在DocumentDirectory 个人文件夹 路径下获取子文件夹路径（不存在则创建子文件夹并返回路径）
     
     - parameter floderName: 子文件夹名称（若不传，则由uuid随机生成）
     
     - returns: 子文件夹路径
     */
    func tempUnzipPath(floderName: String = NSUUID().UUIDString) -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        path += "/\(floderName)"
        let url = NSURL(fileURLWithPath: path)
        
        //创建文件夹
        let exist = fileSingtonManager.fileExistsAtPath(url.path!)
        
        if !exist {
            try! fileSingtonManager.createDirectoryAtPath(url.path!, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    //判断路径下是否存在子文件
    /**paramer:
     1.path:  路径(绝对路径)
     */
    class func findFileInFolder(path: String) -> Bool{
        var recordings = [String]()
        dispatch_async(GlobalMainQueue) {
            let fileManager = NSFileManager.defaultManager()
            do {
                
                let files =  try fileManager.contentsOfDirectoryAtPath(path)
                
                recordings = files.filter({ (name) -> Bool in
                    return true
                })
                
            } catch {
                print("出错啦")
            }
        }
        return recordings.count > 0
    }
    
    //判断某个路径文件是否存在
    /**paramer:
     1.path:  路径(绝对路径)
     */
    class func findFileByPath(pathName: String) -> Bool{
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(pathName)
    }
    
    class func renameFileByPath(path: String, oldName: String, newName: String){
        let fileManager = NSFileManager.defaultManager()
        guard fileManager.fileExistsAtPath(path + "/" + oldName) else{
            print("没有发现文件哦")
            return
        }
        do{
            try fileManager.moveItemAtPath(path + "/" + oldName, toPath: path + "/" + newName)
        }catch{
            print("文件移动失败")
        }
    }
    
    private let fileSingtonManager = NSFileManager.defaultManager()
    
    //主目录 整个应用程序各文档所在的目录
    func homePath() -> String {
        return NSHomeDirectory()
    }
    
    //用户文档目录，苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
    func documentPath() -> String{
        let documentpaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if let documentpath = documentpaths.first {
            return documentpath
        }else{
            return NSHomeDirectory() + "/Documents"
        }
    }
    
    func documentURL() -> NSURL? {
        let documentpaths = fileSingtonManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        if let documentpath = documentpaths.first {
            return documentpath
        }
        return nil
    }
    
    //Library目录
    //Library/Preferences目录，包含应用程序的偏好设置文件。不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好。
    func libraryPath() -> String {
        let libraryPaths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        if let librarypath = libraryPaths.first {
            return librarypath
        }else{
            return NSHomeDirectory() + "/Library"
        }
    }
    
    //Library/Caches目录，主要存放缓存文件，iTunes不会备份此目录，此目录下文件不会再应用退出时删除
    func cachePath() -> String {
        let cachePaths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        if let cachepath = cachePaths.first {
            return cachepath
        }else{
            return NSHomeDirectory() + "/Library/Caches"
        }
    }
    
    //tmp目录 用于存放临时文件，保存应用程序再次启动过程中不需要的信息，重启后清空。
    func tmpPath() -> String {
        return NSTemporaryDirectory()
        //return NSHomeDirectory() + "/tmp"
    }
    
    //mainBundle 工程打包安装后会在NSBundle.mainBundle()路径下，该路径是只读的，不允许修改。
}
