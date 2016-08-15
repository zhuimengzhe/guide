
import UIKit

class CellButton: UIButton {
    @IBInspectable
    var bottomLine: Bool = false
    
    @IBInspectable
    var moreImage: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(Color_333, forState: UIControlState.Normal)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        self.titleLabel?.font = UIFont.systemFontOfSize(14)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if bottomLine {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetLineWidth(context, 0.7)
            CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1.0)
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 0, rect.height - 1)
            CGContextAddLineToPoint(context, rect.width, rect.height - 1)
            CGContextStrokePath(context)
        }
        if moreImage != nil{
            self.addMoreImg()
        }
    }
    
    func addMoreImg(){
        let imgView = UIImageView()
        imgView.image = UIImage(named: "more")
        imgView.frame = CGRectMake(frame.width - 18, (frame.height - 11) / 2, 7, 11)
        self.addSubview(imgView)
    }
}
