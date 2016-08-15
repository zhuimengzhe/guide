
//add by mc... 12-05
import UIKit

let AlertInstance = CustomAlertView()
class CustomAlertView: UIView {
    
    var contentLabel: UILabel!
    var hud : MBProgressHUD?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initBackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectMake(0, UIScreen.mainScreenHeight, UIScreen.mainScreenWidth, 30))
    }
    
    private func initBackView(){
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.setWane(6)
        //内容
        self.contentLabel = UILabel()
        self.contentLabel.frame = CGRectMake(10, 5, self.frame.width - 20, 20)
        self.contentLabel.textColor = UIColor.whiteColor()
        self.contentLabel.textAlignment = NSTextAlignment.Center
        self.contentLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(self.contentLabel)
    }
    func showHud(view:UIView, str:String,dely:NSTimeInterval = 0.8){
        if hud == nil {
            hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud?.delegate = self
        }
        hud!.mode = .Text
        hud!.labelText = str
        hideHud(dely)
    }
    func hideHud(dely:NSTimeInterval = 0){
        hud!.hide(true, afterDelay: dely)
    }
    func setHudText(str:String){
        hud!.labelText = str
    }
    
    func showAlert(content: String!, disappear: (() -> Void)? = nil){
        
        self.contentLabel.text = content
        self.contentLabel.sizeToFit()
        
        self.contentLabel.frame.size.width = min(self.contentLabel.frame.width, ScreenWidth - 40)
        
        let alertH = self.contentLabel.endY+5
        let alertW = self.contentLabel.frame.width+30
        
        self.frame = CGRectMake((UIScreen.mainScreenWidth-alertW)/2, UIScreen.mainScreenHeight-alertH-20, alertW, alertH)
        
        self.contentLabel.center = self.centerP
        
        
        self.contentLabel.textAlignment = NSTextAlignment.Center
        self.scaleMyView()
        let window: AnyObject? = UIApplication.sharedApplication().windows.last
        window?.addSubview(self)
        self.alpha = 0.7
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.originY -= 70.Fit6()
        })
        self.scaleBigWithTime(0.05) { () -> Void in
            UIView.animateWithDuration(1, delay: 1.6, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (f) -> Void in
                    if f{
                        self.removeFromSuperview()
                        disappear?()
                    }
            })
        }
    }
}
extension CustomAlertView : MBProgressHUDDelegate {
    func hudWasHidden(hud: MBProgressHUD!) {
        self.hud = nil
    }
}
