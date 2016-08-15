
import UIKit

enum McMethod{
    case GET
    case POST
}

let McNetInstance = McNetWorking.sharedInstance
class McNetWorking: NSObject{
    static let sharedInstance = McNetWorking()
    
    //请求超时参数
    var timeoutInterval: NSTimeInterval = 15.0
    override init() {
        super.init()
    }
    
    convenience init(timeoutInterval: NSTimeInterval) {
        self.init()
        self.timeoutInterval = timeoutInterval
    }

    func request(method: McMethod, url: String, parameter: [String: AnyObject]? = nil, mcResponse: (response: McReaponse)->()){
        let url = NSURL(string: url)
        if url == nil{
            return
        }
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = self.getMethodString(method)
        let data = self.getParameterString(parameter).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.timeoutInterval = timeoutInterval
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            mcResponse(response: self.getResponse(response, data: data, error: error))
        }
    }
    
    //响应结果处理
    func getResponse(response: NSURLResponse?, data: NSData?, error: NSError?)->McReaponse{
        print(response)
        let mcResponse = McReaponse(response: response, data: data, error: error)
        if error != nil{
            return mcResponse
        }
        if data == nil{
            return mcResponse
        }
        
        if let strRet = NSString(data: data!, encoding:NSUTF8StringEncoding){
            mcResponse.result = strRet
        }
        if let dict = (try? NSJSONSerialization.JSONObjectWithData(self.handleData(data!), options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary{
            mcResponse.result = dict
        }
        if let array = (try? NSJSONSerialization.JSONObjectWithData(self.handleData(data!), options: NSJSONReadingOptions.MutableContainers)) as? NSArray{
            mcResponse.result = array
        }
        return mcResponse
    }
}

extension McNetWorking{
    //MARK: - 将请求参数转成String
    func getParameterString(parameter: [String: AnyObject]?)->String{
        if parameter == nil{
            return ""
        }
        var str = ""
        for key in parameter!.keys{
            var value = parameter![key]
            if value == nil{
                value = ""
            }
            str += "\(key)=\(value!)&"
        }
        return str.substringLast()
    }
    
    //MARK: - 请求方式转换
    func getMethodString(method: McMethod)->String{
        switch method{
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
    
    //MARK: - 处理data
    func handleData(data: NSData)->NSData!{
        if let strRet = NSString(data: data, encoding:NSUTF8StringEncoding){
            let outputStr:NSMutableString = NSMutableString(string: strRet)
            outputStr.replaceOccurrencesOfString("\n", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
            outputStr.replaceOccurrencesOfString("\r", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
            outputStr.replaceOccurrencesOfString("\t", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
            return outputStr.dataUsingEncoding(NSUTF8StringEncoding)
        }
        return data
    }
    
}

class McReaponse: NSObject{
    var response: NSHTTPURLResponse?
    var data: NSData?
    var result: AnyObject?
    var error: NSError?
    init(response: NSURLResponse?, data: NSData?, error: NSError?){
        super.init()
        self.response = response as? NSHTTPURLResponse
        self.data = data
        self.error = error
    }
}

