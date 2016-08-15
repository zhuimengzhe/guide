
import UIKit

class LoginViewController: BaseViewController {
    
    var telTextField: CustomTextField!
    var passwordTextField: CustomTextField!
    
    var submitButton: CustomButton!
    
    var goRegisterButton: BLineButton!
    var forgetButton: BLineButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initFormView()
    }
    
    //登录界面布局
    private func initFormView(){
        let x: CGFloat = 15.Fit6()//左右边距
        
        telTextField = CustomTextField()
        telTextField.frame = CGRectMake(x, 64+15.Fit6(), UIScreen.mainScreenWidth-x*2, 44)
        telTextField.iconLeft = UIImage(named: "icon_user")
        telTextField.placeholder = "手机号码".internationByKey("z_h")
        telTextField.delegate = self
        view.addSubview(telTextField)
        
        passwordTextField = CustomTextField()
        passwordTextField.frame = CGRectMake(x, telTextField.endY+15.Fit6(), UIScreen.mainScreenWidth-x*2, 44)
        passwordTextField.iconLeft = UIImage(named: "icon_word")
        passwordTextField.placeholder = "密码".internationByKey("m_m")
        passwordTextField.secureTextEntry = true
        passwordTextField.delegate = self
        view.addSubview(passwordTextField)
        
        submitButton = CustomButton()
        submitButton.frame = CGRectMake(x, passwordTextField.endY+20.Fit6(), UIScreen.mainScreenWidth - x*2, 48)
        submitButton.setTitle("登录".internationByKey("login"), forState: UIControlState.Normal)
        submitButton.addTarget(self, action: #selector(LoginViewController.didSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(submitButton)
        
        goRegisterButton = BLineButton()
        goRegisterButton.setTitle("免费注册".internationByKey("z_c"), forState: UIControlState.Normal)
        goRegisterButton.sizeToFit()
        goRegisterButton.frame.origin = CGPointMake(x, submitButton.endY+30.Fit6())
        goRegisterButton.addTarget(self, action: #selector(LoginViewController.didGoRegister), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(goRegisterButton)
        
        forgetButton = BLineButton()
        forgetButton.setTitle("忘记密码?".internationByKey("w_j_m_m"), forState: UIControlState.Normal)
        forgetButton.sizeToFit()
        forgetButton.frame.origin = CGPointMake(UIScreen.mainScreenWidth-x-forgetButton.frame.width, submitButton.endY+30.Fit6())
        forgetButton.addTarget(self, action: #selector(LoginViewController.didForget), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(forgetButton)
        
        //读取数据
        telTextField.text = UserInstance.getAccount()
        passwordTextField.text = UserInstance.getPassword()
    }
    
    //点击登录按钮...
    func didSubmit(){
        view.endEditing(true)
        
        if telTextField.isNull(){
            AlertInstance.showHud(KeyWindow,str:"手机号不能为空")
            return
        }
        
        if !telTextField.text!.Pattern(checkTelNumber){
            AlertInstance.showHud(KeyWindow,str:"手机号格式不正确")
            return
        }
        
        if passwordTextField.isNull(){
            AlertInstance.showHud(KeyWindow,str:"密码不能为空")
            return
        }
        
        let parameter = [
            "phone"   : telTextField.text!,
            "pwd"   : passwordTextField.text!.MD5
        ]
        
        AlertInstance.showHud(KeyWindow, str: "正在登录中...")
        HttpInstance.requestJSON(.POST, Http_login, parameters: parameter){
            [unowned self] object in
            UserInstance.saveAccount(self.telTextField.text!, password: self.passwordTextField.text!, login: true)
            UserInstance.setUserByDict(object)
            
            AlertInstance.showHud(KeyWindow, str:"登录成功")
            self.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
    }
    //前往注册界面
    func didGoRegister(){
        let to_vc = RegisterViewController()
        to_vc.state = 1
        to_vc.title = "注册".internationByKey("z_c")
        navigationController?.pushViewController(to_vc, animated: true)
    }
    //前往忘记密码界面
    func didForget(){
        let to_vc = RegisterViewController()
        to_vc.state = 2
        to_vc.title = "忘记密码".internationByKey("w_j_m_m")
        navigationController?.pushViewController(to_vc, animated: true)
    }
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if !telTextField.isNull() && !passwordTextField.isNull() {
            didSubmit()
        }
        return true
    }
}
