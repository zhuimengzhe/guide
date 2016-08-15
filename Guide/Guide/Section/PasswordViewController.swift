
import UIKit

class PasswordViewController: BaseViewController {
    var state = 0
    var tel: String!
    var pwdTextField: CustomTextField!
    var repwdTextField: CustomTextField!
    let urls = [Http_register,Http_userfindpwd]
    var submitButton: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置密码".internationByKey("set_password")
        initFormView()
    }
    
    //注册界面布局
    private func initFormView(){
        let x: CGFloat = 15.Fit6()//左右边距
        pwdTextField = CustomTextField()
        pwdTextField.frame = CGRectMake(x, 64+15.Fit6(), ScreenWidth-x*2, 44)
        pwdTextField.iconLeft = UIImage(named: "icon_word")
        pwdTextField.placeholder = "输入密码"
        pwdTextField.delegate = self
        view.addSubview(pwdTextField)
        
        
        repwdTextField = CustomTextField()
        repwdTextField.frame = CGRectMake(x, pwdTextField.endY + 15.Fit6(), ScreenWidth-x*2, 44)
        repwdTextField.iconLeft = UIImage(named: "icon_word")
        repwdTextField.placeholder = "重复输入密码"
        repwdTextField.delegate = self
        view.addSubview(repwdTextField)
        
        
        submitButton = CustomButton()
        submitButton.frame = CGRectMake(x, repwdTextField.endY+20.Fit6(), ScreenWidth-x*2, 48)
        submitButton.setTitle("完成", forState: UIControlState.Normal)
        submitButton.addTarget(self, action: #selector(PasswordViewController.didSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(submitButton)
    }
    
    //点击下一步
    func didSubmit(){
        if pwdTextField.isNull() || repwdTextField.isNull(){
            AlertInstance.showHud(KeyWindow, str:"账号密码不能为空".internationByKey("z_h_m_m_b_n_w_k"))
            return
        }
        
        if pwdTextField.text != repwdTextField.text {
            AlertInstance.showHud(KeyWindow, str:"两次密码不一致")
            return
        }
        
        let parameter = [
            "phone"   : tel!,
            "pwd"    : pwdTextField.text!.MD5
        ]
        
        HttpInstance.requestJSON(.POST,urls[state],parameters: parameter){
            res in
            AlertInstance.showHud(KeyWindow, str: res["message"] as! String)
        }
    }
}
extension PasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if !pwdTextField.isNull() && !repwdTextField.isNull() {
            didSubmit()
        }
        return true
    }
}
