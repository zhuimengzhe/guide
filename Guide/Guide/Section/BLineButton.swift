
import UIKit

class BLineButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
        self.setTitleColor(Color_222, forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0)
        CGContextSetRGBStrokeColor(context, 0.2, 0.2, 0.2, 1.0)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, rect.height-8)
        CGContextAddLineToPoint(context, rect.width, rect.height-8)
        CGContextStrokePath(context)
    }
}
