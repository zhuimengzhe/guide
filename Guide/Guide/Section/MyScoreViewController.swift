
import UIKit

class MyScoreViewController: BaseViewController {
    
    var curPointLabel = UILabelPadding()
    var recordLabel = UILabelPadding()
    lazy var tv: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.clearColor()
        tv.dataSource = self
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        tv.allowsSelection = false
        self.view.addSubview(tv)
        return tv
    }()
    
    var cellArray = [Score]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        willOnSearch()
    }
    
    func initView(){
        curPointLabel.frame = CGRectMake(0, 64, UIScreen.mainScreenWidth, 60.Fit6())
        curPointLabel.backgroundColor = UIColor.whiteColor()
        curPointLabel.paddingLeft = 15
        curPointLabel.textColor = Color_333
        curPointLabel.font = UIFont.systemFontOfSize(14)
        view.addSubview(curPointLabel)
        
        recordLabel.frame = CGRectMake(0, curPointLabel.endY, UIScreen.mainScreenWidth, 40.Fit6())
        recordLabel.paddingLeft = 15
        recordLabel.textColor = Color_333
        recordLabel.text = "积分记录"
        recordLabel.font = UIFont.systemFontOfSize(14)
        view.addSubview(recordLabel)
        
        tv.frame = CGRectMake(0, recordLabel.endY, UIScreen.mainScreenWidth, UIScreen.mainScreenHeight - recordLabel.endY)
    }
    
    func willOnSearch(){
        let parameter = [
            "uid" : UserInstance.user.id!,
        ]
        HttpInstance.requestJSON(.GET, Http_customerinout, parameters: parameter){
            [unowned self] obj in
            let all = obj["point"]
            self.curPointLabel.text = "当前剩余积分：\(all!)"
            
            if let inOuts = obj["inOuts"] as? [NSDictionary]{
                for dic in inOuts{
                    self.cellArray.append(Score(dict: dic))
                }
                self.tv.reloadData()
            }
        }
    }
}

extension MyScoreViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cellArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = ScoreTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        let object = cellArray[indexPath.row]
        cell.setFrameByObject(object)
        return cell
    }
}
