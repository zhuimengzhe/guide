//import UIKit

//@objc protocol MMActionSheetDelegate: class {
    //optional func actionSheet(actionSheet: MMActionSheet, buttonIndex: NSInteger)
//}

//class MMActionSheet: UIView {
    
    //weak var _delegate: MMActionSheetDelegate?

    //var contentView: UIView!
    //var buttonView: UIView!
    //var backgroundButton: UIButton!
    //var cancelButton: UIButton!
    //var titleLabel: UILabel?
    //var _title: String?
    //var _cancelButtonTitle: String?
    //var buttonTitleArray: NSMutableArray!
    //var buttonArray: NSMutableArray!
    
    //var contentViewWidth: CGFloat!
    //var contentViewHeight: CGFloat!
    //var space: CGFloat = 8.0
    
    //func initSet(Title: String?, delegate: MMActionSheetDelegate, cancelButtonTitle: String, otherButtonTitles: String...) {
        //_title = Title
        //_cancelButtonTitle = cancelButtonTitle
        //_delegate = delegate
        //buttonTitleArray = NSMutableArray()
        //buttonArray = NSMutableArray()

        //for i in 0 ..< otherButtonTitles.count {
            //buttonTitleArray.addObject(otherButtonTitles[i])
        //}
        
        //self.frame = UIScreen.mainScreen().bounds
        //self.backgroundColor = UIColor.clearColor()
        
        //backgroundButton = UIButton()
        //backgroundButton.frame = self.frame
        //backgroundButton.backgroundColor = UIColor.blackColor()
        //backgroundButton.alpha = 0.2
        //backgroundButton.addTarget(self, action: #selector(MMActionSheet.touchBackgroundButton), forControlEvents: UIControlEvents.TouchUpInside)
        //self.addSubview(backgroundButton)
        
        //initContentView()
    //}

    //func initContentView() {
        //contentViewWidth = 300 * self.frame.size.width / 320
        //contentViewHeight = 0
        
        //buttonView = UIView()
        //contentView = UIView()
        
        //initTitle()
        //initButtons()
        //initCancelButton()
        
        //contentView.backgroundColor = UIColor.clearColor()
        //contentView.frame = CGRectMake((self.frame.width - contentViewWidth) / 2, self.frame.height, contentViewWidth, contentViewHeight)
        //self.addSubview(contentView)
        
    //}
    
    //func initTitle() {
        //if _title != nil {
            //titleLabel = UILabel()
            //titleLabel?.frame = CGRectMake(0, 0, contentViewWidth, 50)
            //titleLabel?.text = _title
            //titleLabel?.textAlignment = NSTextAlignment.Center
            //titleLabel?.font = UIFont.systemFontOfSize(15)
            //titleLabel?.textColor = UIColor.blackColor()
            //titleLabel?.backgroundColor = UIColor.whiteColor()
            //buttonView.addSubview(titleLabel!)
            //contentViewHeight = contentViewHeight + titleLabel!.frame.height
        //}
    //}
    
    //func initButtons() {
        //if buttonTitleArray.count > 0 {
            //let count = buttonTitleArray.count
            //for i in 0 ..< count {
                //let lineView = UIView(frame: CGRectMake(0, contentViewHeight, contentViewWidth, 1))
                //lineView.backgroundColor = UIColor.colorWithHexCode("E6E6E6")
                //buttonView.addSubview(lineView)
                
                //let button = UIButton(frame: CGRectMake(0, contentViewHeight + 1, contentViewWidth, 44))
                //button.backgroundColor = UIColor.whiteColor()
                //button.titleLabel?.font = UIFont.systemFontOfSize(18)
                //button.setTitle(buttonTitleArray[i] as? String, forState: UIControlState.Normal)
                //button.setTitleColor(Color_333, forState: UIControlState.Normal)
                //button.addTarget(self, action: #selector(MMActionSheet.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                //buttonArray.addObject(button)
                //buttonView.addSubview(button)
                //contentViewHeight = contentViewHeight + lineView.frame.height + button.frame.height
            //}
            
            //buttonView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight)
            //buttonView.layer.cornerRadius = 5.0
            //buttonView.layer.masksToBounds = true
            //contentView.addSubview(buttonView)
        //}
    //}
    
    //func initCancelButton() {
        //cancelButton = UIButton()
        //cancelButton.frame = CGRectMake(0, contentViewHeight + space, contentViewWidth, 44)
        //cancelButton.backgroundColor = UIColor.whiteColor()
        //cancelButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        //cancelButton.layer.cornerRadius = 5.0
        //cancelButton.setTitleColor(UIColor.colorWithHexCode("FF9501"), forState: UIControlState.Normal)
        //cancelButton.setTitle(_cancelButtonTitle, forState: UIControlState.Normal)
        //cancelButton.addTarget(self, action: #selector(MMActionSheet.cancelButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        //contentView.addSubview(cancelButton)
        //contentViewHeight =  contentViewHeight + cancelButton.frame.height + space * 2
    //}
    
    //func touchBackgroundButton() {
        //hide()
    //}
    
    //func cancelButtonAction() {
        //hide()
    //}
    
    //func buttonAction(sender: UIButton) {
        //for i in 0 ..< buttonArray.count {
            //if sender == buttonArray[i] as! NSObject {
                //_delegate?.actionSheet!(self, buttonIndex: i)
                //break
            //}
        //}
        //hide()
    //}
    
    //func show() {
        //let window = UIApplication.sharedApplication().windows
        //window[1].addSubview(self)
        //addAnimation()
    //}
    
    //func hide() {
        //removeAnimation()
    //}
    
    //func addAnimation() {
        //UIView.animateWithDuration(0.3) { () -> Void in
            //self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.frame.height)
        //}
    //}
    
    //func removeAnimation() {
        //UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                //self.contentView.transform = CGAffineTransformIdentity
            //}) { (finished) -> Void in
                //self.removeFromSuperview()
        //}
    //}
//}

//extension MMActionSheet {
    //func setTitle(title: String) {
        //_title = title
        //initContentView()
    //}
    
    //func setCancelButtonTitleColor(color: UIColor, backgroundColor: UIColor, size: CGFloat) {
        //cancelButton.setTitleColor(color, forState: UIControlState.Normal)
        //cancelButton.backgroundColor = backgroundColor
        //cancelButton.titleLabel?.font = UIFont.systemFontOfSize(size)
    //}
    
    //func setTitleColor(color: UIColor, backgroundColor: UIColor, size: CGFloat) {
        //titleLabel?.textColor = color
        //titleLabel?.backgroundColor = backgroundColor
        //titleLabel?.font = UIFont.systemFontOfSize(size)
    //}
    
    //func setButtonTitleColor(color: UIColor, backgroundColor: UIColor, size: CGFloat, index: Int) {
        //let button: UIButton = buttonArray[index] as! UIButton
        //button.setTitleColor(color, forState: UIControlState.Normal)
        //button.backgroundColor = backgroundColor
        //button.titleLabel?.font = UIFont.systemFontOfSize(size)
    //}
//}

