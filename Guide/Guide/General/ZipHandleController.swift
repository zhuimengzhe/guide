

import UIKit
import SSZipArchive
let ZipsharedInstance = ZipHandleController()
class ZipHandleController: NSObject {
    private let fileInstance = NSFileManager.defaultManager()
    func unZipFile(path: String!, unZipPath: String!) {
        
        guard let zipPath = path else {
            return
        }
        
        guard let unzipPath = unZipPath else {
            return
        }
        
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unzipPath)
        if !success {
            AlertInstance.showHud(KeyWindow, str: "解压失败")
            return
        }else{
            //解压完将压缩文件删除
            try! fileInstance.removeItemAtPath(zipPath)
        }
    }
    
    func scenicPath() -> String? {
        return FilePathInstance.tempUnzipPath("scenicListFloder")
    }
    
    func getFile(){
        dispatch_async(GlobalMainQueue) {
            guard let unzipPath = self.scenicPath() else {
                return
            }
            
            do {
                let files =  try self.fileInstance.contentsOfDirectoryAtPath(unzipPath)
                let recordings = files.filter({
                    (name) -> Bool in
                    print(name)
                    return name.hasPrefix("")
                })
                print(recordings.count)
                
                for (i, fileName) in recordings.enumerate(){
                    let path = unzipPath + "/" + fileName
                    print("filePath\(i): \(path)")
                }
            } catch {
                
            }
        }
    }
    
    // unzipPath /scenicFolder
    func removeAllFiles(folderpath:String) {
        let fileArray = fileInstance.subpathsAtPath(folderpath)
        for fn in fileArray! {
            var isDir:ObjCBool = false
            if fileInstance.fileExistsAtPath(fn, isDirectory: &isDir) && isDir {
                removeAllFiles(folderpath + "/\(fn)")
            }else{
                try! fileInstance.removeItemAtPath(folderpath + "/\(fn)")
            }
        }
    }
    //删除    景区
    func removeScenic(scenicPath:String) {
        removeAllFiles(scenicPath)
    }
    //删除    景点
    func removeSpot(spotPath:String) {
        let exist = fileInstance.fileExistsAtPath(spotPath)
        if exist {
            try! fileInstance.removeItemAtPath(spotPath)
        }else{
            print("文件不存在")
        }
    }
    
    func tempZipPath() -> String {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString).zip"
        return path
    }
}
