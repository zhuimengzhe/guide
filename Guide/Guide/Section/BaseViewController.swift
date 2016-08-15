import UIKit

class BaseViewController: UIViewController {
    //MARK:VC代理方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color_mainBg
        
        //去除返回键的文字
        let backImage = UIImage(named: "back")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 10, 0, 0))
        
        let backBar = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.back))
        self.navigationItem.leftBarButtonItem = backBar
        
        //监听键盘事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.enterBack), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.enterFront), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    func enterBack(){
        
    }
    
    func enterFront(){
    }
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    // MARK: Textfield Inputs
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //键盘显示/消失处理...
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let ty = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
        let animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let firstView = self.findSubViews(self.view)
        if firstView == nil{
            return
        }
        let fY = self.getYToView(firstView)
        
        let curY = fY - (self.view.frame.height - ty! - firstView.frame.height + 64) / 2
        
        UIView.animateWithDuration(animationDurationValue.doubleValue, animations: { () -> Void in
            if curY <= 0{
                self.view.transform = CGAffineTransformIdentity
            }else{
                self.view.transform.ty = -curY
            }
        })
    }
    func keyboardWillHide(note : NSNotification){
        self.view.transform = CGAffineTransformIdentity
    }
    
    func findSubViews(superView: UIView)->UIView!{
        for v in superView.subviews{
            if v.isFirstResponder(){
                return v
            }
            if v.subviews.count != 0{
                let result = self.findSubViews(v)
                if result != nil{
                    return result
                }
            }
        }
        return nil
    }
    
    func getYToView(v: UIView)->CGFloat{
        if v.superview == nil{
            return 0
        }
        if v.superview == self.view{
            return v.originY
        }
        return v.originY + getYToView(v.superview!)
    }
}



