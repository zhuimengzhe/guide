//
//
//import UIKit
//
//enum McKeyBoardType{
//    case Address
//    case BorthDay
//    case Single
//}
//
//class McTextField: UITextField {
//
//    
//}
//extension UITextField{
//    func setMcKeyBoard(mcKeyType: McKeyBoardType){
//        switch mcKeyType{
//        case .Address:
//            self.keyboardBeAddress()
//            break
//        case .BorthDay:
//            break
//        case .Single:
//            break
//        }
//    }
//    
//    //调用此方法后，输入框键盘变为选择地址...
//    func keyboardBeAddress(){
//        let addressKeyboard = McAddressKeyboard()
//        addressKeyboard.addTarget(self, action: "addressChanged:", forControlEvents: UIControlEvents.ValueChanged)
//        self.inputView = addressKeyboard
//    }
//    
//    func addressChanged(keyboard: McAddressKeyboard){
//        self.text = keyboard.address
//    }
//    
//    func keyboardBeBorthday(){
//        
//    }
//    
//    func keyboardBeSingle(){
//        
//    }
//}