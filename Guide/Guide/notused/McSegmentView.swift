
import UIKit
protocol McSegementViewDelegate{
    func selectedTitleItem(mcSegmentView: McSegmentView, itemTag: Int)
}

class McSegmentView: UIView {
    
    var delegate: McSegementViewDelegate?
    var curSelected = 0{
        didSet {
            curSelectedItem()
        }
    }
    var titleButtons = [UIButton](){
        didSet {
            updateTitleButtons()
        }
        
    }
    
    var titleColor = UIColor.colorWithHexCode("999999")
    var titleColorSelected = Color_topNav
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, titleButtons: [UIButton]) {
        self.init(frame: frame)
        self.titleButtons = titleButtons
        self.updateTitleButtons()
    }
    
    func updateTitleButtons(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
        
        let all = self.titleButtons.count
        let w = self.frame.width / CGFloat(max(all,1))
        for i in 0 ..< all{
            self.titleButtons[i].frame = CGRectMake(CGFloat(i)*w, 0, w, self.frame.height)
            self.titleButtons[i].setTitleColor(titleColor, forState: UIControlState.Normal)
            self.titleButtons[i].setTitleColor(titleColorSelected, forState: UIControlState.Selected)
            self.titleButtons[i].tag = i
            self.titleButtons[i].addTarget(self, action: #selector(McSegmentView.didTitleItem(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(self.titleButtons[i])
        }
    }
    
    func addSplitLine(){
        for i in 0 ..< self.titleButtons.count{
            if i != 0{
                let lineView = UIView(frame: CGRectMake(0.5, (self.frame.height-30)/2, 0.5, 30))
                lineView.backgroundColor = Color_line
                self.titleButtons[i].addSubview(lineView)
            }
        }
    }
    
    func didTitleItem(btn: UIButton){
        self.curSelected = btn.tag
        self.delegate?.selectedTitleItem(self, itemTag: btn.tag)
        if self.curLine != nil{
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.curLine.center.x = btn.center.x
            })
        }
    }
    
    var curLine: UIView!
    func addCurLine() {
        self.addBottomLine(Color_line)
        if curLine == nil{
            self.curLine = UIView()
            self.curLine.backgroundColor = titleColorSelected
            self.curLine.setFrameByCenter(CGRectMake(self.titleButtons[self.curSelected].center.x, self.frame.height-1, self.frame.width/CGFloat(self.titleButtons.count), 1))
            self.addSubview(self.curLine)
        }
    }
    
    private func curSelectedItem(){
        for i in 0 ..< self.titleButtons.count{
            self.titleButtons[i].selected = i == self.curSelected
        }
    }
}
