//create by mc...2015-12-09
import UIKit

let HttpInstance = HttpController()//全局网络请求单例

protocol HttpErrorDelegate{
    func findErrorWhenLoading()
}

class HttpController: NSObject {
    
    //异步加载网络请求-POST方式
    /*Paramor mark:
     1.url: 接口URL
     2.parmaeter: post方式发送数据参数<key: value>
     3.complete: 请求结束，闭包处理响应结果
     */
    
    func mcAlamofireObject(url: String, parameter: [String: AnyObject]? = nil, complete:(object: NSDictionary!)->Void){
        
        McNetInstance.request(.POST, url: url, parameter: parameter) { (response) -> () in
            if let error = response.error{
                if error.code == -1001{
                    AlertInstance.showAlert("服务器连接超时 :(")
                }else{
                    AlertInstance.showAlert("服务器连接失败 :(")
                }
                return
            }
            
            if response.response?.statusCode != 200{
                print(response.response?.statusCode)
                AlertInstance.showAlert("服务器响应出错")
                return
            }
            
            if let dict = response.result as? NSDictionary{
                print(dict)
                if dict.getIntOrStr("code") == "0"{
                    print(dict.getIntOrStr("message"))
                    AlertInstance.showAlert(dict.getIntOrStr("message"))
                    complete(object: nil)
                    return
                }else if dict.getIntOrStr("code") == "1"{
                    complete(object: dict)
                    return
                }else{
                    complete(object: dict)
                    return
                }
            }
            complete(object: nil)
            AlertInstance.showAlert("不知为何就抽风了，请谅解！")
        }
    }
    
    func mcAlamofireArray(url: String, parameter: [String: AnyObject]? = nil, complete:(object: NSDictionary!)->Void){
        McNetInstance.request(.POST, url: url, parameter: parameter) { (response) -> () in
            if let error = response.error{
                if error.code == -1001{
                    AlertInstance.showAlert("服务器连接超时 :(")
                }else{
                    AlertInstance.showAlert("服务器连接失败 :(")
                }
                return
            }
            if response.response?.statusCode != 200{
                return
            }
            if let dict = response.result as? NSDictionary{
                complete(object: dict)
                return
            }
        }
    }
    
    //图片首次加载后存在本地
    func mcLoadImgURLToBound(urlString: String, imgNameEx: String, handle: (UIImage!) -> Void){
        let imgNames = urlString.useNs().componentsSeparatedByString("/")
        var imgName = ""
        for s in imgNames{
            imgName.appendContentsOf(s)
        }
        if let img = FileUtilController.findImgByBound("\(imgNameEx)-\(imgName)"){
            handle(img)
        }else{
            self.mcLoadImgURL(urlString, handle: { (img: UIImage!) -> Void in
                if img != nil{
                    FileUtilController.saveImgToBound(img, imgName: "\(imgNameEx)-\(imgName)")
                }
                handle(img)
            })
        }
    }
    
    //网络加载图片
    func mcLoadImgURL(urlString: String, handle: (UIImage!) -> Void){
        if let url = NSURL(string: urlString){
            let request:NSURLRequest = NSURLRequest(URL:url)
            //let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            //let task = session.dataTaskWithRequest(request){ (data: NSData?,response: NSURLResponse?, error: NSError?)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response: NSURLResponse?,data: NSData?, error: NSError?) -> Void in
                if data != nil{
                    if let img = UIImage(data: data!){
                        handle(img)
                        return
                    }
                }
                print("error: no image")
                handle(nil)
            }
            //task.resume()
        }else{
            print("error: wrong url")
            handle(nil)
        }
    }
    
    //闭包上传头像表单
    func mcUploadHeadImg(urlString: String , data: NSData!, parameters: [String: String]? = nil, handle: (NSDictionary!) -> Void){
        if let url = NSURL(string: urlString){
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            let MPboundary = NSString(format: "--%@", "AaB03x")
            let endboundary = NSString(format: "%@--", MPboundary)
            let body = NSMutableString()
            
            ////            let dic = Dictionary()
            for key in parameters!.keys{
                body.appendFormat("%@\r\n", MPboundary)
                body.appendFormat("Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key)
                body.appendFormat("%@\r\n", parameters![key]!)
            }
            
            body.appendFormat("%@\r\n", MPboundary)
            body.appendFormat("Content-Disposition: form-data; name=\"file\"; filename=\"666.png\"\r\n", NSUTF8StringEncoding)
            body.appendFormat("Content-Type: image/png\r\n\r\n")
            let end = NSString(format: "\r\n%@", endboundary)
            
            let myRequestData = NSMutableData()
            myRequestData.appendData(body.dataUsingEncoding(NSUTF8StringEncoding)!)
            myRequestData.appendData(data ?? NSData())
            myRequestData.appendData(end.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let content = NSString(format: "multipart/form-data; boundary=%@","AaB03x")
            
            request.setValue(content as String, forHTTPHeaderField: "Content-Type")
            let strLength = NSString(format: "%ld",myRequestData.length)
            request.setValue(strLength as String, forHTTPHeaderField: "Content-Length")
            request.HTTPMethod = "POST"
            request.HTTPBody = myRequestData
            //let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            //let task = session.dataTaskWithRequest(request){ (data: NSData?,response: NSURLResponse?, error: NSError?)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response: NSURLResponse?,data: NSData?, error: NSError?) -> Void in
                if error != nil{
                    print(error)
                    handle(nil)
                    return
                }
                if data != nil{
                    if let strRet = NSString(data: data!, encoding:NSUTF8StringEncoding){
                        print(strRet)
                        let outputStr:NSMutableString = NSMutableString(string: strRet)
                        outputStr.replaceOccurrencesOfString("\n", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
                        outputStr.replaceOccurrencesOfString("\r", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
                        let dataNew = outputStr.dataUsingEncoding(NSUTF8StringEncoding)
                        if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(dataNew!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary{
                            handle(jsonResult)
                        }else{
                            print("error: pamars anysise wrong")
                            handle(nil)
                        }
                    }else{
                        print("error: pamars anysise wrong")
                        handle(nil)
                    }
                }else{
                    print("error: pamars data is null")
                    handle(nil)
                }
            }
            //task.resume()
        }
    }
    
    //闭包上传图片数组表单
    func mcUploadHeadImg(urlString: String , datas: [NSData!], parameters: [String: String]? = nil, handle: (NSDictionary!) -> Void){
        if let url = NSURL(string: urlString){
            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
            let MPboundary = NSString(format: "--%@", "AaB03x")
            let endboundary = NSString(format: "%@--", MPboundary)
            let body = NSMutableString()
            
            ////            let dic = Dictionary()
            for key in parameters!.keys{
                body.appendFormat("%@\r\n", MPboundary)
                body.appendFormat("Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key)
                body.appendFormat("%@\r\n", parameters![key]!)
            }
            
            //            body.appendFormat("%@\r\n", MPboundary)
            //            body.appendFormat("Content-Disposition: form-data; name=\"file\"; filename=\"666.png\"\r\n", NSUTF8StringEncoding)
            //            body.appendFormat("Content-Type: image/png\r\n\r\n")
            let end = NSString(format: "\r\n%@", endboundary)
            
            let myRequestData = NSMutableData()
            for data in datas{
                body.appendFormat("%@\r\n", MPboundary)
                body.appendFormat("Content-Disposition: form-data; name=\"file\"; filename=\"666.png\"\r\n", NSUTF8StringEncoding)
                body.appendFormat("Content-Type: image/png\r\n\r\n")
                
                myRequestData.appendData(body.dataUsingEncoding(NSUTF8StringEncoding)!)
                myRequestData.appendData(data)
            }
            myRequestData.appendData(end.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            let content = NSString(format: "multipart/form-data; boundary=%@","AaB03x")
            
            request.setValue(content as String, forHTTPHeaderField: "Content-Type")
            let strLength = NSString(format: "%ld",myRequestData.length)
            request.setValue(strLength as String, forHTTPHeaderField: "Content-Length")
            request.HTTPMethod = "POST"
            request.HTTPBody = myRequestData
            //let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){ (response: NSURLResponse?,data: NSData?, error: NSError?) -> Void in
                if error != nil{
                    print(error)
                    handle(nil)
                    return
                }
                if data != nil{
                    if let strRet = NSString(data: data!, encoding:NSUTF8StringEncoding){
                        print(strRet)
                        let outputStr:NSMutableString = NSMutableString(string: strRet)
                        outputStr.replaceOccurrencesOfString("\n", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
                        outputStr.replaceOccurrencesOfString("\r", withString: "\\n", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
                        let dataNew = outputStr.dataUsingEncoding(NSUTF8StringEncoding)
                        if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(dataNew!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary{
                            handle(jsonResult)
                        }else{
                            print("error: pamars anysise wrong")
                            handle(nil)
                        }
                    }else{
                        print("error: pamars anysise wrong")
                        handle(nil)
                    }
                }else{
                    print("error: pamars data is null")
                    handle(nil)
                }
            }
            //task.resume()
        }
    }
}





