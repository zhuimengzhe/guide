
import UIKit

class SegmentViewController: BaseViewController {
    
    var topView: UIView!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    //景区名单vc
    var scenicVc: ScenicSelectViewController!
    //下载管理vc
    var downloadingVc: DLSegmentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        //地图模式
        let color = UIColor ( red: 0.0588, green: 0.4588, blue: 0.5725, alpha: 1.0 )
        let fr = CGRectMake(0.0, 0.0, 80.Fit6(), 30.Fit6())
        let img = color.getImageByRect(fr)
        let btn = UIButton(frame:fr)
        btn.setBackgroundImage(img, forState: .Normal)
        btn.setTitle("地图模式", forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.Fit6())
        btn.setWane(4)
        btn.addTarget(self, action: #selector(mapMode), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        //初始化
        initView()
    }
    
    func mapMode(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func initView(){
        //上面的View
        topView = UIView()
        topView.frame = CGRectMake(10.Fit6(), 5.Fit6(), view.frame.width - 20.Fit6(), 38.Fit6())
        topView.backgroundColor = UIColor.whiteColor()
        topView.layer.shadowColor = Color_999.CGColor
        topView.layer.shadowOffset = CGSizeMake(0,0.5)
        topView.setWane(4)
        view.addSubview(topView)
        
        let w = view.frame.width - 30.Fit6()
        //景区选择按钮
        leftButton = UIButton(frame:CGRectMake(5.Fit6(),3.Fit6(), w / 2 - 10.Fit6(), 32.Fit6()))
        leftButton.setTitle("景区选择".internationByKey("select_scenic_area"), forState: UIControlState.Normal)
        let img = Color_topNav.getImageByRect(leftButton.bounds)
        leftButton.setTitleColor(Color_333, forState: UIControlState.Normal)
        
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        leftButton.setBackgroundImage(img, forState: UIControlState.Highlighted)
        
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        leftButton.setBackgroundImage(img, forState: UIControlState.Selected)
        leftButton.addTarget(self, action: #selector(SegmentViewController.didSegTopButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        leftButton.tag = 0
        leftButton.setWane(8)
        topView.addSubview(leftButton)
        
        //下载管理
        rightButton = UIButton()
        rightButton.frame = CGRectMake(leftButton.endX + 20.Fit6(), leftButton.originY, leftButton.frameWidth,leftButton.frameHeight)
        rightButton.setTitle("下载管理".internationByKey("x_z_g_l"), forState: UIControlState.Normal)
        rightButton.setTitleColor(Color_333, forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        rightButton.setBackgroundImage(img, forState: UIControlState.Highlighted)
        
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        rightButton.setBackgroundImage(img, forState: UIControlState.Selected)
        
        
        rightButton.setWane(8)
        rightButton.addTarget(self, action: #selector(SegmentViewController.didSegTopButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.tag = 1
        topView.addSubview(rightButton)
        
        //左边按钮选中
        leftButton.selected = true
        scenicVc = ScenicSelectViewController()
        addChildViewController(scenicVc)
        
        //景区选择
        let dFrame = CGRectMake(0, topView.endY + 4.Fit6(), ScreenWidth, ScreenHeight - topView.endY - 4.Fit6())
        scenicVc.view.frame = dFrame
        view.addSubview(scenicVc.view)
        
        //下载管理
        downloadingVc = DLSegmentViewController()
        addChildViewController(downloadingVc)
        
        downloadingVc.view.frame = dFrame
        view.addSubview(downloadingVc.view)
        downloadingVc.view.hidden = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if scenicVc.view.hidden {
            
        }else{
            //scenicVc.refresh()
        }
    }
    
    func didSegTopButton(btn: UIButton){
        leftButton.selected = btn.tag == 0
        rightButton.selected = btn.tag == 1
        
        scenicVc.view.hidden = btn.tag == 1
        downloadingVc.view.hidden = btn.tag == 0
    }
}
