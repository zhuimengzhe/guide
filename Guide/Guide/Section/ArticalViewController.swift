
import UIKit

class ArticalViewController: BaseViewController {
    
    var type:Int = 0
    let wbView = UIWebView(frame: CGRectZero)
    var activiindictor = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        wbView.frame = self.view.bounds
        activiindictor.frame = self.view.bounds
        wbView.scrollView.scrollEnabled = false
        wbView.delegate = self
        activiindictor.hidesWhenStopped = true
        view.addSubview(wbView)
        view.addSubview(activiindictor)
        willOnSearch()
    }
    
    func willOnSearch(){
        HttpInstance.requestString(.GET, Http_aboutus, parameters: ["type"  : String(self.type + 1)]){
           [unowned self] obj in
            self.wbView.loadHTMLString(obj, baseURL: nil)
        }
    }
}
extension ArticalViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView){
        activiindictor.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView){
        activiindictor.stopAnimating()
    }
}