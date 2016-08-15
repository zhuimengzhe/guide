
import UIKit
protocol SwitchViewProtocol : class {
    func SwitchViewValuchanged(tag:Int,onOff:Bool)
}

class SwitchView: UIControl {
    var delegate:SwitchViewProtocol?
    var onLabel = UILabel()
    var offLabel = UILabel()
    var alertSwitch = UISwitch()
    var stag : Int {
        get {
            return alertSwitch.tag
        }
        set {
            alertSwitch.tag = newValue
        }
    }
    var on : Bool {
        set {
            alertSwitch.on = newValue
        }
        get {
            return alertSwitch.on
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        alertSwitch.setWane(16)
        alertSwitch.onImage = UIImage.init(named: "btn_open")
        alertSwitch.offImage = UIImage.init(named: "btn_close")
        alertSwitch.addTarget(self, action: #selector(SwitchView.didSwitch(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(alertSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ onText: String, offText: String){
        self.init(frame: CGRectZero)
        
        let offse:CGFloat = 3
        
        onLabel.textStyle2(onText)
        offLabel.textStyle2(offText)
        
        addSubview(onLabel)
        addSubview(offLabel)
        
        onLabel.sizeToFit()
        offLabel.sizeToFit()
        let HalfSwifthHeight = alertSwitch.bounds.height / 2
        let w = onLabel.frame.width + offLabel.frame.width + alertSwitch.bounds.width + offse * 2
        
        alertSwitch.center.x = w / 2
        
        onLabel.center = CGPointMake(onLabel.bounds.width / 2 - offse, HalfSwifthHeight)
        offLabel.center = CGPointMake(w - offLabel.frame.width / 2  + offse, HalfSwifthHeight)
        
        bounds = CGRectMake(0, 0, w, HalfSwifthHeight * 2)
    }
    
    
    func didSwitch(sender:UISwitch){
        if delegate != nil {
            delegate?.SwitchViewValuchanged(sender.tag,onOff:alertSwitch.on)
        }
    }
}
