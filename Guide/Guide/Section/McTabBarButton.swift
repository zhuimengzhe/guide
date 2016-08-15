
import UIKit

class McTabBarButton: UIButton {
    
    var footImgView: UIImageView!
    var footLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        footImgView = UIImageView()
        addSubview(footImgView)
        
        footLabel = UILabel()
        footLabel.textColor = Color_333
        footLabel.textAlignment = NSTextAlignment.Center
        footLabel.font = UIFont.systemFontOfSize(14.Fit6())
        addSubview(footLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: CGRectZero)
    }
    
    convenience init(title: String, img: UIImage!, tag: Int){
        self.init()
        footLabel.text = title
        footImgView.image = img
    }
    
    func setContentFrame(){
        footImgView.frame = CGRectMake((frame.width - 30) / 2, 5, 30, 30)
        footLabel.frame = CGRectMake(2, 40, frame.width - 4, 20)
    }
}
