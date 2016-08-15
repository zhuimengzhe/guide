//
//  RegExp.swift
//  MyMint
//
//  Created by zhoukang on 15/5/27.
//  Copyright (c) 2015年 Oracleen. All rights reserved.
//  Author:OneVCat

import Foundation
//自定义运算符
//infix operator =~ {
    //associativity none
    //precedence 130
//}

//func =~(lhs: String, rhs: String) -> Bool {
    //do {
        //return try RegexHelper(rhs).match(lhs)
    //} catch _ {
        //return false
    //}
//}

//正则表达式辅助
//struct RegexHelper{
    //let regex:NSRegularExpression?
    //init(_ pattern:String) throws
    //{
        //try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
    //}
    
    //func match(input:String) -> Bool{
        //if let matches = regex?.matchesInString(input, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, input.characters.count)){
            //return matches.count > 0
        //}else{
            //return false
        //}
    //}
//}

// 正则判断手机号码地址格式
func isMobileNumber(mobileNum:String) -> Bool
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    let  MOBILE = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
    let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM)
    let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
    let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
    
    if regextestmobile.evaluateWithObject(mobileNum) || regextestcm.evaluateWithObject(CM) || regextestcu.evaluateWithObject(CU) || regextestct.evaluateWithObject(CT){
        if regextestmobile.evaluateWithObject(mobileNum){
            print("China Mobile")
        }else if regextestcm.evaluateWithObject(CM){
            print("China Telecom")
        }else if regextestcu.evaluateWithObject(CU){
            print("China Unicom")
        }else{
            print("Unknown")
        }
        return true
    }else{
        return false
    }
}
//是否是有效的正则表达式
func isValidateRegularExpression(strDestination:String,byExperssion:String) -> Bool{
    let perdicate = NSPredicate(format: "SELF MATCHES %@", byExperssion)
    return perdicate.evaluateWithObject(strDestination)
}

//验证email
func isValidateEmail(email:String) -> Bool{
    let strRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"
    let rt = isValidateRegularExpression(email, byExperssion: strRegex)
    return rt
}

//验证电话号码
func isValidateTelNumber(number:String) -> Bool{
    let strRegex = "[0-9]{1,20}"
    let rt = isValidateRegularExpression(number, byExperssion: strRegex)
    return rt
}

//是否是有效的手机号码(判断比较笼统)
func isValidCellPhoneNumber(number:String) -> Bool{
    let regex = "^1[3|4|5|8|7][0-9]\\d{8}$"
    return isValidateRegularExpression(number, byExperssion: regex)
}

//验证是不是超过6位的密码
func isValidPasswordWith6to18NumberOrLetters(password:String) -> Bool{
    let regex = "^[A-Za-z0-9]{6,18}$"
    return isValidateRegularExpression(password, byExperssion: regex)
}
