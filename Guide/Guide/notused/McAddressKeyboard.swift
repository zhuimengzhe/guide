//
//import UIKit
//
//class McAddressKeyboard: UIControl, UIPickerViewDataSource, UIPickerViewDelegate {
//    var selectPicker = UIPickerView()
//    var address = ""
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.initBackView()
//    }
//    
//    convenience init(){
//        self.init(frame: CGRectMake(0, 0, UIScreen.mainScreenWidth, 210.Sh(100)))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func initBackView(){
//        self.backgroundColor = UIColor.whiteColor()
////        self.strArr = AddressManagerInstance.addressArray()
////        self.address = "北京"
//        self.selectPicker.delegate = self
//        self.selectPicker.frame = self.bounds
//        self.addSubview(self.selectPicker)
//
//    }
//
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
//        return 3
//    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//        if component == 0{
//            return AddressManagerInstance.addressArray().count
//        }else if component == 1{
//            return AddressManagerInstance.getCArrayByIndex(curp).count
//        }else if component == 2{
//            return AddressManagerInstance.getAArrayByIndex(curp, j: curc).count
//        }
//        return 0
//    }
//    
//    var curp = 0
//    var curc = 0
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView{
//        var str = String()
//        
//        if component == 0{
//            str = (AddressManagerInstance.addressArray()[row] as! NSDictionary)["p"] as! String
//        }else if component == 1{
//            str = (AddressManagerInstance.getCArrayByIndex(curp)[row] as! NSDictionary)["n"] as! String
//        }else if component == 2{
//            str = (AddressManagerInstance.getAArrayByIndex(curp, j: curc)[row] as! NSDictionary)["s"] as! String
//        }
//        let lab = UILabel()
//        lab.frame = CGRectMake(0, 0, pickerView.frame.width, 30)
//        lab.textAlignment = NSTextAlignment.Center
//        lab.text = str
//        lab.font = UIFont.systemFontOfSize(14)
//        return lab
//    }
//    
//    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
//        return (self.frame.width - 20)/3
//    }
//    
//    var pickerMessage = String()
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        var curs = 0
//        if component == 0{
//            curp = row
//            pickerView.reloadComponent(1)
//            pickerView.selectRow(0, inComponent: 1, animated: true)
//            pickerView.reloadComponent(2)
//            pickerView.selectRow(0, inComponent: 2, animated: true)
//            curc = 0
//        }else if component == 1{
//            curc = row
//            pickerView.reloadComponent(2)
//            pickerView.selectRow(0, inComponent: 2, animated: true)
//        }else if component == 2{
//            curs = row
//        }
//        address = AddressManagerInstance.getSStrByIndex(curp, j: curc, k: curs)
//        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
//    }
//}
