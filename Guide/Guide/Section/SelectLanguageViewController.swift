
import UIKit

class SelectLanguageViewController: BaseViewController {
    
    let cellArray = ["中文简体","English","日本語","한글","Español"]
    let cellLan = ["zh-Hans","en","ja","ko","es"]
    var tv: UITableView!
    
    var curSelect = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "语言选择"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SelectLanguageViewController.didRightButton))
        
        let selectLan = UserDefaultInstance.stringForKey(UserLanguageKey)
        print("seleclan \(selectLan)")
        curSelect = cellLan.indexOf(selectLan!)!
        initListView()
    }
    
    func didRightButton(){
        //语言版本(中文zh-Hans,英文en,日文ja,西班牙文es,韩文ko,)
        InternationInstance.setUserLanguage(cellLan[curSelect])
        if UserInstance.isLogin() {
            let parameter = [
                "uid" : UserInstance.user.id!,
                "language":cellLan[curSelect]
            ]
            HttpInstance.requestJSON(.POST, Http_usersetlanguage,parameters: parameter){
                [unowned self] res in
                AlertInstance.showHud(KeyWindow, str: res["message"] as! String)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }else{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    //MARK: - ClassAddViewControllerDelegate
    func initListView(){
        tv = UITableView(frame: view.bounds)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.clearColor()
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(tv)
        tv.selectRowAtIndexPath(NSIndexPath.init(forRow: curSelect, inSection: 0), animated: true, scrollPosition: .Top)
    }
}

extension SelectLanguageViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cellArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        return cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? LanguageCell
        if cell == nil {
            cell = LanguageCell(style: .Default, reuseIdentifier: "cell")
        }
        let object = cellArray[indexPath.row]
        cell!.setFrameByObject(object)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        curSelect = indexPath.row
    }
}
