
import Foundation
import UIKit
//// MARK: UILabel extension
extension UILabel{
    func initAutoHeight(rect:CGRect,textColor:UIColor, fontSize:CGFloat, text:NSString, lineSpacing:CGFloat){//自适应高度
        self.frame = rect
        self.textColor = textColor
        self.font = UIFont.systemFontOfSize(fontSize)
        self.numberOfLines = 0
        let attributedString = NSMutableAttributedString(string: text as String)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
        self.attributedText = attributedString
        self.sizeToFit()
        self.frame.size.width = rect.width
        self.frame.size.height = max(self.frame.size.height, rect.height)
    }
    
    func autoHeight(rect:CGRect, lineSpacing:CGFloat){
        self.frame = rect
        if self.text != nil{
            self.numberOfLines = 0
            let attributedString = NSMutableAttributedString(string: self.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            
            let str: NSString = self.text!
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, str.length))
            self.attributedText = attributedString
            self.sizeToFit()
            self.frame.size.width = rect.width
            self.frame.size.height = max(self.frame.size.height, rect.height)
        }
    }
    
    func autoHeightBySpace(lineSpacing:CGFloat){
        self.autoHeight(self.frame, lineSpacing: lineSpacing)
    }
    
    func setForTitleByFont(s: CGFloat){
        self.textColor = UIColor.whiteColor()
        self.textAlignment = NSTextAlignment.Center
        self.font = UIFont.systemFontOfSize(s)
    }
    
    func sizeFitHeight(){
        let w = self.frame.width
        self.sizeToFit()
        self.frame.size.width = w
    }
    
    func sizeFitWidth(){
        let h = self.frame.height
        self.sizeToFit()
        self.frame.size.height = h
    }
    
    func sizeFitByText(text: String)->Self{
        self.text = text
        self.sizeToFit()
        return self
    }
    
    func addTextByColor(texts: [MutableTextColor]){
        var curStr = ""
        for text in texts{
            curStr += text.text
        }
        
        let countStr = NSMutableAttributedString(string: curStr)
        for text in texts{
            if (curStr as NSString).rangeOfString(text.text).location != NSNotFound{
                countStr.addAttribute(NSForegroundColorAttributeName, value: text.color, range: (curStr as NSString).rangeOfString(text.text))
            }
        }
        self.attributedText = countStr
    }
}

//多种颜色的label
struct MutableTextColor{
    var text: String!
    var color: UIColor!
    init(text: String, color: UIColor){
        self.text = text
        self.color = color
    }
}
// MARK: UIView extension
extension UIView{
    
    func setWane(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorder(color: UIColor, width: CGFloat){
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = width
    }
    
    func setFrameByCenter(rect: CGRect){
        self.bounds = CGRectMake(0, 0, rect.width, rect.height)
        self.center.x = rect.origin.x
        self.center.y = rect.origin.y
    }
    
    var centerX: CGFloat{
        return self.bounds.width / 2
    }
    
    var centerY: CGFloat{
        return self.bounds.height / 2
    }
    var centerFrameX: CGFloat {
        return CGRectGetMidX(self.frame)
    }
    var centerFrameY: CGFloat {
        return CGRectGetMidY(self.frame)
    }
    
    var centerP: CGPoint{
        return CGPointMake(self.centerX, self.centerY)
    }
    
    var originX: CGFloat{
        return self.frame.origin.x
    }
    var frameWidth : CGFloat {
        return frame.size.width
    }
    var frameHeight :CGFloat {
        return frame.size.height
    }
    var boundsWidth : CGFloat {
        return self.bounds.size.width
    }
    var boundsHeight : CGFloat {
        return self.bounds.size.height
    }
    
    var originY: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y += CGFloat(newValue)
        }
    }
    
    var endX: CGFloat{
        return self.frame.size.width + self.frame.origin.x
    }
    
    var endY: CGFloat{
        return self.frame.size.height + self.frame.origin.y
    }
    
    var marginWidth: CGFloat{
        return 10
    }
    
    func addBottomLine(color: UIColor){
        let lineView = UIView()
        lineView.frame = CGRectMake(0, self.frame.size.height-0.5, UIScreen.mainScreenWidth, 0.5)
        lineView.backgroundColor = color
        self.addSubview(lineView)
    }
    
    func drawCircle(){
        let corner = boundsWidth / 2
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: corner,height: corner))
        shapeLayer.path = path.CGPath;
        layer.mask = shapeLayer;
    }
}

// MARK: UIScreen Extension
extension UIScreen {
    class var mainScreenWidth: CGFloat {//主屏幕宽度
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class var mainScreenHeight: CGFloat {//主屏幕高度
        return UIScreen.mainScreen().bounds.size.height
    }
    
    class var mainScreenBounds: CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    class var mainScreenScale: CGFloat {
        return UIScreen.mainScreen().scale
    }
}
// MARK: UIView Extension Animation
extension UIView{//各种动画效果
    func scaleMyView(){
        let newTransform: CGAffineTransform = CGAffineTransformScale(self.transform, 0.1, 0.1)
        self.transform = newTransform
        self.alpha = 0
    }
    
    func scaleBigAnimation(){
        self.scaleBigWithTime(0.35) { () -> Void in
            self.transform = CGAffineTransformIdentity
        }
    }
    
    func scaleBigWithTime(time: NSTimeInterval, handle: ()->Void){
        UIView.animateWithDuration(time, animations: { () -> Void in
            let newTransform: CGAffineTransform = CGAffineTransformConcat(self.transform, CGAffineTransformInvert(self.transform))
            self.transform = newTransform
            self.alpha = 1
        }) {
            (f:Bool) -> Void in
            handle()
        }
    }
    
    func scaleSmallWithTime(time: NSTimeInterval, handle: ()->Void){
        UIView.animateWithDuration(time, animations: { [unowned self] () -> Void in
            let newTransform: CGAffineTransform = CGAffineTransformScale(self.transform, 0.1, 0.1)
            self.transform = newTransform
            self.alpha = 0
            //self.scaleMyView()
        }) {
            (f:Bool) -> Void in
            if f{
                handle()
            }
        }
    }
    
    func scaleSmallAnimation(){
        self.scaleSmallWithTime(0.35) { () -> Void in
            self.removeFromSuperview()
        }
    }
    
    //Mark: 抖动效果
    func shakeAnimation(){
        UIView.animateKeyframesWithDuration(0.1, delay: 0, options: [.Repeat,.Autoreverse,.AllowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransformMakeRotation(0.05)
            }, completion: { (f) -> Void in
        })
    }
    
    func stopShakeAnimation(){
        self.transform = CGAffineTransformIdentity
        self.shakeAnimation()
        self.transform = CGAffineTransformIdentity
    }
}
// MARK: UIColor extension
extension UIColor{
    class func colorWithHexCode(code : String) -> UIColor {
        let colorComponent = {(startIndex : Int ,length : Int) -> CGFloat in
            var subHex = code.substringWithRange(code.startIndex.advancedBy(startIndex)..<code.startIndex.advancedBy(startIndex + length))
            subHex = subHex.characters.count < 2 ? "\(subHex)\(subHex)" : subHex
            var component:UInt32 = 0
            NSScanner(string: subHex).scanHexInt(&component)
            return CGFloat(component) / 255.0}
        
        let argb = {() -> (CGFloat,CGFloat,CGFloat,CGFloat) in
            switch(code.characters.count) {
            case 3: //#RGB
                let red = colorComponent(0,1)
                let green = colorComponent(1,1)
                let blue = colorComponent(2,1)
                return (red,green,blue,1.0)
            case 4: //#ARGB
                let alpha = colorComponent(0,1)
                let red = colorComponent(1,1)
                let green = colorComponent(2,1)
                let blue = colorComponent(3,1)
                return (red,green,blue,alpha)
            case 6: //#RRGGBB
                let red = colorComponent(0,2)
                let green = colorComponent(2,2)
                let blue = colorComponent(4,2)
                return (red,green,blue,1.0)
            case 8: //#AARRGGBB
                let alpha = colorComponent(0,2)
                let red = colorComponent(2,2)
                let green = colorComponent(4,2)
                let blue = colorComponent(6,2)
                return (red,green,blue,alpha)
            default:
                return (1.0,1.0,1.0,1.0)
            }}
        
        let color = argb()
        return UIColor(red: color.0, green: color.1, blue: color.2, alpha: color.3)
    }
    
    func getImageByRect(rect:CGRect) -> UIImage{//获取一张纯色的图片
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
// MARK: UIButton extension
extension UIButton{
    class func zk_swizzleSendAction(){
        //单例
        struct zk_swizzleToken{
            static var onceToken:dispatch_once_t = 0
        }
        
        dispatch_once(&zk_swizzleToken.onceToken){
            let cls:AnyClass! = UIButton.self
            
            let originalSelector = #selector(self.sendAction(_:to:forEvent:))
            let swizzleSelector = #selector(self.zk_sendAction(_:to:forEvent:))
            
            let originalMethod = class_getInstanceMethod(cls, originalSelector)
            let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
            
            //把他们的方法调换
            method_exchangeImplementations(originalMethod, swizzleMethod)
        }
    }
    
    public func zk_sendAction(action:Selector,to:AnyObject!,forEvent:UIEvent!)
    {
        struct zk_buttonTapCounter{
            static var count:Int = 0
        }
        zk_buttonTapCounter.count += 1
        //会依次使用对象的Streamble Printable debugPrintable三个接口查找有没有实现的方法,如果有实现的话,就直接调用,如果没有实现的方法的话,就先找Streamble,再找Printable再找debugPrintable接口定义的方法
        print(zk_buttonTapCounter.count)
        zk_sendAction(action,to:to,forEvent:forEvent)
    }
    var normalColor:UIColor{
        return UIColor.whiteColor()
    }
    var highlightColor:UIColor{
        return UIColor.colorWithHexCode("fefdfc")
    }
    func setTapHighlight(){
        self.addTarget(self, action: #selector(UIButton.changeColor(_:)), forControlEvents: UIControlEvents.TouchDown)
    }
    func changeColor(btn:UIButton){
        btn.backgroundColor = highlightColor
        btn.addTarget(self, action: #selector(UIButton.reviewColor(_:)), forControlEvents: UIControlEvents.TouchCancel)
        btn.addTarget(self, action: #selector(UIButton.reviewColor(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btn.addTarget(self, action: #selector(UIButton.reviewColor(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
    }
    func reviewColor(btn:UIButton){
        UIView.animateWithDuration(0.2, animations: {
            btn.alpha = 0.9
        }) { (successed) -> Void in
            btn.alpha = 1.0
            btn.backgroundColor = self.normalColor
        }
    }
    //上面图片 下面label
    func verticalImageAndTitle(spacing:CGFloat = 0) {
        
        guard imageView != nil else{
            AlertInstance.showHud(KeyWindow, str: "button需要已经设置图片")
            return
        }
        
        guard titleLabel != nil else {
            AlertInstance.showHud(KeyWindow, str: "button需要应设置title")
            return
        }
        
        let imageWidth = imageView!.frameWidth
        let imageHeight =  imageView!.frameHeight
        
        let titleHeight = titleLabel!.frameHeight
        let titleWidth = titleLabel!.frameWidth
        
        let totalHeight = imageHeight + titleHeight + spacing
        
        imageEdgeInsets = UIEdgeInsetsMake(imageHeight - totalHeight, 0.0, 0.0,0 - titleWidth)
        titleEdgeInsets = UIEdgeInsetsMake(0,0 - imageWidth,titleHeight - totalHeight, 0.0)
    }
    //上面title 下面 image
    func verticalTitleAndImage(spacing:CGFloat = 0) {
        
        guard imageView != nil else{
            AlertInstance.showHud(KeyWindow, str: "button需要已经设置图片")
            return
        }
        guard titleLabel != nil else {
            AlertInstance.showHud(KeyWindow, str: "button需要应设置title")
            return
        }
        let imageWidth = imageView!.frameWidth
        let imageHeight =  imageView!.frameHeight
        
        let titleHeight = titleLabel!.frameHeight
        let titleWidth = titleLabel!.frameWidth
        
        let totalHeight = imageHeight + titleHeight + spacing
        
        imageEdgeInsets = UIEdgeInsetsMake(0,0,imageHeight - totalHeight,0 - titleWidth)
        titleEdgeInsets = UIEdgeInsetsMake(titleHeight - totalHeight,0 - imageWidth, 0.0, 0.0)
    }
    //左边label 右边 image
    func horizontalLabelAndImage(spacing:CGFloat = 0) {
        guard imageView != nil else{
            AlertInstance.showHud(KeyWindow, str: "button需要已经设置图片")
            return
        }
        guard titleLabel != nil else {
            AlertInstance.showHud(KeyWindow, str: "button需要应设置title")
            return
        }
        
        let imageWidth = imageView!.frameWidth
        let titleWidth = titleLabel!.frameWidth
        
        imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + spacing / 2, 0,-(titleWidth + spacing / 2))
        titleEdgeInsets = UIEdgeInsetsMake(0,-(imageWidth + spacing / 2),0, imageWidth + spacing / 2)
        
    }
    func horizontalImageAndLabel(spacing:CGFloat = 0) {
        guard imageView != nil else{
            AlertInstance.showHud(KeyWindow, str: "button需要已经设置图片")
            return
        }
        guard titleLabel != nil else {
            AlertInstance.showHud(KeyWindow, str: "button需要应设置title")
            return
        }
        
        imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0,0)
        titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -spacing / 2)
    }
}
// MARK: UITextField extension
extension UITextField{
    func addLeftIcon(img: UIImage?){
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, self.frame.height, self.frame.height)
        let imgView = UIImageView(frame: CGRectMake(12, 12, self.frame.height - 24, self.frame.height - 24))
        imgView.image = img
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func addLeftIcon(img: UIImage?,paddingLeft: CGFloat = 0,paddingRight: CGFloat = 0, imgSize: CGSize){
        
        let imgView = UIImageView()
        imgView.frame = CGRectMake(paddingLeft, (frame.height - imgSize.height)/2, imgSize.width, imgSize.height)
        
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, imgView.endX+paddingRight, frame.height)
        imgView.image = img
        leftView.addSubview(imgView)
        
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func addLeftIcon(img: UIImage?, frame: CGRect, imgSize: CGSize){
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.bounds = CGRectMake(0, 0, imgSize.width, imgSize.height)
        imgView.center = leftView.center
        imgView.image = img
        leftView.addSubview(imgView)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func addLeftBlank(w: CGFloat){
        let leftView = UILabel()
        leftView.frame = CGRectMake(0, 0, w, self.frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func addRightBlank(w: CGFloat){
        let rightView = UIView()
        rightView.frame = CGRectMake(0, 0, w, self.frame.height)
        self.rightView = rightView
        self.rightViewMode = UITextFieldViewMode.Always
    }
    
    //当前输入框是否为空
    func isNull()->Bool{
        return self.text == nil || self.text == ""
    }
}

// MARK: UIScrollView exntension
extension UIScrollView{
    func addLoadView(){
        
    }
}

extension UITableViewCell{
    
}

extension UIImage{
    func scaleByPercent(percent:CGFloat)->UIImage{
        let w = self.size.width*percent
        let h = self.size.height*percent
        return self.scaleFromImage(CGSizeMake(w, h))
    }
    func scaleFromImage(size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func subByWh(wh: CGFloat)->UIImage!{
        let oWh = self.size.width/self.size.height
        
        var w: CGFloat!
        var h: CGFloat!
        var x: CGFloat = 0
        var y: CGFloat = 0
        if wh >= oWh{
            w = self.size.width
            h = w / wh
            y = (self.size.height - h)/2
        }else{
            h = self.size.height
            w = h * wh
            x = (self.size.width - w)/2
        }
        return self.subImage(CGRectMake(x, y, w, h))
    }
    
    func subImage(rect: CGRect)->UIImage!{
        let subImageRef: CGImageRef = CGImageCreateWithImageInRect(self.CGImage, rect)!
        let smallBounds = CGRect(x: 0, y: 0, width: CGImageGetWidth(subImageRef), height: CGImageGetHeight(subImageRef))
        
        UIGraphicsBeginImageContext(smallBounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextDrawImage(context, smallBounds, subImageRef)
        let smallImage = UIImage(CGImage: subImageRef)
        UIGraphicsEndImageContext()
        return smallImage
    }
    
}

extension UIViewController{
    //push并隐藏tabBar
    func pushHideBottomBar(to_vc: UIViewController, animated: Bool){
        to_vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(to_vc, animated: animated)
    }
    //显示message的alertviewcontroller
    public func showErrorAlertWithMessage(message:String,title:String?,withStyle style:UIAlertControllerStyle){
        let alert = UIAlertController(title:title,message:message,preferredStyle:.Alert)
        self.presentViewController(alert, animated: true) { () -> Void in
            print("错误提示 已显示")
        }
    }
}

public extension CAShapeLayer {
    public override class func opaqueLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.opaque = true
        return layer
    }
}

public extension CALayer {
    public class func opaqueLayer() -> CALayer {
        let layer = CALayer()
        layer.opaque = true
        return layer
    }
}




