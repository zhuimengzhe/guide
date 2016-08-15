import UIKit

class MenuButton: UIButton {
    
    var curTitle: String!{
        didSet{
            self.setTitle(curTitle, forState: UIControlState.Normal)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(Color_333, forState: UIControlState.Normal)
        backgroundColor = UIColor.whiteColor()
        setWane(4)
        
        setImage(UIImage.init(named: "xiala"), forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
}
