
import UIKit

class CustomTextView: UITextView, UITextViewDelegate {
    private let placeholderLabel: UILabel = UILabel()
    
    @IBInspectable
    var placeholder: String? {
        get { return placeholderLabel.text}
        set { self.addPlaceholderLab(newValue) }
    }

    private  func addPlaceholderLab(str: String!){
        self.delegate = self
        placeholderLabel.text = str
        placeholderLabel.textColor = Color_ccc
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPointMake(4, 6)
        self.addSubview(placeholderLabel)
    }
    
    func textViewDidChange(textView: UITextView){
        if textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0{
            textView.addSubview(placeholderLabel)
        }else{
            placeholderLabel.removeFromSuperview()
        }
    }
}


