
import UIKit

class CustomScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSvProperty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    private func initSvProperty(){
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
    }
}
