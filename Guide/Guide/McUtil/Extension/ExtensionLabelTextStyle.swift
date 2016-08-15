
import UIKit
//UILabel text的样式封装(RGB-font-Aligment)
extension UILabel{
    //333-16
    func textStyle1(text: String! = nil){
        self.textColor = Color_333
        self.font = UIFont.systemFontOfSize(16)
        if text != nil{
            self.text = text
        }
    }
    
    //333-14
    func textStyle2(text: String! = nil){
        self.textColor = Color_333
        self.font = UIFont.systemFontOfSize(14)
        if text != nil{
            self.text = text
        }
    }
    
    //333-15
    func textStyle3(text: String! = nil){
        self.textColor = Color_333
        self.font = UIFont.systemFontOfSize(15)
        if text != nil{
            self.text = text
        }
    }
    
    //999-16
    func textStyle4(text: String! = nil){
        self.textColor = Color_999
        self.font = UIFont.systemFontOfSize(16)
        if text != nil{
            self.text = text
        }
    }
    
    //999-14
    func textStyle5(text: String! = nil){
        self.textColor = Color_999
        self.font = UIFont.systemFontOfSize(14)
        if text != nil{
            self.text = text
        }
    }
    
    //999-15
    func textStyle6(text: String! = nil){
        self.textColor = Color_999
        self.font = UIFont.systemFontOfSize(15)
        if text != nil{
            self.text = text
        }
    }

    //白色背景...
    func whiteBgTextStyle1(text: String! = nil){
        self.textStyle1(text)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func whiteBgTextStyle2(text: String! = nil){
        self.textStyle2(text)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func whiteBgTextStyle3(text: String! = nil){
        self.textStyle3(text)
        self.backgroundColor = UIColor.whiteColor()
    }
}
