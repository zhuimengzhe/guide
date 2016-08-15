import UIKit

class CustomTextField: UITextField {
    private var icon: UIImage!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
        self.backgroundColor = UIColor.whiteColor()
        self.setWane(6)
        self.setBorder(Color_ccc, width: 0.7)
    }
    
    @IBInspectable
    var iconLeft: UIImage! {
        get { return icon}
        set { icon = newValue }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if self.iconLeft != nil{
            addLeftIcon(icon, paddingLeft: 10, paddingRight: 5,imgSize: CGSizeMake(24, 24))
        }else{
            self.addLeftBlank(5)
        }
    }
}
