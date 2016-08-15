//
//  UserModel.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
class UserModel {
    /// 用户id(uuid)
    var id:String!
    //用户头像
    var logo:String!
    //用户注册手机号
    var phone:String!
    //用户登录密码,md5加密
    var pwd:String!
    //用户状态,1 正常 0 冻结
    var status:String!
    //用户选择的语言
    var language:String!
    //注册时间
    var addtime:String!
    //用户积分
    var point:Double!
    
    //构造方法
    init(dict:[String:String]) {
        id = dict["u_id"] ?? ""
        logo = dict["u_logo"] ?? ""
        phone = dict["u_phone"] ?? ""
        pwd = dict["u_pwd"] ?? ""
        status = dict["u_status"] ?? ""
        language = dict["u_language"] ?? ""
        addtime = dict["u_addtime"] ?? ""
        point = Double(dict["u_point"] ?? "0")
    }
}