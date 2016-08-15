
import UIKit
import Alamofire
class DLSegmentViewController: BaseViewController{
    private let titleColor = UIColor.colorWithHexCode("999999")
    private let titleColorSelected = Color_topNav
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    
    let segmentTitles = ["已付费".internationByKey("y_f_f"),"未付费".internationByKey("w_f_f")]
    var dataSource = [Scenic]()
    
    var tableview:UITableView!
    var slideLabel:UILabel!
    var btnW:CGFloat = 0.0
    var buttons = [UIButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        if AppTest {
            for i in 0 ..< 5 {
               let secenic = Scenic(dict: ["ss_id":"idd\(i)","ss_name1":"泰山\(i)","ss_lng":"116.404","ss_lat":"39.915","ss_logo":"logo","ss_summary1":"泰山风景以壮丽著称，重叠的山势,厚重的形体，苍松巨石的烘托,云烟的变化，使它在雄伟"])
                dataSource.append(secenic)
            }
        }
        initBodyTop()
        initTableView()
    }
    
    func initBodyTop(){
        let segview = UIView(frame:CGRectMake(0,0,ScreenWidth,44.Fit6()))
        segview.backgroundColor = UIColor.whiteColor()
        view.addSubview(segview)
        
        let t = CGFloat(segmentTitles.count)
         btnW = (ScreenWidth - t) / t
        
        for title in segmentTitles {
            let btn = UIButton()
            btn.setTitle(title, forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14.Fit6())
            let index = segmentTitles.indexOf(title)
            btn.frame = CGRectMake(btnW * CGFloat(index!), 0, btnW, segview.frameHeight)
            btn.setTitleColor(titleColor, forState: .Normal)
            btn.setTitleColor(titleColorSelected, forState: .Selected)
            btn.tag = index!
            btn.addTarget(self, action: #selector(DLSegmentViewController.segmentClicked(_:)), forControlEvents: .TouchUpInside)
            buttons.append(btn)
            segview.addSubview(btn)
        }
        slideLabel = UILabel(frame: CGRectMake(0,segview.frameHeight - 1,btnW,2))
        buttons[0].selected = true
        slideLabel.backgroundColor = titleColorSelected
        slideLabel.setWane(1)
        segview.addSubview(slideLabel)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.separatorInset = UIEdgeInsetsZero
        tableview.layoutMargins = UIEdgeInsetsZero
    }
    
    func initTableView(){
        tableview = UITableView(frame: CGRectMake(0, 49.Fit6(), ScreenWidth, view.frameHeight - 64 - 87.Fit6()),style:.Plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.allowsSelection = false
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        view.addSubview(tableview)
    }
    func segmentClicked(btn:UIButton){
        
        if btn.tag == 0 {
            buttons[0].selected = true
            buttons[1].selected = false
        }else{
            buttons[0].selected = false
            buttons[1].selected = true
        }
        UIView.animateWithDuration(0.4) { 
             [unowned self] in
            self.slideLabel.center = CGPointMake(btn.centerFrameX, self.slideLabel.centerFrameY)
        }
    }
    func getLocalScenic(){
        dataSource = CoreDatasharedInstance.findAllScenic()
        tableview.reloadData()
    }
    func willDownload(scenic: Scenic){
        if !UserInstance.isLogin() {
            AlertInstance.showHud(KeyWindow, str: "请登录后再下载景区资源")
            return
        }
        
        printLog("下载 路径 \(destination)")
        
        let parameter = [
            "uid"   : UserInstance.user.id!,
            "sid"   : scenic.id!,
            "lat" : "35.764148",
            "lng" : "116.82855"
        ]
        let request = Alamofire.download(.POST, Http_download, parameters: parameter, destination: destination)
        
        let downloadScenic = DownloadScenic(scenic: scenic, request: request)
        //self.cellArray.append(downloadScenic)
        //self.tv.reloadData()
        
        let index = dataSource.count - 1
        //下载中,更新进度条...
        downloadScenic.willDownLoad({ (progress) -> Void in
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableview.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }) { () -> Void in
            
            AlertInstance.showHud(KeyWindow, str: "景区资料下载成功")
            CoreDatasharedInstance.saveScenic(scenic)
            let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            
            let zipPath = path + "/\(scenic.id!).zip"
            let unZippath =  path + "/scenicListFloder/\(scenic.id!)"
            ZipsharedInstance.unZipFile(zipPath, unZipPath: unZippath)
        }
    }
}
extension DLSegmentViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableview, cellForRowAtIndexPath: indexPath)
        return cell.frameHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = DownloadTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let object = dataSource[indexPath.row]
        cell.setFrameByObject(object)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableview.deselectRowAtIndexPath(indexPath, animated: true)
        let to_vc = ScenicInfoViewController()
        to_vc.scenic = dataSource[indexPath.row]
        let navi = BaseNavigationViewController(rootViewController: to_vc)
        presentViewController(navi, animated: true, completion: nil)
    }
}
