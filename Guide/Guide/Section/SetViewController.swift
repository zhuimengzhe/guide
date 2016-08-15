
import UIKit

class SetViewController: BaseViewController {
    var tableView:UITableView!
    let shareView = ShareView()
    
    private let CellTag_Start = 1000
    private let cellH: CGFloat = 48.Fit6()
    private let cellW: CGFloat = ScreenWidth - 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        shareView.setWane(2)
        initFormView()
    }
    
    func initFormView(){
        tableView = UITableView(frame:CGRectMake(10, 0, cellW, view.bounds.size.height), style: .Plain)
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Color_line
        tableView.separatorStyle = .SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.delegate = self
        tableView.dataSource = self
        
        let header = UIView(frame: CGRectMake(0,0,cellW,10))
        header.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = header
        view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    let switch1 = SwitchView("是".internationByKey("yes"), offText: "否".internationByKey("no"))
    let switch2 = SwitchView("听筒".internationByKey("t_t"), offText: "喇叭".internationByKey("l_b"))
    let switch3 = SwitchView("是".internationByKey("yes"), offText: "否".internationByKey("no"))
    
    let dataSource = [
        [
            "登录".internationByKey("login"),
            "景区选择".internationByKey("select_j_q"),
            "我的积分".internationByKey("my_points")
        ],
        
        [
            "自动讲解".internationByKey("z_d_j_j"),
            "收听方式".internationByKey("s_t_f_s"),
            "消息推送".internationByKey("x_x_t_s")
        ],
        
        [
            "微信".internationByKey("w_x"),
            "使用反馈".internationByKey("s_y_f_k"),
            "语言选择".internationByKey("y_y_x_z")
        ],
        
        [
            "关于我们".internationByKey("g_y_w_m"),
            "公司概况".internationByKey("g_s_g_k"),
            "用户协议".internationByKey("y_h_x_y"),
            "QQ交流群".internationByKey("j_l_q")
        ],
        
        [
            "退出".internationByKey("exit")
        ]
        
    ]
}
extension SetViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 10))
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellH
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = KSKRoundCornerCell(tableView: tableView, style: .Default, radius: 6, indexPath: indexPath, strokeLineWidth: 0.5, strokeColor: Color_ccc)
    
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.preservesSuperviewLayoutMargins = false
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.whiteColor()
        cell.textLabel?.textColor = Color_333
        cell.textLabel?.textAlignment = .Left
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        if indexPath.section != 4 {
            
            if indexPath.section == 0 && indexPath.row == 0 && UserInstance.isLogin() {
                cell.textLabel?.text = "\(UserInstance.getAccount()!)"
            }
            if indexPath.section == 1 {
                var swit = switch1
                if indexPath.row == 0 {
                    switch1.on = UserDefaultInstance.boolForKey(ZiDongJiangJieKey)
                    swit = switch1
                }else if indexPath.row == 1 {
                    switch2.on = UserDefaultInstance.boolForKey(ShouTingFangShiKey)
                    swit = switch2
                }else if indexPath.row == 2 {
                    switch3.on = UserDefaultInstance.boolForKey(XiaoXiTuiSongKey)
                    swit = switch3
                }
                let swittag = CellTag_Start + indexPath.row
                swit.stag = swittag
                swit.delegate = self
                swit.center = CGPointMake(cellW - switch2.bounds.width / 2 - 10, cellH / 2)
                if cell.contentView.viewWithTag(swittag) != nil {
                    
                }else{
                    cell.contentView.addSubview(swit)
                }
            }else{
                cell.accessoryView = UIImageView(image: UIImage(named: "more"))
            }
        }else {
            cell.backgroundColor = Color_topNav
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.font = UIFont.systemFontOfSize(16)
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.layer.cornerRadius = 6
        }
        return cell
    }
    
}
extension SetViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = indexPath.section * CellTag_Start + indexPath.row
        let section = indexPath.section
        let row = indexPath.row
        let title = dataSource[section][row]
        switch tag{
        case 0:
            //登录
            if UserInstance.isLogin() {
                return
            }
            
            let to_vc = LoginViewController()
            to_vc.title = title
            self.navigationController?.pushViewController(to_vc, animated: true)
        case 1:
            //景区选择
            let to_vc = SegmentViewController()
            to_vc.title = title
            self.navigationController?.pushViewController(to_vc, animated: true)
        case 2:
            //我的积分
            if UserInstance.isLogin(){
                let to_vc = MyScoreViewController()
                to_vc.title = title
                self.navigationController?.pushViewController(to_vc, animated: true)
            }else{
                AlertInstance.showAlert("您还没有登录,请登录")
                let to_vc = LoginViewController()
                to_vc.title = title
                self.navigationController?.pushViewController(to_vc, animated: true)
            }
        case 2000:
            //分享
            shareView.show()
        case 2001:
            //反馈
            let to_vc = FeedbackViewController()
            self.navigationController?.pushViewController(to_vc, animated: true)
        case 2002:
            //语言选择
            let to_vc = SelectLanguageViewController()
            self.navigationController?.pushViewController(to_vc, animated: true)
        case 3000,3001,3002,3003:
            let to_vc = ArticalViewController()
            to_vc.type = row
            to_vc.title = title
            self.navigationController?.pushViewController(to_vc, animated: true)
        case 4000:
            let alertVC = UIAlertController(title: "提示".internationByKey("t_s"), message: "确认退出吗?".internationByKey("q_r_t_c_m"), preferredStyle: .Alert)
            
            let okAct = UIAlertAction(title: "确定".internationByKey("q_d"), style: .Default) {
                action in
                UserInstance.logout()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            let canAct = UIAlertAction(title: "取消".internationByKey("q_x"), style: .Default) {
                action in
                return
            }
            alertVC.addAction(okAct)
            alertVC.addAction(canAct)
            self.presentViewController(alertVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
extension SetViewController : SwitchViewProtocol {
    func SwitchViewValuchanged(tag: Int , onOff:Bool) {
        let keys = [ZiDongJiangJieKey,ShouTingFangShiKey,XiaoXiTuiSongKey]
        UserDefaultInstance.setBool(onOff, forKey: keys[tag - CellTag_Start])
        UserDefaultInstanceSync
    }
}
