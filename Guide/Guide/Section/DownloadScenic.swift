
import UIKit
import Alamofire

enum DownloadState : Int {
    case Downloading = 0//下载中
    case Downloaded = 1//已下载
    case Downpause = 2//已暂停
}
class DownloadScenic: NSObject {
    var scenic: Scenic!
    var request: Request?
    var progress: Float = 0.0
    var downState: DownloadState!
    
    init(scenic: Scenic, request: Request){
        self.scenic = scenic
        self.request = request
    }
    func download(){
        
        Alamofire.download(.GET, "https://httpbin.org/stream/100") { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename
            
            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        }
    }
    
    func willDownLoad(progressChanged: (progress: Float)->Void, succeed: ()->Void){
        
        self.request?.progress{
            [unowned self] bytesRead, totalBytesRead, totalBytesExpectedToRead in
            dispatch_async(dispatch_get_main_queue()) {
                print("Total bytes read on main queue: \(totalBytesRead)")
                self.progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                progressChanged(progress: self.progress)
            }
            }
            .response { _, _, _, error in
                if let error = error {
                    if error.code == NSURLError.Cancelled.rawValue{
                        print("Failed with error: 取消下载了啊")
                    }
                    print("Failed with error: \(error)")
                } else {
                    print("Downloaded file successfully")
                    succeed()
                }
                if let resumeData = self.request?.resumeData,
                    resumeDataString = NSString(data: resumeData, encoding: NSUTF8StringEncoding) {
                    print("resumedata \(resumeDataString)")
                }else{
                    print("resume data was empty")
                }
        }
    }
}
