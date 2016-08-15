//
//  ProvinceModel.swift
//  Guide
//
//  Created by apple on 4/28/16.
//  Copyright © 2016 dingmc. All rights reserved.
//

import Foundation
class ProvinceModel {
    //省份id
    var provinceid:String!
    //省份名称 中文
    var province1:String!
    //省份名称 英文
    var province2:String!
    //省份名称 日文
    var province3:String!
    //省份名称 韩文
    var province4:String!
    //省份名称 西班牙文
    var province5:String!
    //构造方法
    init(dict:[String:String]) {
        provinceid = dict["provinceid"] ?? ""
        province1 = dict["province1"] ?? ""
        province2 = dict["province2"] ?? ""
        province3 = dict["province3"] ?? ""
        province4 = dict["province4"] ?? ""
        province5 = dict["province5"] ?? ""
    }
}