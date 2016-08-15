

import UIKit

class DownloadedViewController: UIViewController {

    var cellArray = [Scenic]()
    lazy var tv: UITableView = {
        var tv = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreenWidth, self.view.frame.height-64-48))
        tv.backgroundColor = UIColor.clearColor()
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tv)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFile()
    }
    
    func getFile(){
        self.cellArray = CoreDatasharedInstance.findAllScenic()
        self.tv.reloadData()
    }
}

extension DownloadedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.cellArray.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = ScenicTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        print(indexPath.row)
        let object = self.cellArray[indexPath.row]
        cell.setFrameByObject(object)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let to_vc = SpotInfoViewController()
        to_vc.scenic = self.cellArray[indexPath.row]
        self.navigationController?.pushViewController(to_vc, animated: true)//presentViewController(to_vc, animated: false, completion: nil)
    }
}
