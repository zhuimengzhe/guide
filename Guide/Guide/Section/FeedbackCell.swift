
import UIKit

class FeedbackCell: UIView {
    
    @IBInspectable
    var bottomLine: Bool = false
    
    var titleLabel: UILabel = UILabel()
    
    var selectButton: UIButton = UIButton()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
        self.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel.textColor = Color_333
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(self.titleLabel)
        
        self.selectButton.setBackgroundImage(UIImage(named: "fxk"), forState: UIControlState.Normal)
        self.selectButton.setBackgroundImage(UIImage(named: "fxk_on"), forState: UIControlState.Selected)
        self.selectButton.addTarget(self, action: #selector(FeedbackCell.didSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.selectButton)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if bottomLine{
            let context = UIGraphicsGetCurrentContext()
            CGContextSetLineWidth(context, 1.0)
            CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9, 1.0)
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 0, rect.height-1)
            CGContextAddLineToPoint(context, rect.width, rect.height-1)
            CGContextStrokePath(context)
        }
        self.selectButton.frame = CGRectMake(rect.width-40, (rect.height-20)/2, 20, 20)
    }
    
    func didSelect(btn: UIButton){
        btn.selected = !btn.selected
    }
}
