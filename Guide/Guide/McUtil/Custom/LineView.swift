
import UIKit

//分割线
class LineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLineStyle()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    private func initLineStyle(){
        self.backgroundColor = Color_line
    }
}
