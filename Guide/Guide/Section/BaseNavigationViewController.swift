
//create by mc on 2015-12-28
import UIKit
//全局导航栏样式
class BaseNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.enabled = true
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(18)]
        self.navbackgroundColor = Color_topNav
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    /**
     *  导航控制器 统一管理状态栏颜色
     *  @return 状态栏颜色
     */
    //override func preferredStatusBarStyle() -> UIStatusBarStyle {
    //return .LightContent
    //}
    
    override func shouldAutorotate() -> Bool {
        return false 
        //if let topvc = self.topViewController {
            //return topvc.shouldAutorotate()
        //}else{
            //return true
        //}
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}


//扩展修改导航栏背景色...
extension UINavigationController{
    
    @IBInspectable
    var navbackgroundColor: UIColor! {
        get{
            return self.navbackgroundColor
        }
        set(newValue) {
            self.mc_setBackgroundColor(newValue)
        }
    }
    
    private func mc_setBackgroundColor(color: UIColor){
        self.navigationBar.setBackgroundImage(UIColor.clearColor().getImageByRect(CGRectMake(0,0,UIScreen.mainScreenWidth,64)), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.subviews[0].backgroundColor = color
        self.navigationBar.shadowImage = UIImage()
    }
}

