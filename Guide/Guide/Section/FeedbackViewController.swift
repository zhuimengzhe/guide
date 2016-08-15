
import UIKit

class FeedbackViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "使用反馈".internationByKey("s_y_f_k")
        initRightButton()
        initFormView()
        initFormCell()
    }
    
    func initRightButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交".internationByKey("t_j"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(FeedbackViewController.didRightButton))
    }
    
    func didRightButton(){
        
        var msg = ""
        for i in 0 ..< feedBtns.count{
            if feedBtns[i].selectButton.selected{
                msg += dataSource[i]+","
            }
        }
        
        if msg == "" && otherTextView.text == "" && telTextField.isNull(){
            AlertInstance.showHud(KeyWindow, str: "提交内容".internationByKey("t_j_n_r"))
            return
        }
        
        
        let parameter = [
            "uid"   : UserInstance.user.id,
            "msg"   : msg,
            "msg2" : otherTextView.text ?? "",
            "linkme" : telTextField.text ?? ""
        ]
        print("反馈\(parameter)")
        HttpInstance.requestJSON(.POST, Http_userfeedback, parameters: parameter){
            [unowned self]  obj in
            AlertInstance.showHud(KeyWindow,str:"完成".internationByKey("w_c"))
            self.otherTextView.text = ""
            self.telTextField.text = ""
        }
    }
    
    var scrollView: UIScrollView!
    private func initFormView(){
        scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    let cellH: CGFloat = 48.Fit6()
    let cellW: CGFloat = ScreenWidth - 20
    let dataSource = [
        "景区资料下载慢".internationByKey("j_q_x_z_m"),
        "景区资料下载总失败".internationByKey("j_1_x_z_s_b"),
        "下载景区无法使用".internationByKey("x_z_j_q_w_f_S_y"),
        "景区数量少".internationByKey("j_q_s_l_s"),
        "定位不准确".internationByKey("d_w_b_z_q"),
        "景区内容少，找不到想要的".internationByKey("n_r_s_m_x_y"),
        "占内存手机开机变慢".internationByKey("z_n_c_k_j_m"),
        "不稳定容易闪退".internationByKey("r_y_s_t"),
        "讲解不准确".internationByKey("j_j_b_z_q")
    ]
    
    var feedbackLabel = UILabel()
    let formCell = FormCellView()
    
    var otherTextView: CustomTextView!
    var telTextField: UITextField!
    
    var feedBtns = [FeedbackCell]()
    private func initFormCell(){
        feedbackLabel.frame = CGRectMake(10, 0, cellW, 50)
        feedbackLabel.text = "欢迎您对软件功能和服务提供宝贵的建议".internationByKey("x_y_t_y_j")
        feedbackLabel.textAlignment = NSTextAlignment.Center
        feedbackLabel.textColor = UIColor.lightGrayColor()
        scrollView.addSubview(feedbackLabel)
        
        let formY: CGFloat = feedbackLabel.endY
        
        formCell.frame = CGRectMake(10, formY, cellW, cellH*CGFloat(dataSource.count))
        scrollView.addSubview(formCell)
        
        for i in 0 ..< dataSource.count{
            let btn = FeedbackCell()
            btn.tag = i
            btn.frame = CGRectMake(0, cellH*CGFloat(i), cellW, cellH)
            btn.bottomLine = i != dataSource.count-1
            
            btn.titleLabel.frame = CGRectMake(10, 0, cellW - 80, cellH)
            btn.titleLabel.text = dataSource[i]
            formCell.addSubview(btn)
            
            feedBtns.append(btn)
        }
        
        otherTextView = CustomTextView()
        otherTextView.setWane(6)
        otherTextView.placeholder = "请输入其他原因".internationByKey("s_r_q_t_y_y")
        otherTextView.frame = CGRectMake(10, formCell.endY+10, cellW, 120)
        otherTextView.setBorder(Color_ccc, width: 0.5)
        scrollView.addSubview(otherTextView)
        
        telTextField = UITextField()
        telTextField.backgroundColor = UIColor.whiteColor()
        telTextField.setWane(6)
        telTextField.addLeftBlank(5)
        telTextField.placeholder = "请留下您的联系方式".internationByKey("l_x_l_x_f_s")
        telTextField.setBorder(Color_ccc, width: 0.5)
        telTextField.frame = CGRectMake(10, otherTextView.endY+10, cellW, cellH)
        scrollView.addSubview(telTextField)
        
        scrollView.contentSize.height = telTextField.endY+10
    }
}
