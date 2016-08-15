
import UIKit
import Alamofire
class DownloadingViewController: BaseViewController, ScenicSelectViewControllerDelegate{

    var cellArray = [DownloadScenic]()
    lazy var tv: UITableView = {
        var tv = UITableView(frame: CGRectMake(0, 0, ScreenWidth, self.view.frame.height - 64 - 48))
        tv.backgroundColor = UIColor.clearColor()
        tv.delegate = self
        tv.dataSource = self
        tv.tag = 1
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tv)
        return tv
    }()
    
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    var downloadRequest: Request?
    
    var cancelData: NSData?
    var isCancel = false
    func willDownload(scenic: Scenic){
        if !UserInstance.isLogin() {
            AlertInstance.showAlert("请登录后再下载景区资源")
            return
        }
        
        printLog("下载\(destination)")
        self.getFile()

        let parameter = [
            "uid"   : UserInstance.user.id!,
            "sid"   : scenic.id!,
            "lat" : "35.764148",
            "lng" : "116.82855"
        ]
        let request = Alamofire.download(.POST, Http_download, parameters: parameter, destination: destination)
        
        let downloadScenic = DownloadScenic(scenic: scenic, request: request)
        self.cellArray.append(downloadScenic)
        self.tv.reloadData()
        
        let index = self.cellArray.count-1
        //下载中,更新进度条...
        downloadScenic.willDownLoad({ (progress) -> Void in
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tv.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }) { () -> Void in
                AlertInstance.showAlert("景区资料下载成功")
                CoreDatasharedInstance.saveScenic(scenic)
                let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                let zipPath = path + "/\(scenic.id!).zip"
                let unZippath = path + "/scenicListFloder/\(scenic.id!)"
                ZipsharedInstance.unZipFile(zipPath, unZipPath: unZippath)
        }
    }
    
    func getFile(){
        
    }

}


extension DownloadingViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.cellArray.count
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = DownloadingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let object = self.cellArray[indexPath.row]
        cell.setFrameByObject(object)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if isCancel{
//            if let cancelData = self.cancelData {
//                self.downloadRequest = Alamofire.download(resumeData: cancelData,
//                    destination: destination)
//                
//                self.willDownLoad()
//            }
//        }else{
//            self.downloadRequest?.cancel()
//        }
//        self.isCancel = !self.isCancel
    }
}
