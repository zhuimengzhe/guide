//
//  ExtensionSwift.swift
//  Guide
//
//  Created by apple on 4/26/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
//MARK:String extension
extension String{
    func stringByAppendingPathComponent(pathConmonent: String) -> String {
        return self.useNs().stringByAppendingPathComponent(pathConmonent) as String
    }
    
    var lastPathComponent: String {
        get {
            return self.useNs().lastPathComponent
        }
    }
    
    func isAllDigit() -> Bool {
        for uni in unicodeScalars{
            if NSCharacterSet.decimalDigitCharacterSet().longCharacterIsMember(uni.value){
                continue
            }
            return false
        }
        return true
    }
    
    var MD5:String {
        let cString = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let length = CUnsignedInt(
            self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        )
        
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cString!,length,result)
        return String(format:"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],
                      result[9],result[10],result[11],result[12],result[13],result[14],result[15])
    }
    //分割字符串
    func split(s:String) -> [String]
    {
        if s.isEmpty
        {
            var x = [String]()
            
            for y in self.characters{
                x.append(String(y))
                
            }
            return x
            
        }
        return self.componentsSeparatedByString(s)
    }
    static func isNullOrEmpty(str: String?) -> Bool {
        if str == nil {
            return true
        }
        if str!.isEmpty {
            return true
        }
        return false
    }
    
    //去掉左右空格
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    //是否包含字符串
    func has(s:String) -> Bool
    {
        if (self.rangeOfString(s, options: NSStringCompareOptions.LiteralSearch, range: nil, locale:nil) != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //是否包含前缀
    func hasBegin(s:String) -> Bool
    {
        if self.hasPrefix(s)
        {
            return true
        }else
        {
            return false
        }
    }
    
    //请字符串高度
    func stringHeightWithFontSize(fontSize:CGFloat,width:CGFloat) -> CGFloat
    {
        //固定好字体宽度和字号大小后求字体所占的高度
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width, CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        
        let attributes = [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRectWithSize(size, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context:nil )
        
        return rect.size.height
    }
    
    
    func addToPasteboard(){//复制到剪切版
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = self
    }
    
    func transformPinyin() -> String{
        let str = NSMutableString(string: self)
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false)//汉子转拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)//去除拼音声调
        return str as String
    }
    
    func Pattern(pattern:String) -> Bool{//验证正则表达式
        let expression: NSRegularExpression?
        do {
            expression = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        } catch _ as NSError {
            expression = nil
        }
        let matches = expression?.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count))
        return matches > 0
    }
    
    //将字符串里某些字段替换
    func replaceByString(oString: String, withString: String) -> String{
        let outputStr:NSMutableString = NSMutableString(string: self)
        outputStr.replaceOccurrencesOfString(oString, withString: withString, options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, outputStr.length))
        return outputStr as String
    }
    
    func stringToInt() -> Int{
        if let i = Int(self){
            return i
        }else{
            return 0
        }
    }
    
    func stringToDate() -> NSDate?{
        
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if format.dateFromString(self) == nil{
            format.dateFormat = "yyyy-MM-dd"
        }
        return format.dateFromString(self)
    }
    
    func useNs() -> NSString{
        return NSString(string: self)
    }
    
    func substringLast() -> String{
        var ns = self.useNs()
        if ns.length > 0{
            ns = ns.substringToIndex(ns.length-1)
        }
        return ns as String
    }
    
    var length: Int{
        let ns = self.useNs()
        return ns.length
    }
    
    var count:Int{
        get {
            return self.characters.count
        }
    }
    
    func subStringToI(i: Int) -> String{
        var ns = self.useNs()
        if ns.length >= i {
            ns = ns.substringToIndex(i)
        }
        return ns as String
    }
    
    func beAttributeString(color: UIColor, text: String) -> NSMutableAttributedString{
        let ns = self.useNs()
        let attrbuteStr = NSMutableAttributedString(string: self)
        if ns.rangeOfString(text).location != NSNotFound{
            attrbuteStr.addAttribute(NSForegroundColorAttributeName, value: color, range: ns.rangeOfString(text))
        }
        return attrbuteStr
    }
}

extension Array {
    
    func forEach(body: (item: Array.Generator.Element, i: Int) -> Void) {
        var i = 0
        for item in self {
            body(item: item, i: i)
            i += 1
        }
    }
}

