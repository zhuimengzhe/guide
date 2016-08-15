
import UIKit

class RegisterViewController: BaseViewController {
    
    //1 注册  2 找回密码
    var state:Int = 1
    
    var telTextField: CustomTextField!
    var codeTextField: CustomTextField!
    
    var submitButton: CustomButton!
    var getCodeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initFormView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getCodeButton.enabled = true
        self.getCodeButton.setTitleColor(Color_topNav, forState: UIControlState.Normal)
    }
    //注册界面布局
    private func initFormView(){
        let x: CGFloat = 15.Fit6()//左右边距
        telTextField = CustomTextField()
        telTextField.frame = CGRectMake(x, 64+15.Fit6(), ScreenWidth-x*2, 44)
        telTextField.iconLeft = UIImage(named: "icon_user")
        telTextField.placeholder = "手机号码".internationByKey("photo_num")
        telTextField.delegate = self
        view.addSubview(telTextField)
        
        codeTextField = CustomTextField()
        codeTextField.delegate = self
        codeTextField.frame = CGRectMake(x, telTextField.endY+15.Fit6(), (ScreenWidth-x*2)/2, 44)
        codeTextField.placeholder = "请输入验证码".internationByKey("y_z_m")
        
        view.addSubview(codeTextField)
        
        getCodeButton = UIButton()
        getCodeButton.frame = CGRectMake(codeTextField.endX+5, telTextField.endY+15.Fit6(), (ScreenWidth-x*2)/2-5, 44)
        getCodeButton.setWane(6)
        getCodeButton.backgroundColor = UIColor.whiteColor()
        getCodeButton.setBorder(Color_topNav, width: 0.5)
        getCodeButton.setTitleColor(Color_topNav, forState: UIControlState.Normal)
        getCodeButton.setTitle("免费获取验证码".internationByKey("m_f_y_z_m"), forState: UIControlState.Normal)
        getCodeButton.addTarget(self, action: #selector(RegisterViewController.didGetCode), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(getCodeButton)
        
        submitButton = CustomButton()
        submitButton.frame = CGRectMake(x, codeTextField.endY+20.Fit6(),ScreenWidth - x * 2, 48)
        submitButton.setTitle("下一步".internationByKey("next"), forState: UIControlState.Normal)
        submitButton.addTarget(self, action: #selector(RegisterViewController.didSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(submitButton)
    }
    
    //点击下一步
    func didSubmit(){
        
        let parameter = [
            "phone"   : telTextField.text!,
            "code"    : codeTextField.text!,
            "state" : String(state)
        ]
        HttpInstance.requestJSON(.POST, Http_validate, parameters: parameter){
            [unowned self]  object in
            AlertInstance.showHud(KeyWindow, str: object["message"] as! String)
            let to_vc = PasswordViewController()
            to_vc.state = self.state - 1
            to_vc.tel = self.telTextField.text
            self.navigationController?.pushViewController(to_vc, animated: true)
        }
    }
    
    //获取验证码
    func didGetCode(){
        if telTextField.isNull(){
            AlertInstance.showHud(KeyWindow, str:"请先输入手机号")
            return
        }
        
        if !telTextField.text!.Pattern(checkTelNumber){
            AlertInstance.showHud(KeyWindow, str:"手机号格式不正确")
            return
        }
        
        let parameter = [
            "phone"   : telTextField.text!
        ]
        HttpInstance.requestJSON(.POST, Http_sendsms, parameters: parameter){
            [unowned self] obj in
            self.getCodeButton.enabled = false
            self.getCodeButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            AlertInstance.showHud(KeyWindow, str: obj["message"] as! String)
        }
    }
}

extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if !telTextField.isNull() && !codeTextField.isNull() {
            didSubmit()
        }
        return true
    }
}