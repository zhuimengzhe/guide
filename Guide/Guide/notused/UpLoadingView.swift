

import UIKit

let UpLoadingViewsharedInstance = UpLoadingView()
class UpLoadingView: UIView {
    
    let myhud = MBProgressHUD()
    let activityViewFor = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    let activityBackView = UIView()
    let loadingLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initImgView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    func initImgView(){
        let wh: CGFloat = 120
        self.activityBackView.frame = CGRectMake((UIScreen.mainScreenWidth-wh)/2, (UIScreen.mainScreenHeight-wh)/2, wh, wh)
        self.activityBackView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        self.activityBackView.setWane(8)
        self.addSubview(self.activityBackView)
        
        let size:CGFloat = 60.0
        self.activityViewFor.frame = CGRectMake((wh-size)/2, (wh-size)/2-20, size, size)
        self.activityBackView.addSubview(self.activityViewFor)
        
        self.loadingLabel.frame = CGRectMake(0, self.activityViewFor.endY, wh, 20)
        self.loadingLabel.textColor = UIColor.whiteColor()
        self.loadingLabel.textAlignment = NSTextAlignment.Center
        self.loadingLabel.font = UIFont.systemFontOfSize(12)
        self.activityBackView.addSubview(self.loadingLabel)
    }
    
    var target: UIViewController!
    func startLoading(target: UIViewController, text: String = "努力加载中..."){
        self.loadingLabel.text = text
        self.target = target
        self.frame = target.view.bounds
        self.activityViewFor.startAnimating()
        target.view.userInteractionEnabled = false
        target.view.addSubview(self)
    }
    
    func stopLoading(){
        if self.target != nil{
            target.view.userInteractionEnabled = true
        }
        self.activityViewFor.stopAnimating()
        self.removeFromSuperview()
    }
    
    func showHUD(content:String,dur:NSTimeInterval){
        
    }
    func hideHUD() {
        myhud.hide(true)
    }
}
