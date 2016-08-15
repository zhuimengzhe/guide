//
//  XMLFileController.swift
//  Guide
//
//  Created by dingmc on 16/1/7.
//  Copyright © 2016年 dingmc. All rights reserved.
//

import UIKit

let XMLFileInstance = XMLFileController()

class XMLFileController: NSObject, NSXMLParserDelegate{
    
    func getCurFile(){
        let path = NSBundle.mainBundle().pathForResource("p", ofType: "xml")
        let parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: path!))
        parser?.delegate = self
        
        printLog(parser?.parse())
        printLog(str)
    }
    
    var strArray = [String]()
    
    var read = false
    
    var name: String!
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        printLog("start")
//        printLog(elementName)
//        printLog(namespaceURI)
//        printLog(qName)
//        printLog(attributeDict)
//        printLog(attributeDict["name"])
        if let n = attributeDict["name"]{
            self.name = n
        }
        
//        if attributeDict["name"] == "hero_name"{
            self.read = true
//        }
        if elementName == "string-array"{
            self.read = false
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        printLog("end")
//        printLog(elementName)
//        printLog(namespaceURI)
//        printLog(qName)
//        if elementName == "string-array"{
            self.read = false
//        }
    }
    
    var lastName = ""
    var str = ""
    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        printLog("found")
//        printLog(string)
        
        if self.name != nil && string != "" && self.read{
            let py = string.transformPinyin().replaceByString(" ", withString: "_")
            if self.name == lastName{
                str += "{\"name\":\"\(string)\", \"py\":\"\(py)\"},"
            }else{
                lastName = self.name
                str = str.substringLast()
                str += "],"
                str += "\"\(self.name)\":["
//                str += "{\"pid\":\"\(self.name)\", \"cs\":["
            }
//            printLog("{\"pid\":\"\(self.name)\", \"name\":\"\(string)\", \"py\":\"\(py)\"},")
//            printLog("{\"name\":\"\(string)\", \"py\":\"\(py)\"},")
        }
//        if self.read && string.trim() != ""{
//            self.strArray.append(string.transformPinyin())
//        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        printLog("error-->>")
        printLog(parseError)
    }
}
