
import UIKit
//文件管理...
class FileUtilController: NSObject {
    static private let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    static private let docsDir: NSString? = dirPaths.first
    
    class func saveImgToBound(img: UIImage, imgName: String){
        let imgFilePath = docsDir!.stringByAppendingPathComponent(imgName)
        var writeResult: Bool!
        dispatch_async(GlobalMainQueue) {
            if let imageData = UIImagePNGRepresentation(img){
                writeResult = imageData.writeToFile(imgFilePath, atomically: true)
            }else if let imageData = UIImageJPEGRepresentation(img, 0){
                writeResult = imageData.writeToFile(imgFilePath, atomically: true)
            }
            if writeResult == nil{
                printLog("保存图片失败nil")
            }else if !writeResult {
                printLog("保存图片失败")
            }else{
                printLog("保存图片：\(imgFilePath)成功")
            }
        }
    }
    class func findImgByBound(imgName: String) -> UIImage? {
        let imgFilePath = docsDir!.stringByAppendingPathComponent(imgName)
        if let img = UIImage(contentsOfFile: imgFilePath){
            return img
        }
        return nil
    }
}
