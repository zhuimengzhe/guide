
import UIKit

protocol McTabBarViewDelegate{
    func didTabBarByTag(mcTabBarView: McTabBarView, tag: Int)
}

class McTabBarView: UIView {
    
    var delegate: McTabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    var btns: [McTabBarButton]!
    func setTabButton(btns: [McTabBarButton]){
        self.btns = btns
        
        let w = frame.width / CGFloat(btns.count)
        for i in 0 ..< btns.count{
            btns[i].tag = i
            btns[i].frame = CGRectMake(CGFloat(i) * w, 0, w, self.frame.height)
            btns[i].setContentFrame()
            btns[i].addTarget(self, action: #selector(McTabBarView.didButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(btns[i])
        }
    }
    
    func didButton(btn: McTabBarButton){
        self.delegate?.didTabBarByTag(self, tag: btn.tag)
    }
}
