
import UIKit

class FormCellView: UIView {

    @IBInspectable
    var itemCount: Int!{
        didSet{
            for i in 0 ..< itemCount {
                self.addLineSpace(i * Int(40.Fit6()))
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        backgroundColor = UIColor.whiteColor()
        setWane(8)
        setBorder(Color_ccc, width: 0.5)
    }
    
    func addLineSpace(y:Int){
        let lineView = UILabel()
        lineView.backgroundColor = Color_line
        lineView.frame = CGRectMake(0, CGFloat(y), frame.width, 0.5)
        addSubview(lineView)
    }
}
