
import UIKit

class McKeyboardPicker: UIControl , UIPickerViewDataSource, UIPickerViewDelegate{
    static let sharedInstance = McKeyboardPicker()
    
    var picker: UIPickerView!
    var pickStrs = [String]()
    var curStr = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(){
        self.init(frame: CGRectMake(0, 0, UIScreen.mainScreenWidth, 210.Fit6()))
    }
    
    convenience init(pickStrs: [String]){
        self.init(frame: CGRectMake(0, 0, UIScreen.mainScreenWidth, 210.Fit6()))
        self.pickStrs = pickStrs
        self.picker.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initBackView(){
        self.backgroundColor = UIColor.whiteColor()
        
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.addSubview(self.picker)
    }
    
    func showByStrs(strs: [String]){
        self.pickStrs = strs
        self.picker.reloadAllComponents()
    }

    //pickView delegate...
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.pickStrs.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView{
        let lab = UILabel()
        lab.frame = CGRectMake(0, 0, pickerView.frame.width, 30)
        lab.textAlignment = NSTextAlignment.Center
        lab.text = self.pickStrs[row]
        lab.font = UIFont.systemFontOfSize(16)
        return lab
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.curStr = self.pickStrs[row]
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
}
